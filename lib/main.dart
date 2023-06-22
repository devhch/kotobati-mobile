import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'app/core/utils/app_theme.dart';
import 'app/routes/app_pages.dart';

Future main() async {
  await appPreLunch();

  runApp(MyApp());
}

Future appPreLunch() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize();

  /// Change NavigationBarColor and statusBarColor.
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: AppTheme.keyAppBlackColor,
    ),
  );

  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);

    var swAvailable = await AndroidWebViewFeature.isFeatureSupported(
        AndroidWebViewFeature.SERVICE_WORKER_BASIC_USAGE);
    var swInterceptAvailable = await AndroidWebViewFeature.isFeatureSupported(
        AndroidWebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);

    if (swAvailable && swInterceptAvailable) {
      AndroidServiceWorkerController serviceWorkerController =
          AndroidServiceWorkerController.instance();

      serviceWorkerController.serviceWorkerClient = AndroidServiceWorkerClient(
        shouldInterceptRequest: (request) async {
          print(request);
          return null;
        },
      );
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: GetMaterialApp(
        title: 'كتوباتي',
        debugShowCheckedModeBanner: false,
        smartManagement: SmartManagement.full,
        theme: AppTheme.themeData,
        initialRoute: AppPages.initial,
        getPages: AppPages.routes,
        locale: Locale('ar', '🇲🇦'),
        supportedLocales: [
          const Locale('en'),
          const Locale('ar'),
        ],
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback:
            (Locale? deviceLocale, Iterable<Locale> supportedLocales) {
          for (Locale locale in supportedLocales) {
            if (locale.languageCode == deviceLocale?.languageCode &&
                locale.countryCode == deviceLocale?.countryCode) {
              return deviceLocale;
            }
          }
          return supportedLocales.first;
        },
      ),
    );
  }
}

// flutter pub run change_app_package_name:main com.dghoughi.lahsen.kotobati
// flutter pub global activate get_cli
// get create page:splash
// flutter build apk --split-per-abi
// flutter pub outdated --mode=null-safety
// flutter pub pub run flutter_launcher_icons:main
// flutter create --org wwwm.com project_name
