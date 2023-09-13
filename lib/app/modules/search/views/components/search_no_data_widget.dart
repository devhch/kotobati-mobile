/*
* Created By Mirai Devs.
* On 12/9/2023.
*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchNoDataWidget extends StatelessWidget {
  const SearchNoDataWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      key: ValueKey<String>("SearchCenterNoData${DateTime.now().toIso8601String()}"),
      child: Text(
        'لاتوجد بيانات',
        style: context.textTheme.displayLarge!.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }
}
