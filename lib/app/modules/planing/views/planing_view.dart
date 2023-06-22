import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/planing_controller.dart';

class PlaningView extends GetView<PlaningController> {
  const PlaningView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PlaningView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PlaningView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
