library perspective_pageview;

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

enum PVAspectRatio {
  ONE_ONE,
  SIXTEEN_NINE,
}

class PerspectivePageView extends StatefulWidget {
  final List<Widget> children;
  final bool hasShadow;
  final Color shadowColor;
  final PVAspectRatio aspectRatio;

  PerspectivePageView({@required this.children, @required this.hasShadow, this.shadowColor,this.aspectRatio});

  @override
  _PerspectivePageViewState createState() => _PerspectivePageViewState();
}

class _PerspectivePageViewState extends State<PerspectivePageView> {
  PageValueHolder holder;
  double fraction = 0.50;
  PageController _controller;

  getAspectRatio(){
    switch(widget.aspectRatio){
      case PVAspectRatio.ONE_ONE:
        return [1.0,1.6];
        break;
      case PVAspectRatio.SIXTEEN_NINE:
        return [16/9,1.1];
        break;
      default:
        return [1.0,1.6];
        break;
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
    final List<num> arAndShadow = getAspectRatio();
    return Container(
      child: Center(
        child: AspectRatio(
          aspectRatio: arAndShadow[0],
          child: ChangeNotifierProvider<PageValueHolder>.value(
            value: holder,
            child: PageView.builder(
                controller: _controller,
                itemCount: widget.children.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return MyPage(
                      child: widget.children[index],
                      number: index,
                      fraction: fraction,
                      hasShadow: widget.hasShadow,
                      shadowColor: widget.shadowColor,
                      shadowScale:arAndShadow[1]);
                }),
          ),
        ),
      ),
    );
  }
}

class MyPage extends StatelessWidget {
  final int number;
  final double fraction;
  final Widget child;
  final Color shadowColor;
  final bool hasShadow;
  final double shadowScale;

  MyPage({this.child, this.number, this.fraction, this.hasShadow, this.shadowColor,this.shadowScale});

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
            duration: Duration(milliseconds: 100),
            opacity: 1 - diff.abs(),
            child: Transform(
              alignment: FractionalOffset.bottomCenter,
              transform: shadowMatrix,
              child: Container(
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(color: shadowColor??Colors.black12, blurRadius: 10.0, spreadRadius: 1.0)
                ]),
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

  PageValueHolder(value) {
    this._value = value;
  }

  get value => this._value;

  void setValue(newValue) {
    this._value = newValue;
    notifyListeners();
  }
}

