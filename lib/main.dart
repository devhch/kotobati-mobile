import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/home_screen.dart';

// InAppLocalhostServer localhostServer = new InAppLocalhostServer();

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize();

  /// Change NavigationBarColor and statusBarColor.
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.white,
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

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'كتوباتي',
      locale: Locale('ar', '🇲🇦'),
      supportedLocales: [
        const Locale('en'),
        const Locale('ar'),
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: GoogleFonts.roboto().fontFamily,
        scaffoldBackgroundColor: Colors.transparent,
        primaryColor: Colors.pink,
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      home: MyHomePage(),
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
