import 'dart:ui' as ui;
import 'package:google_maps_flutter/google_maps_flutter.dart'
    show BitmapDescriptor;
import 'package:maps_app/markers/markers.dart';

Future<BitmapDescriptor> getStartCustomMarker(
    int minutes, String destination) async {
  final recorder = ui.PictureRecorder();

  final canvas = ui.Canvas(recorder);

  const size = ui.Size(350, 150);

  final startMarker =
      StartmarkerPainter(minutes: minutes, destination: destination);

  startMarker.paint(canvas, size);

  final picture = recorder.endRecording();

  final image = await picture.toImage(size.width.toInt(), size.height.toInt());
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

  return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
}

Future<BitmapDescriptor> getEndCustomMarker(
    int kilometers, String destination) async {
  final recorder = ui.PictureRecorder();

  final canvas = ui.Canvas(recorder);

  const size = ui.Size(350, 150);

  final startMarker =
      EndmarkerPainter(kilometers: kilometers, destination: destination);

  startMarker.paint(canvas, size);

  final picture = recorder.endRecording();

  final image = await picture.toImage(size.width.toInt(), size.height.toInt());
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

  return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
}
