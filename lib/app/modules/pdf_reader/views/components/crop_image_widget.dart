/*
* Created By Mirai Devs.
* On 23/8/2023.
*/

import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kotobati/app/core/helpers/common_function.dart';
import 'package:kotobati/app/core/utils/app_custom_dialog.dart';
import 'package:kotobati/app/core/utils/app_theme.dart';

class CropImageWidget extends StatefulWidget {
  const CropImageWidget({
    super.key,
    required this.file,
  });

  final File file;

  @override
  State<CropImageWidget> createState() => _CropImageWidgetState();
}

class _CropImageWidgetState extends State<CropImageWidget> {
  // late CustomImageCropController controller;
  //
  // CustomCropShape _currentShape = CustomCropShape.Square;
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _radiusController = TextEditingController();

  double _width = 16;
  double _height = 9;
  double _radius = 4;

  @override
  void initState() {
    super.initState();
    //  controller = CustomImageCropController();
  }

  @override
  void dispose() {
    //  controller.dispose();
    super.dispose();
  }

  // void _changeCropShape(CustomCropShape newShape) {
  //   setState(() {
  //     _currentShape = newShape;
  //   });
  // }

  void _updateRatio() {
    setState(() {
      if (_widthController.text.isNotEmpty) {
        _width = double.tryParse(_widthController.text) ?? 16;
      }
      if (_heightController.text.isNotEmpty) {
        _height = double.tryParse(_heightController.text) ?? 9;
      }
      if (_radiusController.text.isNotEmpty) {
        _radius = double.tryParse(_radiusController.text) ?? 4;
      }
    });
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: AppTheme.keyAppColorDark,
      ),
      child: Scaffold(
        backgroundColor: AppTheme.keyAppColorDark,
        appBar: AppBar(
          title: const Text('قص هذه الصورة'),
          backgroundColor: AppTheme.keyAppColorDark,
          toolbarHeight: 100,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        body: Column(
          children: [
            // Expanded(
            //   child: CustomImageCrop(
            //     cropController: controller,
            //     image: FileImage(widget.file),
            //     shape: _currentShape,
            //     ratio: _currentShape == CustomCropShape.Ratio
            //         ? Ratio(width: _width, height: _height)
            //         : null,
            //     canRotate: false,
            //     canMove: true,
            //     canScale: true,
            //     borderRadius: _currentShape == CustomCropShape.Ratio ? _radius : 0,
            //     backgroundColor: AppTheme.keyAppGrayColor,
            //     customProgressIndicator: const CupertinoActivityIndicator(
            //       color: AppTheme.keyAppColorDark,
            //     ),
            //   ),
            // ),
            // Container(
            //   color: AppTheme.keyAppColorDark,
            //   padding: const EdgeInsets.symmetric(vertical: 20),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceAround,
            //     children: <Widget>[
            //       IconButton(icon: const Icon(Icons.refresh), onPressed: controller.reset),
            //       IconButton(
            //         icon: const Icon(Icons.zoom_in),
            //         onPressed: () => controller.addTransition(
            //           CropImageData(scale: 1.33),
            //         ),
            //       ),
            //       IconButton(
            //         icon: const Icon(Icons.zoom_out),
            //         onPressed: () => controller.addTransition(
            //           CropImageData(scale: 0.75),
            //         ),
            //       ),
            //       IconButton(
            //         icon: const Icon(Icons.rotate_left),
            //         onPressed: () => controller.addTransition(
            //           CropImageData(angle: -pi / 4),
            //         ),
            //       ),
            //       IconButton(
            //         icon: const Icon(Icons.rotate_right),
            //         onPressed: () => controller.addTransition(
            //           CropImageData(angle: pi / 4),
            //         ),
            //       ),
            //       IconButton(
            //         icon: const Icon(Icons.crop),
            //         onPressed: () async {
            //           AppMiraiDialog.miraiDialogBar();
            //
            //           final MemoryImage? image = await controller.onCropImage();
            //           if (image != null) {
            //             Get.back();
            //             File imageFile = await uint8ListToFile(image.bytes, 'cropped_image');
            //             Get.back(result: imageFile);
            //             // Navigator.of(context).push(MaterialPageRoute(
            //             //     builder: (BuildContext context) => ResultScreen(image: image)));
            //           }
            //         },
            //       ),
            //       PopupMenuButton<CustomCropShape>(
            //         icon: const Icon(Icons.crop_original),
            //         onSelected: _changeCropShape,
            //         itemBuilder: (BuildContext context) {
            //           return CustomCropShape.values.map(
            //             (shape) {
            //               return PopupMenuItem<CustomCropShape>(
            //                 value: shape,
            //                 child: getShapeIcon(shape),
            //               );
            //             },
            //           ).toList();
            //         },
            //       ),
            //     ],
            //   ),
            // ),
            // if (_currentShape == CustomCropShape.Ratio)
            //   SizedBox(
            //     child: Row(
            //       children: [
            //         Expanded(
            //           child: TextField(
            //             controller: _widthController,
            //             keyboardType: TextInputType.number,
            //             decoration: const InputDecoration(labelText: 'Width'),
            //           ),
            //         ),
            //         const SizedBox(width: 16.0),
            //         Expanded(
            //           child: TextField(
            //             controller: _heightController,
            //             keyboardType: TextInputType.number,
            //             decoration: const InputDecoration(labelText: 'Height'),
            //           ),
            //         ),
            //         const SizedBox(width: 16.0),
            //         Expanded(
            //           child: TextField(
            //             controller: _radiusController,
            //             keyboardType: TextInputType.number,
            //             decoration: const InputDecoration(labelText: 'Radius'),
            //           ),
            //         ),
            //         const SizedBox(width: 16.0),
            //         ElevatedButton(
            //           onPressed: _updateRatio,
            //           child: const Text('Update Ratio'),
            //         ),
            //       ],
            //     ),
            //   ),
            // SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
//
// Widget getShapeIcon(CustomCropShape shape) {
//   switch (shape) {
//     case CustomCropShape.Circle:
//       return const Icon(Icons.circle_outlined);
//     case CustomCropShape.Square:
//       return const Icon(Icons.square_outlined);
//     case CustomCropShape.Ratio:
//       return const Icon(Icons.crop_16_9_outlined);
//   }
// }
}
