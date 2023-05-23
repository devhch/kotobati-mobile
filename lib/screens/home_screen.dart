/*
* Created By Hamza Chaouki.
* On 7/8/2021.
*/

import 'dart:collection';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:kotobati/constants/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useOnDownloadStart: true,
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  late PullToRefreshController pullToRefreshController;
  late ContextMenu contextMenu;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();

  Future<void> requestPermission() async {
    final PermissionStatus status = await Permission.storage.request();
    debugPrint("PermissionStatus ${status}");
    if (status == PermissionStatus.permanentlyDenied) {
      openAppSettings();
    }
  }

  ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();

    contextMenu = ContextMenu(
        menuItems: [
          ContextMenuItem(
              androidId: 1,
              iosId: "1",
              title: "Special",
              action: () async {
                print("Menu item Special clicked!");
                print(await webViewController?.getSelectedText());
                await webViewController?.clearFocus();
              })
        ],
        options: ContextMenuOptions(hideDefaultSystemContextMenuItems: false),
        onCreateContextMenu: (hitTestResult) async {
          print("onCreateContextMenu");
          print(hitTestResult.extra);
          print(await webViewController?.getSelectedText());
        },
        onHideContextMenu: () {
          print("onHideContextMenu");
        },
        onContextMenuActionItemClicked: (contextMenuItemClicked) async {
          var id = (Platform.isAndroid)
              ? contextMenuItemClicked.androidId
              : contextMenuItemClicked.iosId;
          print("onContextMenuActionItemClicked: " +
              id.toString() +
              " " +
              contextMenuItemClicked.title);
        });

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(color: Constants.APP_COLOR_DARK),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );

    // requestPermission();

    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
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
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(statusBarColor: Constants.APP_COLOR_DARK),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            //  toolbarHeight: 120,
            backgroundColor: Constants.APP_COLOR,
            actions: [
              // IconButton(
              //   icon: Icon(Icons.download),
              //   onPressed: () async {
              //     await requestPermission();
              //   },
              // ),
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  webViewController?.goBack();
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
                onPressed: () {
                  webViewController?.goForward();
                },
              ),
              Spacer(),
              IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                onPressed: () {
                  webViewController?.reload();
                },
              ),

              //  Expanded(
              // child: Container(
              //   color: Colors.red,
              //   child: SvgPicture.network(
              //     //    "assets/icon/logo.svg",
              //     "https://www.kotobati.com/sites/default/files/logo.svg",
              //     //  height: 30,
              //     height: 100,
              //     width: double.infinity,
              //     fit: BoxFit.fitWidth,
              //   ),
              // ),
              // ),
            ],
          ),
          body: Stack(
            children: [
              Container(color: Constants.APP_COLOR),
              InAppWebView(
                key: webViewKey,
                // contextMenu: contextMenu,
                initialUrlRequest:
                    URLRequest(url: Uri.parse(Constants.WEB_URL)),
                // initialFile: "assets/index.html",
                initialUserScripts: UnmodifiableListView<UserScript>([]),
                initialOptions: options,
                pullToRefreshController: pullToRefreshController,
                onWebViewCreated: (controller) {
                  webViewController = controller;
                },
                onLoadStart: (controller, url) {
                  setState(() {
                    this.url = url.toString();
                    urlController.text = this.url;
                  });
                },
                onDownloadStartRequest: (controller, url) async {
                  await requestPermission();
                  print("onDownloadStart $url");
                  print("onDownloadStart URL ${url.url.toString()}");
                  Directory? directory = await getExternalStorageDirectory();
                  try {
                    final String? taskId = await FlutterDownloader.enqueue(
                      url: url.url.toString(),
                      savedDir: directory!.path,
                      showNotification: true,
                      // show download progress in status bar (for Android)
                      openFileFromNotification:
                          true, // click on notification to open downloaded file (for Android)
                    );
                    await FlutterDownloader.registerCallback((
                      String id,
                      int status,
                      int progress,
                    ) {
                      print(
                        "FlutterDownloader: id $id, status: $status, progress: $progress",
                      );
                    });
                  } catch (ex) {
                    print("FlutterDownloader.enqueue Exception");
                  }
                },
                androidOnPermissionRequest:
                    (controller, origin, resources) async {
                  return PermissionRequestResponse(
                      resources: resources,
                      action: PermissionRequestResponseAction.GRANT);
                },
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  var uri = navigationAction.request.url!;

                  if (![
                    "http",
                    "https",
                    "file",
                    "chrome",
                    "data",
                    "javascript",
                    "about"
                  ].contains(uri.scheme)) {
                    if (await canLaunch(url)) {
                      // Launch the App
                      await launch(
                        url,
                      );
                      // and cancel the request
                      return NavigationActionPolicy.CANCEL;
                    }
                  }

                  return NavigationActionPolicy.ALLOW;
                },
                onLoadStop: (controller, url) async {
                  pullToRefreshController.endRefreshing();
                  setState(() {
                    this.url = url.toString();
                    urlController.text = this.url;
                  });
                },
                onLoadError: (controller, url, code, message) {
                  pullToRefreshController.endRefreshing();
                },
                onProgressChanged: (controller, progress) {
                  if (progress == 100) {
                    pullToRefreshController.endRefreshing();
                  }
                  setState(() {
                    this.progress = progress / 100;
                    urlController.text = this.url;
                  });
                },
                onUpdateVisitedHistory: (controller, url, androidIsReload) {
                  setState(() {
                    this.url = url.toString();
                    urlController.text = this.url;
                  });
                },
                onConsoleMessage: (controller, consoleMessage) {
                  print(consoleMessage);
                },
              ),
              progress < 1.0
                  ? LinearProgressIndicator(
                      value: progress,
                      color: Constants.APP_COLOR_DARK,
                      backgroundColor: Constants.APP_COLOR.withOpacity(0.6),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
