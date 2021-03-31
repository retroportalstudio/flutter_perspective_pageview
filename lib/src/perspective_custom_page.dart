import 'package:flutter/material.dart';

class PerspectiveCustomPage extends StatelessWidget {
  final int number;
  final double fraction;
  final Widget child;
  final Color shadowColor;
  final bool hasShadow;
  final double shadowScale;
  final double currentPage;

  PerspectiveCustomPage({
    required this.child,
    required this.number,
    required this.fraction,
    required this.hasShadow,
    required this.shadowColor,
    required this.shadowScale,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    double diff = (number - currentPage);

    final Matrix4 pvMatrix = Matrix4.identity()
      ..setEntry(3, 3, 1 / 0.9)
      ..setEntry(1, 1, fraction)
      ..setEntry(3, 0, 0.004 * -diff);

    final Matrix4 shadowMatrix = Matrix4.identity()
      ..setEntry(3, 3, 1 / shadowScale)
      ..setEntry(3, 1, -0.004)
      ..setEntry(3, 0, 0.002 * diff)
      ..rotateX(1.309);

    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: <Widget>[
        if (hasShadow && diff <= 1.0 && diff >= -1.0) ...[
          AnimatedOpacity(
            duration: Duration(milliseconds: 100),
            opacity: 1 - diff.abs(),
            child: Transform(
              alignment: FractionalOffset.bottomCenter,
              transform: shadowMatrix,
              child: Container(
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: shadowColor,
                    blurRadius: 10.0,
                    spreadRadius: 1.0,
                  )
                ]),
              ),
            ),
          ),
        ],
        Transform(
          transform: pvMatrix,
          alignment: FractionalOffset.center,
          child: Container(child: child),
        ),
      ],
    );
  }
}
