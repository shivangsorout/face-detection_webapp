import 'package:flutter/material.dart';

class FaceDetectorPainter extends CustomPainter {
  final Size absoluteImageSize;
  final List<Rect> faces;
  final bool isStarted;

  FaceDetectorPainter(
    this.absoluteImageSize,
    this.faces,
    this.isStarted, {
    super.repaint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / absoluteImageSize.width;
    final double scaleY = size.height / absoluteImageSize.height;

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = isStarted ? Colors.green : Colors.transparent;

    for (Rect face in faces) {
      canvas.drawRect(
        Rect.fromLTRB(
          face.left * scaleX,
          face.top * scaleY,
          face.right * scaleX,
          face.bottom * scaleY,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    return oldDelegate.absoluteImageSize != absoluteImageSize ||
        oldDelegate.faces != faces;
  }
}
