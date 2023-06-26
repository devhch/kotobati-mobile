/*
* Created By Mirai Devs.
* On 9/6/2023.
*/

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:kotobati/app/core/utils/app_theme.dart';

AppBar homeAppBar(InAppWebViewController? webViewController ) {
  return AppBar(
      toolbarHeight: 50,
   // backgroundColor: Constants.APP_COLOR,
    backgroundColor: Colors.white,
    elevation: 0,
    actions: <Widget>[
      // IconButton(
      //   icon: Icon(Icons.download),
      //   onPressed: () async {
      //     await requestPermission();
      //   },
      // ),
      IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: AppTheme.keyAppColor,
        ),
        onPressed: () {
          webViewController?.goBack();
        },
      ),
      IconButton(
        icon: const Icon(
          Icons.arrow_forward,
          color: AppTheme.keyAppColor,
        ),
        onPressed: () {
          webViewController?.goForward();
        },
      ),
      // const Spacer(),
      // IconButton(
      //   icon: const Icon(
      //     Icons.refresh,
      //     color: AppTheme.keyAppColor,
      //   ),
      //   onPressed: () {
      //     webViewController?.reload();
      //   },
      // ),

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
  );
}
