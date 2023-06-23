import 'dart:collection';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:kotobati/app/core/utils/app_config.dart';
import 'package:kotobati/app/core/utils/app_extension.dart';
import 'package:kotobati/app/core/utils/app_theme.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MyHomePage();
  }
}

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

    // createAppFolder();

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
            },
          )
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

    // requestPermission();

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
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(statusBarColor: AppTheme.keyAppColorDark),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.only(
            top: context.topPadding,
            bottom: context.bottomAdding / 2,
          ),
          child: Stack(
            children: [
              InAppWebView(
                key: webViewKey,
                // contextMenu: contextMenu,
                initialUrlRequest:
                    URLRequest(url: Uri.parse(AppConfig.WEB_URL)),
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

                onDownloadStartRequest: onDownloadStartRequest,
                androidOnPermissionRequest:
                    (controller, origin, resources) async {
                  return PermissionRequestResponse(
                      resources: resources,
                      action: PermissionRequestResponseAction.GRANT);
                },
                shouldOverrideUrlLoading: shouldOverrideUrlLoading,
                onLoadStop:
                    (InAppWebViewController controller, Uri? url) async {
                  print("URI URL path: ${url?.toString()}");
                  // if (url != null && url.toString().contains('/recon?')) {
                  print("onLoadStop");
                  // if JavaScript is enabled, you can use
                  var html = await webViewController?.evaluateJavascript(
                      source:
                          "window.document.getElementsByTagName('html')[0].outerHTML;");
                  // await webViewController?.evaluateJavascript(source: "window.document.body.innerText;");

                  log("html: $html");
                  //  }
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
                      color: AppTheme.keyAppColorDark,
                      backgroundColor: AppTheme.keyAppColor.withOpacity(0.6),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  // If you name your createFolder(".folder") that folder will be hidden.
  // If you create a .nomedia file in your folder, other apps won't be able to scan your folder.
  Future<String> createFolder(String cow) async {
    final dir = Directory((Platform.isAndroid
                ? await getExternalStorageDirectory() // FOR ANDROID
                : await getApplicationSupportDirectory() // FOR IOS
            )!
            .path +
        '/$cow');
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    if ((await dir.exists())) {
      return dir.path;
    } else {
      dir.create();
      return dir.path;
    }
  }

  Future<void> downloadFile(String fileName, String url) async {
    // var dio = new Dio();
    // var dir = await getExternalStorageDirectory();
    // var knockDir =
    //     await new Directory('${dir.path}/Kotobati').create(recursive: true);
    // print(url);
    // await dio.download(widget.url, '${knockDir.path}/${widget.fileName}.pdf',
    //     onProgress: (rec, total) {
    //   if (mounted) {
    //     setState(() {
    //       downloading = true;
    //       progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
    //     });
    //   }
    // });
    // if (mounted) {
    //   setState(() {
    //     downloading = false;
    //     progressString = "Completed";
    //     _message = "File is downloaded to your SD card 'iLearn' folder!";
    //   });
    // }
    // print("Download completed");
  }

  Future<NavigationActionPolicy?> shouldOverrideUrlLoading(
      InAppWebViewController controller,
      NavigationAction navigationAction) async {
    var uri = navigationAction.request.url!;

    if (!["http", "https", "file", "chrome", "data", "javascript", "about"]
        .contains(uri.scheme)) {
      if (await canLaunch(url)) {
        // Launch the App
        await launch(url);
        // and cancel the request
        return NavigationActionPolicy.CANCEL;
      }
    }

    return NavigationActionPolicy.ALLOW;
  }

  void onDownloadStartRequest(InAppWebViewController controller,
      DownloadStartRequest downloadStartRequest) async {
    await requestPermission();
    print("<========================>");
    print("DownloadStartRequest: ${downloadStartRequest.toString()}");
    print("<========================>");
    print("onDownloadStart URL ${downloadStartRequest.url.toString()}");
    print("<========================>");
    //  Directory? directory = await getExternalStorageDirectory();
    Directory? directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationSupportDirectory();
    try {
      final String? taskId = await FlutterDownloader.enqueue(
        url: downloadStartRequest.url.toString(),
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
  }

  Future<void> createAppFolder() async {
    await requestPermission();

    // Get the app name
    String appName = 'Kotobati';

    // Create a folder in internal storage
    Directory? directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    print("directory ${directory?.toString()}");
    String appFolderPath = '${directory?.path}/$appName';
    Directory(appFolderPath).create(recursive: true);

    // Create a file path for the PDF
    String pdfFilePath = '$appFolderPath/your_pdf_file';

    // Create a sample PDF file
    createSamplePDF(pdfFilePath);

    // Check if the file was created
    bool fileExists = await File(pdfFilePath).exists();
    if (fileExists) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('PDF file saved successfully.'),
                Text('getTemporaryDirectory .${getTemporaryDirectory()}'),
                Text(
                    'getApplicationSupportDirectory .${getApplicationSupportDirectory()}'),
                Text(
                    'getApplicationDocumentsDirectory .${getApplicationDocumentsDirectory()}'),
                // Text('getApplicationDocumentsDirectory .${getAppl()}'),
                Text('App Folder Location:'),
                Text(appFolderPath),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  // Open the folder containing the PDF file
                  OpenFile.open("${pdfFilePath}.pdf");
                },
              ),
            ],
          );
        },
      );
    }
  }

  // Function to create a sample PDF file
  void createSamplePDF(String filePath) async {
    // Code to create a PDF file goes here
    // You can use libraries like pdf, pdf/widgets, or any other PDF generation library in Flutter
    // to create the PDF file and save it at the specified file path.
    // Here's an example using the pdf library:
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text('Sample PDF'),
          );
        },
      ),
    );
    final file = File(filePath);
    file.writeAsBytesSync(await pdf.save());
  }
}
