library perspective_pageview;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum PVAspectRatio {
  square,
  sixteenNine,
}

class PerspectivePageView extends StatefulWidget {
  final List<Widget> children;
  final bool hasShadow;
  final Color? shadowColor;
  final PVAspectRatio? aspectRatio;

  const PerspectivePageView({
    Key? key,
    required this.children,
    required this.hasShadow,
    this.shadowColor,
    this.aspectRatio,
  }) : super(key: key);

  @override
  _PerspectivePageViewState createState() => _PerspectivePageViewState();
}

class _PerspectivePageViewState extends State<PerspectivePageView> {
  late PageController _controller;
  late PageValueHolder holder;
  double fraction = 0.50;

  getAspectRatio() {
    switch (widget.aspectRatio) {
      case PVAspectRatio.square:
        return [1.0, 1.6];
      case PVAspectRatio.sixteenNine:
        return [16.0 / 9.0, 1.1];
      default:
        return [1.0, 1.6];
    }
  }

  @override
  void initState() {
    super.initState();
    holder = PageValueHolder(2.0);
    _controller = PageController(initialPage: 2, viewportFraction: fraction);
    _controller.addListener(() {
      holder.setValue(_controller.page);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<double> arAndShadow = getAspectRatio();

    return Center(
      child: AspectRatio(
        aspectRatio: arAndShadow[0],
        child: ChangeNotifierProvider<PageValueHolder>.value(
          value: holder,
          child: PageView.builder(
              controller: _controller,
              itemCount: widget.children.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return MyPage(
                    child: widget.children[index],
                    number: index,
                    fraction: fraction,
                    hasShadow: widget.hasShadow,
                    shadowColor: widget.shadowColor,
                    shadowScale: arAndShadow[1]);
              }),
        ),
      ),
    );
  }
}

class MyPage extends StatelessWidget {
  final int number;
  final double fraction;
  final Widget child;
  final bool hasShadow;
  final Color? shadowColor;
  final double shadowScale;

  const MyPage({
    Key? key,
    required this.child,
    required this.number,
    required this.fraction,
    required this.hasShadow,
    this.shadowColor,
    required this.shadowScale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double value = Provider.of<PageValueHolder>(context).value;
    double diff = (number - value);

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
            duration: const Duration(milliseconds: 100),
            opacity: 1 - diff.abs(),
            child: Transform(
              alignment: FractionalOffset.bottomCenter,
              transform: shadowMatrix,
              child: Container(
                decoration: BoxDecoration(
                    boxShadow: [BoxShadow(color: shadowColor ?? Colors.black12, blurRadius: 10.0, spreadRadius: 1.0)]),
              ),
            ),
          ),
        ],
        Transform(
          transform: pvMatrix,
          alignment: FractionalOffset.center,
          child: Container(
            child: child,
          ),
        ),
      ],
    );
  }
}

class PageValueHolder extends ChangeNotifier {
  double _value;

  PageValueHolder(this._value);

  get value => _value;

  void setValue(newValue) {
    _value = newValue;
    notifyListeners();
  }
}
