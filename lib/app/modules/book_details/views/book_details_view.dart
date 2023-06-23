import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/book_details_controller.dart';

class BookDetailsView extends GetView<BookDetailsController> {
  const BookDetailsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BookDetailsView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'BookDetailsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
