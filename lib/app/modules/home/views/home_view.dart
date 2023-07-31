import 'dart:collection';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:kotobati/app/core/helpers/common_function.dart';
import 'package:kotobati/app/core/models/book_model.dart';
import 'package:kotobati/app/core/utils/app_config.dart';
import 'package:kotobati/app/core/utils/app_extension.dart';
import 'package:kotobati/app/core/utils/app_theme.dart';
import 'package:kotobati/app/modules/home/views/components/home_app_bar.dart';
import 'package:mirai_responsive/mirai_responsive.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:html/parser.dart' show parseFragment;
import 'package:html/dom.dart' as dom;
import 'package:uuid/uuid.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyHomePage(controller: controller);
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final HomeController controller;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      useOnDownloadStart: true,
      cacheEnabled: true,
      useShouldOverrideUrlLoading: true,
      transparentBackground: true,
      mediaPlaybackRequiresUserGesture: false,
      horizontalScrollBarEnabled: false,
      disableHorizontalScroll: true,
    ),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
    ),
    ios: IOSInAppWebViewOptions(
      allowsInlineMediaPlayback: true,
    ),
  );

  late PullToRefreshController pullToRefreshController;
  late ContextMenu contextMenu;
  String url = "";
  double progress = 0;
  final TextEditingController urlController = TextEditingController();

  final ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();

    // createAppFolder();

    contextMenu = ContextMenu(
        menuItems: <ContextMenuItem>[
          ContextMenuItem(
            androidId: 1,
            iosId: "1",
            title: "Special",
            action: () async {
              miraiPrint("Menu item Special clicked!");
              miraiPrint(await webViewController?.getSelectedText());
              await webViewController?.clearFocus();
            },
          )
        ],
        options: ContextMenuOptions(hideDefaultSystemContextMenuItems: false),
        onCreateContextMenu: (InAppWebViewHitTestResult hitTestResult) async {
          miraiPrint("onCreateContextMenu");
          miraiPrint(hitTestResult.extra);
          miraiPrint(await webViewController?.getSelectedText());
        },
        onHideContextMenu: () {
          miraiPrint("onHideContextMenu");
        },
        onContextMenuActionItemClicked: (ContextMenuItem contextMenuItemClicked) async {
          Object? id = (Platform.isAndroid)
              ? contextMenuItemClicked.androidId
              : contextMenuItemClicked.iosId;
          miraiPrint("onContextMenuActionItemClicked: $id ${contextMenuItemClicked.title}");
        });

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(color: AppTheme.keyAppColorDark),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );

    IsolateNameServer.registerPortWithName(
      _port.sendPort,
      'downloader_send_port',
    );

    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = DownloadTaskStatus(data[1]);
      int progress = data[2];
      setState(() {});
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    final SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      //  appBar: progress < 1.0 ? null : homeAppBar(webViewController),
      body: Padding(
        padding: EdgeInsets.only(
          top: context.topPadding,
          // bottom: context.bottomAdding / 2,
          bottom: 80,
        ),
        child: SizedBox(
          height: size.height - context.topPadding - 80,
          width: size.width,
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                bottom: 60,
                child: InAppWebView(
                  key: webViewKey,
                  // contextMenu: contextMenu,
                  initialUrlRequest: URLRequest(url: Uri.parse(AppConfig.webUrl)),
                  // initialFile: "assets/index.html",
                  initialUserScripts: UnmodifiableListView<UserScript>([]),
                  initialOptions: options,
                  pullToRefreshController: pullToRefreshController,
                  onWebViewCreated: (InAppWebViewController controller) {
                    webViewController = controller;
                    miraiPrint('webViewController != null');
                    setState(() {});
                  },
                  onLoadStart: (InAppWebViewController controller, Uri? url) {
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                  },

                  onDownloadStartRequest: widget.controller.onDownloadStartRequest,
                  androidOnPermissionRequest: androidOnPermissionRequest,
                  shouldOverrideUrlLoading: shouldOverrideUrlLoading,
                  onLoadStop: onLoadStop,
                  onLoadError:
                      (InAppWebViewController controller, Uri? url, int code, String message) {
                    pullToRefreshController.endRefreshing();
                  },
                  onProgressChanged: (InAppWebViewController controller, int progress) {
                    if (progress == 100) {
                      pullToRefreshController.endRefreshing();
                    }
                    setState(() {
                      this.progress = progress / 100;
                      urlController.text = url;
                    });
                  },
                  onUpdateVisitedHistory:
                      (InAppWebViewController controller, Uri? url, bool? androidIsReload) {
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                  },
                  onConsoleMessage:
                      (InAppWebViewController controller, ConsoleMessage consoleMessage) {
                    miraiPrint(consoleMessage);
                  },
                ),
              ),

              // if (progress < 1.0)
              //   Container(
              //     color: AppTheme.keyAppBlackColor,
              //     child: const Center(
              //       child: CircularProgressIndicator.adaptive(
              //         valueColor: AlwaysStoppedAnimation<Color>(AppTheme.keyAppColor),
              //       ),
              //     ),
              //   ),

              if (progress < 1.0)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(
                    value: progress,
                    color: AppTheme.keyAppColorDark,
                    backgroundColor: AppTheme.keyAppColor.withOpacity(0.6),
                  ),
                ),

              PositionedDirectional(
                start: 16,
                bottom: 4,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    AnimatedScale(
                      duration: const Duration(milliseconds: 200),
                      scale: progress == 1.0 ? 1 : 0,
                      child: FutureBuilder<bool>(
                        future:
                            webViewController == null ? null : webViewController!.canGoForward(),
                        builder: (_, AsyncSnapshot<bool> snapshot) {
                          final bool canGoForward = snapshot.data ?? false;
                          miraiPrint('canGoForward $canGoForward');
                          return FloatingActionButton(
                            // mini: true,
                            heroTag: "FloatingActionButton1",
                            tooltip: 'Go Forward',
                            onPressed: () async {
                              miraiPrint('GoForward Clicked');
                              await webViewController!.goForward();
                            },
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    AnimatedScale(
                      duration: const Duration(milliseconds: 200),
                      scale: progress == 1.0 ? 1 : 0,
                      child: FutureBuilder<bool>(
                        future: webViewController == null ? null : webViewController!.canGoBack(),
                        builder: (_, AsyncSnapshot<bool> snapshot) {
                          final bool canGoBack = snapshot.data ?? false;
                          miraiPrint('canGoBack $canGoBack');
                          return FloatingActionButton(
                            //  mini: true,
                            heroTag: "FloatingActionButton2",
                            tooltip: 'Go Back',
                            hoverColor: Colors.red.withOpacity(.2),
                            onPressed: () async {
                              miraiPrint('GoBack Clicked');
                              await webViewController!.goBack();
                            },
                            child: const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<NavigationActionPolicy?> shouldOverrideUrlLoading(
      InAppWebViewController controller, NavigationAction navigationAction) async {
    Uri uri = navigationAction.request.url!;

    if (!["http", "https", "file", "chrome", "data", "javascript", "about"].contains(uri.scheme)) {
      if (await canLaunch(url)) {
        // Launch the App
        await launch(url);
        // and cancel the request
        return NavigationActionPolicy.CANCEL;
      }
    }

    return NavigationActionPolicy.ALLOW;
  }

  Future<void> onLoadStop(InAppWebViewController controller, Uri? url) async {
    miraiPrint("onLoadStop");
    final String? urlString = url?.toString();
    miraiPrint("URI URL path: $urlString");
    if (urlString != null && urlString.contains('pdf')) {
      miraiPrint('<==========================>');
      String? html = await controller.getHtml();
      miraiPrint("html1: $html");
      miraiPrint('<==========================>');
      if (html == null) return;

      // Extract the title
      RegExp titleRegex = RegExp('<title>(.*?)</title>');
      String title = titleRegex.firstMatch(html)?.group(1) ?? '';

      String? chosenTitle = widget.controller.chosenBook.value?.longTitle;
      if (chosenTitle == null || (chosenTitle != title)) {
        // Extract the description
        RegExp descriptionRegex = RegExp('<meta name="description" content="(.*?)"');
        String encodedDescription = descriptionRegex.firstMatch(html)?.group(1) ?? '';
        String description = _decodeHtmlEntities(encodedDescription);

        // Extract the cover image URL
        RegExp imageRegex = RegExp('<meta property="og:image" content="(.*?)"');
        String coverImageUrl = imageRegex.firstMatch(html)?.group(1) ?? '';

        // Do something with the extracted information
        miraiPrint('Title: $title');
        miraiPrint('Description: $description');
        miraiPrint('Cover Image URL: $coverImageUrl');

        /// Split title to get the author, [Book title] pdf - [author name] | كتوباتي
        Tuple3<String, String, String> tupleResult = splitTitle(title);

        final String id = const Uuid().v1();

        /// Now, The User chosen this book to read...
        final Book book = Book(
          id: id,
          title: tupleResult.item1,
          longTitle: title,
          author: tupleResult.item2,
          description: description,
          image: coverImageUrl,
        );

        /// Now Store this book in the memory...
        widget.controller.chosenBook.value = book;
      }
    }

    pullToRefreshController.endRefreshing();
    setState(() {
      this.url = url.toString();
      urlController.text = this.url;
    });
  }

  Tuple3<String, String, String> splitTitle(String title) {
    /// Title Format = 'Book Title - Author Name | Publisher';
    // Split the title by the first delimiter (' - ')
    List<String> titleParts = title.split(' - ');
    // Extract the author and remaining part
    String bookTitle = titleParts.isNotEmpty ? titleParts[0] : '';
    String remainingPart = titleParts.isNotEmpty ? titleParts[1] : '';

    // Split the remaining part by the second delimiter (' | ')
    List<String> remainingParts = remainingPart.split(' | ');

    // Extract the book title and publisher
    String author = remainingParts.isNotEmpty ? remainingParts[0] : '';
    String publisher = remainingParts.length > 1 ? remainingParts[1] : '';

    miraiPrint('<====================>');
    miraiPrint('Author: $author       ');
    miraiPrint('Book Title: $bookTitle');
    miraiPrint('Publisher: $publisher ');
    miraiPrint('<====================>');

    return Tuple3<String, String, String>(bookTitle, author, publisher);
  }

  String _decodeHtmlEntities(String input) {
    var document = parseFragment(input);
    String decodedText = '';
    for (var node in document.nodes) {
      if (node is dom.Text) {
        decodedText += node.text;
      } else if (node is dom.Element) {
        decodedText += node.text;
      }
    }
    return decodedText;
  }

  Future<PermissionRequestResponse> androidOnPermissionRequest(
    InAppWebViewController controller,
    String origin,
    List<String> resources,
  ) async {
    return PermissionRequestResponse(
      resources: resources,
      action: PermissionRequestResponseAction.GRANT,
    );
  }
}

class Tuple3<T1, T2, T3> {
  final T1 item1;
  final T2 item2;
  final T3 item3;

  Tuple3(this.item1, this.item2, this.item3);
}
