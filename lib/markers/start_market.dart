import 'package:flutter/material.dart';

class StartmarkerPainter extends CustomPainter {
  final int minutes;
  final String destination;

  StartmarkerPainter({required this.minutes, required this.destination});

  @override
  void paint(Canvas canvas, Size size) {
    final blackPaint = Paint()..color = Colors.black;

    final whitePaint = Paint()..color = Colors.white;

    const double circusBlackRadius = 20;
    const double circusWhiteRadius = 7;

    canvas.drawCircle(
        Offset(circusBlackRadius, size.height - circusBlackRadius),
        circusBlackRadius,
        blackPaint);

    canvas.drawCircle(
        Offset(circusBlackRadius, size.height - circusBlackRadius),
        circusWhiteRadius,
        whitePaint);

    final path = Path();
    path.moveTo(40, 20);
    path.lineTo(size.width - 10, 20);
    path.lineTo(size.width - 10, 100);
    path.lineTo(40, 100);

    canvas.drawShadow(path, Colors.black, 10, false);
    canvas.drawPath(path, whitePaint);

    //Caja negra
    const blackBox = Rect.fromLTWH(40, 20, 70, 80);

    canvas.drawRect(blackBox, blackPaint);

    //Textor

    //Minutos
    final textSpan = TextSpan(
        style: const TextStyle(
            color: Colors.white, fontSize: 30, fontWeight: FontWeight.w400),
        text: minutes.toString());

    final minutesPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(minWidth: 70, maxWidth: 70);

    minutesPainter.paint(canvas, const Offset(40, 35));

    //Minutos
    const minutesSpan = TextSpan(
        style: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.w300),
        text: 'Min');

    final minutesMinPainter = TextPainter(
        text: minutesSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(minWidth: 70, maxWidth: 70);

    minutesMinPainter.paint(canvas, const Offset(40, 68));

    //Descripcion

    final locationSpan = TextSpan(
        style: const TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        text: destination);

    final locationPainter = TextPainter(
        maxLines: 2,
        ellipsis: '...',
        text: locationSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.left)
      ..layout(minWidth: size.width - 135, maxWidth: size.width - 135);

    final double offsetY = (destination.length > 20) ? 35 : 48;

    locationPainter.paint(canvas, Offset(120, offsetY));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) => false;
}
