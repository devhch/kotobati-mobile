
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kotobati/app/core/utils/app_extension.dart';
import 'package:kotobati/app/core/utils/app_theme.dart';
import 'package:shimmer/shimmer.dart';

/*
* Created By Mirai Devs.
* On 26/6/2023.
*/

class MiraiCachedImageNetworkWidget extends StatelessWidget {
  const MiraiCachedImageNetworkWidget({
    Key? key,
    required this.imageUrl,
    required this.title,
    this.borderRadius,
    this.backgroundColor,
    this.titleColor,
    this.titleFontSize,
    this.height,
    this.width,
    this.fit,
  }) : super(key: key);

  final String imageUrl;
  final String title;
  final BorderRadius? borderRadius;
  final double? height;
  final double? width;
  final Color? backgroundColor;
  final Color? titleColor;
  final double? titleFontSize;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(0.0),
      child: CachedNetworkImage(
        width: width,
        height: height,
        imageUrl: imageUrl,
        fit: fit ?? BoxFit.fill,
        placeholder: (BuildContext context, String url) {
          return Shimmer.fromColors(
            highlightColor: Colors.grey[400]!,
            baseColor: Colors.grey[300]!,
            direction: ShimmerDirection.ltr,
            period: AppTheme.shimmerDuration,
            child: Container(
              color: Colors.grey,
            ),
          );
        },
        errorWidget: (BuildContext context, String url, dynamic error) {
          return Container(
            color: backgroundColor ?? Colors.white,
            alignment: Alignment.center,
            child: Text(
              title.generateTheName,
              style: TextStyle(
                color: titleColor ?? AppTheme.keyAppColor,
                fontSize: titleFontSize ?? 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }
}