import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kotobati/app/widgets/common_scaffold.dart';

import '../controllers/reading_controller.dart';

class ReadingView extends GetView<ReadingController> {
  const ReadingView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const CommonScaffold(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[],
        ),
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
