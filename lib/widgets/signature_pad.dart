import 'package:flutter/material.dart';
import '../theme.dart';

/// Minimal freehand signature capture — no package, just a
/// GestureDetector + CustomPainter over the collected strokes.
class SignaturePad extends StatefulWidget {
  const SignaturePad({super.key, required this.onChanged});
  final ValueChanged<bool> onChanged;

  @override
  State<SignaturePad> createState() => SignaturePadState();
}

class SignaturePadState extends State<SignaturePad> {
  final List<List<Offset>> _strokes = [];

  bool get hasSignature => _strokes.isNotEmpty;

  void clear() {
    setState(() => _strokes.clear());
    widget.onChanged(false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(16),
      ),
      child: GestureDetector(
        onPanStart: (d) {
          setState(() => _strokes.add([d.localPosition]));
        },
        onPanUpdate: (d) {
          setState(() => _strokes.last.add(d.localPosition));
          widget.onChanged(true);
        },
        child: CustomPaint(painter: _SignaturePainter(_strokes), size: Size.infinite),
      ),
    );
  }
}

class _SignaturePainter extends CustomPainter {
  _SignaturePainter(this.strokes);
  final List<List<Offset>> strokes;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black87
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    for (final stroke in strokes) {
      for (int i = 0; i < stroke.length - 1; i++) {
        canvas.drawLine(stroke[i], stroke[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SignaturePainter oldDelegate) => true;
}
