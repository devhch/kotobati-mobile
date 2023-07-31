/*
* Created By Mirai Devs.
* On 29/7/2023.
*/

import 'package:flutter_svg/flutter_svg.dart';

Future<void> preloadSVGs({required List<String> assets}) async {
  for (final String asset in assets) {
    SvgAssetLoader loader = SvgAssetLoader(asset);
    await svg.cache.putIfAbsent(loader.cacheKey(null), () => loader.loadBytes(null));
    // await precachePicture(
    //   ExactAssetPicture(SvgPicture.svgStringDecoderBuilder, asset),
    //   //   ExactAssetPicture(SvgPicture.svgStringDecoder, asset),
    //   null,
    // );
  }
}

Future<void> preloadSVG({required String assetName}) async {
  SvgAssetLoader loader = SvgAssetLoader(assetName);
  await svg.cache.putIfAbsent(loader.cacheKey(null), () => loader.loadBytes(null));

  // await precachePicture(
  //   ExactAssetPicture(SvgPicture.svgStringDecoderBuilder, assetName),
  //   // ExactAssetPicture(SvgPicture.svgStringDecoder, assetName),
  //   null,
  // );
}
