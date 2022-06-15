
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BubbleBackgroundChat extends StatelessWidget {
  const BubbleBackgroundChat({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        addRepaintBoundaries: false,
        itemCount: 300,
        itemBuilder: (context, index) {
          double margin = 15;
          final messageIsMine = index % 3 == 0;
          double marginLeft = messageIsMine ? 60 : margin;
          double marginRight = messageIsMine ? margin : 60;

          return Container(
            margin:
            EdgeInsets.fromLTRB(marginLeft, margin, marginRight, margin),
            padding: const EdgeInsets.all(5),
            alignment:
            messageIsMine ? Alignment.centerRight : Alignment.centerLeft,
            child: GradientBackgroundBubble(
                messageIsMine
                    ? const [Color(0xFFA9A6A9), Color(0xFF3A364B)]
                    : const [Color(0xFF19B7FF), Color(0xFFFF683B)],
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    "Hello Message $index, Hello Hello Message $index,Hello Message $index,Hello Message $index,Hello Message $index,Hello Message $index,Hello Message $index,Hello Message $index",
                    style: const TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                ),
                Scrollable.of(context)!),
          );
        });
  }
}

class GradientBackgroundBubble extends StatelessWidget {
  final List<Color> colors;
  final Widget child;
  final ScrollableState scrollableState;

  const GradientBackgroundBubble(this.colors, this.child, this.scrollableState,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BubbleBackgroundPainter(colors, context, scrollableState),
      child: child,
    );
  }
}

class BubbleBackgroundPainter extends CustomPainter {
  final List<Color> colors;
  final ScrollableState scrollableState;
  final BuildContext context;

  BubbleBackgroundPainter(
      this.colors,
      this.context,
      this.scrollableState,
      );

  @override
  void paint(Canvas canvas, Size size) {
    final scrollableBox =
    scrollableState.context.findRenderObject() as RenderBox;
    final bubbleBox = context.findRenderObject() as RenderBox;
    final origin =
    bubbleBox.localToGlobal(Offset.zero, ancestor: scrollableBox);
    final scrollableRect = Offset.zero & scrollableBox.size;
    debugPrint("origin is $origin, scrollableRect is $scrollableRect");

    final paint = Paint()
      ..shader = LinearGradient(
        colors: colors,
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        transform: ScrollGradientTransform(-origin.dx, -origin.dy, 0.0),
      ).createShader(scrollableRect);

    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Offset.zero & size, const Radius.circular(20.0)),
        paint);
  }

  @override
  bool shouldRepaint(BubbleBackgroundPainter oldDelegate) {
    return oldDelegate.scrollableState != scrollableState ||
        oldDelegate.context != context ||
        oldDelegate.colors != colors;
  }
}

class ScrollGradientTransform extends GradientTransform {
  final double dx, dy, dz;

  const ScrollGradientTransform(this.dx, this.dy, this.dz);

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.identity()..translate(dx, dy, dz);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    } else if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is ScrollGradientTransform &&
        other.dx == dx &&
        other.dy == dy &&
        other.dz == dz;
  }

  @override
  int get hashCode {
    return dx.hashCode | dy.hashCode | dz.hashCode;
  }
}