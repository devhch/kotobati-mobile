import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kotobati/app/core/helpers/common_function.dart';
import 'package:kotobati/app/core/utils/app_custom_dialog.dart';
import 'package:kotobati/app/core/utils/app_icons_keys.dart';
import 'package:kotobati/app/core/utils/app_theme.dart';
import 'package:kotobati/app/widgets/mirai_text_field_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../controllers/search_controller.dart';

class SearchView extends GetView<SearchControllerC> {
  const SearchView({Key? key}) : super(key: key);

  // Native method call using MethodChannel to get PDF files from native code
  Future<List<String>> _getPdfFilesFromNative() async {
    const MethodChannel platform =
        MethodChannel('com.kotobati.pdf_reader_channel');
    try {
      final List<dynamic> pdfFiles =
          await platform.invokeMethod('getPdfFilesFromNative');
      return pdfFiles.cast<String>();
    } catch (e) {
      throw PlatformException(
          code: 'ERROR', message: 'Failed to communicate with native code');
    }
  }

  Future<void> searchForPDFs() async {
    await requestPermission();

    Directory? appDirectory = await getTemporaryDirectory();
    // Adjust as per your requirements
    List<FileSystemEntity> files = controller.searchForPDFFiles(appDirectory!);

    Directory? downDirectory = await getExternalStorageDirectory();
    // Adjust as per your requirements

    List<FileSystemEntity> downFiles =
        controller.searchForPDFFiles(downDirectory!);
    files.addAll(downFiles);

    miraiPrint('files $files');

    //controller.pdfFiles = files;
    controller.update();
  }

  Future<void> loadPDFFiles() async {
    final PermissionStatus status =
        await Permission.manageExternalStorage.request();
    miraiPrint("PermissionStatus $status");
    if (status == PermissionStatus.permanentlyDenied) {
      AppMiraiDialog.snackBar(
        title: 'Storage Permission Denied!',
        message:
            'Please allow storage permission to save the book that you are going to download...',
      );
      openAppSettings();
    }

    Directory? externalStorageDirectory = await getExternalStorageDirectory();
    // List<Directory>? sdCardDirectory =
    //     await getExternalStorageDirectories(type: StorageDirectory.downloads);

    // FilePickerResult? result = await FilePicker.platform.pickFiles();
    // String? filePath = result?.files.single.path;
    // if (filePath != null) {
    //   File file = File(filePath);
    //   controller.pdfFiles.add(file);
    // }
    if (externalStorageDirectory != null) {
      controller.pdfFiles.addAll(await findPDFFiles(externalStorageDirectory));
    }
    // if (sdCardDirectory != null) {
    //   for (Directory dir in sdCardDirectory) {
    //     controller.pdfFiles.addAll(await findPDFFiles(dir));
    //   }
    // }

    miraiPrint('files ${controller.pdfFiles}');
    controller.update();
  }

  Future<List<File>> findPDFFiles(Directory directory) async {
    List<File> pdfFiles = [];
    try {
      List<FileSystemEntity> files = directory.listSync(recursive: true);
      for (FileSystemEntity file in files) {
        miraiPrint('file $file');
        if (file is File && file.path.toLowerCase().endsWith('.pdf')) {
          pdfFiles.add(file);
        }
      }
    } catch (e) {
      print('Error while scanning files: $e');
    }
    return pdfFiles;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchControllerC>(
      builder: (_) {
        return Scaffold(
          backgroundColor: AppTheme.keyAppBlackColor,
          body: SafeArea(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    IconButton(
                      iconSize: 55,
                      splashRadius: 2,
                      onPressed: () {
                        Get.back();
                      },
                      icon: SvgPicture.asset(AppIconsKeys.backArrowCircle),
                    ),
                    Expanded(
                      child: MiraiTextFieldWidget(
                        controller: controller.txtController,
                        hint: "بحث...",
                        fillColor: const Color(0xffA1A1A1),
                        borderColor: const Color(0xffA1A1A1),
                      ),
                    ),
                    IconButton(
                      iconSize: 55,
                      splashRadius: 2,
                      onPressed: () async {
                        // Call the native method to get PDF files and wait for the result
                        // List<String> pdfFiles = await _getPdfFilesFromNative();
                        // controller.pdfPaths = pdfFiles;
                        // miraiPrint('pdfPaths ${controller.pdfPaths}');
                        // controller.update();

                        await loadPDFFiles();
                      },
                      icon: SvgPicture.asset(AppIconsKeys.search),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                Expanded(
                  child: controller.pdfFiles.isNotEmpty
                      ? ListView.builder(
                          itemCount: controller.pdfFiles.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              title: Text(controller.pdfFiles[index].path
                                  .split('/')
                                  .last),
                              onTap: () {
                                // Implement the action when tapping on a file, e.g., open the PDF file.
                                // You can use a PDF viewer plugin like 'flutter_pdfview' to display the PDF.
                                // For this example, we'll simply print the file path.
                                print(
                                    'Selected PDF file: ${controller.pdfFiles[index].path}');
                              },
                            );
                          },
                        )
                      : const Center(child: CircularProgressIndicator()),
                ),
                // Expanded(
                //   child: ListView.builder(
                //     itemCount: controller.pdfFiles.length,
                //     itemBuilder: (_, int index) {
                //       return ListTile(
                //         title: Text(controller.pdfFiles[index].path),
                //       );
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}
