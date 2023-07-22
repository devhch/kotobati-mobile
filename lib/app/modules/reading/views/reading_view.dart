import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:kotobati/app/core/models/book_model.dart';
import 'package:kotobati/app/core/utils/app_icons_keys.dart';
import 'package:kotobati/app/core/utils/app_theme.dart';
import 'package:kotobati/app/data/persistence/hive_data_store.dart';
import 'package:kotobati/app/modules/navigation/controllers/navigation_controller.dart';
import 'package:kotobati/app/widgets/common_scaffold.dart';
import 'package:kotobati/app/widgets/mirai_elevated_button_widget.dart';

import '../controllers/reading_controller.dart';
import 'components/book_widget.dart';

class ReadingView extends GetView<ReadingController> {
  const ReadingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      child: ValueListenableBuilder<Box<Map<dynamic, dynamic>>>(
        valueListenable: HiveDataStore().booksListenable(),
        builder: (_, Box<Map<dynamic, dynamic>> box, __) {
          final List<Map<dynamic, dynamic>> books = box.values.toList();

          if (books.isNotEmpty) {
            return ListView.builder(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 90,
              ),
              itemCount: books.length,
              itemBuilder: (_, int index) {
                final Book book = Book.fromJson(books[index]);
                return BookWidget(book: book);
              },
            );
          } else {
            return Center(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'لاتوجد بيانات',
                    style: context.textTheme.displayLarge!.copyWith(
                      color: Colors.white,
                      fontFamily: AppTheme.fontBold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'يرجى الذهاب إلى صفحة الكتب \nوتنزيل بعض الكتب!',
                    style: context.textTheme.displayLarge!.copyWith(
                      color: AppTheme.keyAppWhiteGrayColor,
                      fontFamily: AppTheme.fontBold,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  MiraiElevatedButtonWidget(
                    onTap: () {
                      Get.find<NavigationController>().setIndex(index: 0);
                    },
                    rounded: true,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
                    overlayColor: Colors.white.withOpacity(.2),
                    child: Text(
                      "اكتشف الكتب المتاحة",
                      style: context.textTheme.displayLarge!.copyWith(
                        color: AppTheme.keyAppBlackColor,
                        fontFamily: AppTheme.fontBold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ));
          }
        },
      ),
    );
  }
}

/*

Sure, you can capture a selected portion from a PDF as an image and then convert it to text using Flutter. Here are the steps involved:

Import the pdf and image packages into your Flutter project.
Create a PdfDocument object from the PDF file you want to crop.
Use the getPage method to get a PdfPage object for the page you want to crop.
Create a Crop object and set the rect property to the rectangle you want to crop.
Use the getCroppedImage method to get an Image object of the cropped page.
Use the Tesseract package to convert the Image object to text.
Here is an example of how to capture a selected portion from a PDF page as an image and then convert it to text using Flutter:

import 'package:pdf/pdf.dart';
import 'package:image/image.dart';
import 'package:tesseract/tesseract.dart';

 // Create a PDF document object from the PDF file.
  final pdfDocument = PdfDocument.openFile('my_pdf.pdf');

  // Get the page you want to crop.
  final page = pdfDocument.getPage(0);

  // Create a crop object.
  final crop = Crop();
  crop.rect = Rect.fromLTWH(100, 100, 200, 200);

  // Get a cropped image of the page.
  final croppedImage = page.getCroppedImage(crop);

  // Convert the image to text.
  final text = Tesseract.getOcrText(croppedImage);

  // Print the text.
  print(text);
 */
