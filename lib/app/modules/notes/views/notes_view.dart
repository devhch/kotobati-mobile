import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kotobati/app/widgets/common_scaffold.dart';

import '../controllers/notes_controller.dart';

class NotesView extends GetView<NotesController> {
  const NotesView({Key? key}) : super(key: key);
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
