import 'dart:ui' as ui;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<BitmapDescriptor> getAssetImageMarker(String imgPath) async {
  return BitmapDescriptor.fromAssetImage(
    const ImageConfiguration(
      devicePixelRatio: 2,
    ),
    imgPath,
  );
}

Future<BitmapDescriptor> getNetworkImageMarker(url) async {
  final resp = await Dio().get(
    url,
    options: Options(
      responseType: ResponseType.bytes,
    ),
  );

  // return BitmapDescriptor.fromBytes(resp.data);

  //Resize
  final imageCodec = await ui.instantiateImageCodec(
    resp.data,
    targetHeight: 80,
    targetWidth: 70,
  );
  final frame = await imageCodec.getNextFrame();
  final data = await frame.image.toByteData(format: ui.ImageByteFormat.png);

  if (data == null) {
    return await getAssetImageMarker('assets/pin.png');
  }
  return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
}
