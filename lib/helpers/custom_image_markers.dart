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

Future<BitmapDescriptor> getBuildingMarkerIcon() async {
  const size = 96.0;
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  final center = const Offset(size / 2, size / 2 - 8);

  final shadowPaint = Paint()..color = const Color.fromRGBO(0, 0, 0, 0.18);
  canvas.drawCircle(center.translate(0, 3), 31, shadowPaint);

  final markerPaint = Paint()..color = const Color(0xff0A2861);
  canvas.drawCircle(center, 30, markerPaint);

  final tailPath = Path()
    ..moveTo(center.dx - 11, center.dy + 22)
    ..lineTo(center.dx, center.dy + 42)
    ..lineTo(center.dx + 11, center.dy + 22)
    ..close();
  canvas.drawPath(tailPath, markerPaint);

  final buildingPaint = Paint()..color = Colors.white;
  final building = RRect.fromRectAndRadius(
    Rect.fromCenter(
      center: center.translate(0, 2),
      width: 25,
      height: 28,
    ),
    const Radius.circular(2),
  );
  canvas.drawRRect(building, buildingPaint);

  final windowPaint = Paint()..color = const Color(0xff0A2861);
  for (var row = 0; row < 2; row++) {
    for (var column = 0; column < 3; column++) {
      canvas.drawRect(
        Rect.fromLTWH(
          center.dx - 8 + column * 7,
          center.dy - 8 + row * 9,
          3,
          4,
        ),
        windowPaint,
      );
    }
  }
  canvas.drawRect(
    Rect.fromLTWH(center.dx - 3, center.dy + 8, 6, 12),
    windowPaint,
  );

  final image = await recorder.endRecording().toImage(
        size.toInt(),
        size.toInt(),
      );
  final data = await image.toByteData(format: ui.ImageByteFormat.png);
  if (data == null) {
    return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
  }
  return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
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
