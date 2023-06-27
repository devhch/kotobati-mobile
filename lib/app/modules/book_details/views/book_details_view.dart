import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kotobati/app/core/models/planing_books_model.dart';
import 'package:kotobati/app/core/utils/app_icons_keys.dart';
import 'package:kotobati/app/core/utils/app_theme.dart';
import 'package:kotobati/app/data/persistence/hive_data_store.dart';
import 'package:kotobati/app/modules/reading/views/components/book_widget.dart';
import 'package:kotobati/app/widgets/common_scaffold.dart';
import 'package:kotobati/app/widgets/mirai_cached_image_network_widget.dart';
import 'package:kotobati/app/widgets/mirai_elevated_button_widget.dart';

import '../controllers/book_details_controller.dart';
import 'components/text_widget.dart';

class BookDetailsView extends GetView<BookDetailsController> {
  const BookDetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      backButton: true,
      child: GetBuilder<BookDetailsController>(
        builder: (_) {
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 15),
                Container(
                  // padding: const EdgeInsets.symmetric(
                  //   horizontal: 16,
                  //   vertical: 10,
                  // ),
                  height: 140,
                  width: 96,
                  decoration: const BoxDecoration(
                      // color: AppTheme.keyAppColor,
                      ),
                  child: controller.bookModel.image != null &&
                          controller.bookModel.image!.contains(".svg")
                      ? SvgPicture.network(
                          controller.bookModel.image!,
                          fit: BoxFit.contain,
                          width: double.infinity,
                          // width: MiraiSize.iconSize24,
                          // height: MiraiSize.iconSize24,
                        )
                      : MiraiCachedImageNetworkWidget(
                          imageUrl: controller.bookModel.image!,
                          fit: BoxFit.fill,
                          width: 96,
                          //  width: double.infinity,
                          //    width: MiraiSize.iconSize24,
                          title: controller.bookModel.title!,
                          // height: MiraiSize.iconSize24,
                          // color: AppTheme.keyAppBlackColor,
                        ),
                ),
                const SizedBox(height: 15),
                Text(
                  controller.bookModel.title!,
                  style: context.textTheme.headlineMedium!.copyWith(
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  controller.bookModel.author!,
                  style: context.textTheme.bodyMedium!.copyWith(),
                ),
                const SizedBox(height: 15),
                MiraiElevatedButtonWidget(
                  child: const Text("قراءة الكتاب"),
                  onTap: () {},
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    InkWell(
                      onTap: () async {
                        controller.bookModel.planingBook = listPlaningBooks[0];
                        await HiveDataStore()
                            .updateBook(book: controller.bookModel);
                        controller.update();
                      },
                      child: SvgPicture.asset(
                        AppIconsKeys.reading,
                        width: 16,
                        colorFilter: controller.bookModel.planingBook != null &&
                                controller.bookModel.planingBook!.id == 1
                            ? const ColorFilter.mode(
                                AppTheme.keyAppColor,
                                BlendMode.srcOut,
                              )
                            : null,
                      ),
                    ),
                    const ContainerDivider(),
                    InkWell(
                      onTap: () async {
                        controller.bookModel.planingBook = listPlaningBooks[1];
                        await HiveDataStore()
                            .updateBook(book: controller.bookModel);
                        controller.update();
                      },
                      child: SvgPicture.asset(
                        AppIconsKeys.readLater,
                        width: 16,
                        // color: AppTheme.keyAppColor,
                        colorFilter: controller.bookModel.planingBook != null &&
                                controller.bookModel.planingBook!.id == 2
                            ? const ColorFilter.mode(
                                AppTheme.keyAppColor,
                                BlendMode.srcOut,
                              )
                            : null,
                      ),
                    ),
                    const ContainerDivider(),
                    InkWell(
                      onTap: () async {
                        controller.bookModel.planingBook = listPlaningBooks[2];
                        await HiveDataStore()
                            .updateBook(book: controller.bookModel);
                        controller.update();
                      },
                      child: SvgPicture.asset(
                        AppIconsKeys.readed,
                        width: 16,
                        colorFilter: controller.bookModel.planingBook != null &&
                                controller.bookModel.planingBook!.id == 3
                            ? const ColorFilter.mode(
                                AppTheme.keyAppColor,
                                BlendMode.srcOut,
                              )
                            : null,
                      ),
                    ),
                    const ContainerDivider(),
                    InkWell(
                      onTap: () {},
                      child: SvgPicture.asset(
                        AppIconsKeys.addCollection,
                        width: 16,
                      ),
                    ),
                    const ContainerDivider(),
                    InkWell(
                      onTap: () {},
                      child: SvgPicture.asset(
                        AppIconsKeys.share,
                        width: 16,
                      ),
                    ),
                    const ContainerDivider(),
                    InkWell(
                      onTap: () {},
                      child: SvgPicture.asset(
                        AppIconsKeys.settingPoint,
                        width: 6,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Obx(
                  () {
                    if (controller.notes.value) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(bottom: 5),
                            decoration: const BoxDecoration(
                                border: Border(
                              bottom: BorderSide(
                                color: AppTheme.keyAppColor,
                                width: 1.0, // Underline thickness
                              ),
                            )),
                            child: Text(
                              "الملاحظات",
                              style: context.textTheme.headlineMedium!.copyWith(
                                fontSize: 24,
                                color: AppTheme.keyAppColor,
                              ),
                            ),
                          ),
                          const ContainerDivider(height: 30, width: 1),
                          TextButton(
                            onPressed: () {
                              controller.notes.update(
                                (_) {
                                  controller.notes.value = false;
                                },
                              );
                            },
                            child: Text(
                              "الإقتباسات",
                              style: context.textTheme.headlineMedium!.copyWith(
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        TextButton(
                          onPressed: () {
                            controller.notes.update(
                              (_) {
                                controller.notes.value = true;
                              },
                            );
                          },
                          child: Text(
                            "الملاحظات",
                            style: context.textTheme.headlineMedium!.copyWith(
                              fontSize: 24,
                            ),
                          ),
                        ),
                        const ContainerDivider(height: 30, width: 1),
                        Container(
                          padding: const EdgeInsets.only(bottom: 5),
                          decoration: const BoxDecoration(
                              border: Border(
                            bottom: BorderSide(
                              color: AppTheme.keyAppColor,
                              width: 1.0, // Underline thickness
                            ),
                          )),
                          child: Text(
                            "الإقتباسات",
                            style: context.textTheme.headlineMedium!.copyWith(
                              fontSize: 24,
                              color: AppTheme.keyAppColor,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 25),
                Obx(
                  () {
                    if (controller.notes.value) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: controller.bookModel.notes.length,
                        itemBuilder: (_, int index) {
                          return TextWidget(
                            text: controller.bookModel.notes[index],
                          );
                        },
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: controller.bookModel.quotes.length,
                      itemBuilder: (_, int index) {
                        return TextWidget(
                          text: controller.bookModel.quotes[index],
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 25),
              ],
            ),
          );
        },
      ),
    );
  }
}
