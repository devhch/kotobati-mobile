/*
* Created By Mirai Devs.
* On 12/9/2023.
*/

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kotobati/app/core/utils/app_icons_keys.dart';
import 'package:kotobati/app/core/utils/app_theme.dart';
import 'package:kotobati/app/data/persistence/hive_data_store.dart';

class SearchHistoryValueListenable extends StatelessWidget {
  const SearchHistoryValueListenable({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<String>>(
      valueListenable: HiveDataStore().searchHistoryListenable(),
      builder: (_, Box<String> box, __) {
        final List<String> searchHistory = box.values.toList();

        return AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child: searchHistory.isNotEmpty
              ? ListView.builder(
                  key: ValueKey<String>(
                    'SearchHistoryListenableList${DateTime.now().toIso8601String()}',
                  ),
                  shrinkWrap: true,
                  addAutomaticKeepAlives: true,
                  cacheExtent: double.infinity,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsetsDirectional.only(
                    top: 20,
                    start: 34,
                    end: 24,
                    bottom: 20,
                  ),
                  itemCount: searchHistory.length,
                  itemBuilder: (_, int index) {
                    return SearchHistoryItemWidget(
                      title: searchHistory[index],
                      index: index,
                    );
                  },
                )
              : const SizedBox.shrink(),
        );
        //  return const Text('No Search History');
      },
    );
  }
}

class SearchHistoryItemWidget extends StatelessWidget {
  const SearchHistoryItemWidget({
    super.key,
    required this.title,
    required this.index,
  });

  final String title;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: <Widget>[
          SvgPicture.asset(
            AppIconsKeys.time,
            width: 18,
            height: 18,
            fit: BoxFit.fill,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: context.textTheme.displayLarge!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              // textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () async {
              await HiveDataStore().deleteSearchIndex(index: index);
            },
            icon: const Icon(
              Icons.close,
              size: 18,
              color: AppTheme.keyAppGrayColor,
            ),
          ),
          // Text(
          //   'كتب',
          //   style: context.textTheme.displayLarge!.copyWith(
          //     fontWeight: FontWeight.bold,
          //     fontSize: 16,
          //   ),
          //   textAlign: TextAlign.center,
          // ),
        ],
      ),
    );
  }
}
