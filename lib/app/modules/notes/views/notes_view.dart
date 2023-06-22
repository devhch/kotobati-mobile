import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/notes_controller.dart';

class NotesView extends GetView<NotesController> {
  const NotesView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NotesView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'NotesView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
