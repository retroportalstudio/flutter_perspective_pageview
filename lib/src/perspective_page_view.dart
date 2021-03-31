import 'package:flutter/material.dart';

import 'perspective_custom_page.dart';
import 'pv_aspect_ratio.dart';

class PerspectivePageView extends StatefulWidget {
  final List<Widget> children;
  final bool hasShadow;
  final Color shadowColor;
  final PVAspectRatio aspectRatio;

  PerspectivePageView({
    required this.children,
    required this.hasShadow,
    this.shadowColor = Colors.black12,
    this.aspectRatio = PVAspectRatio.ONE_ONE,
  });

  @override
  _PerspectivePageViewState createState() => _PerspectivePageViewState();
}

class _PerspectivePageViewState extends State<PerspectivePageView> {
  final currentPageHolder = ValueNotifier(2.0);
  final fraction = 0.50;
  late final _controller = PageController(initialPage: 2, viewportFraction: fraction);

  List<double> getAspectRatio() {
    switch (widget.aspectRatio) {
      case PVAspectRatio.ONE_ONE:
        return [1.0, 1.6];
      case PVAspectRatio.SIXTEEN_NINE:
        return [16 / 9, 1.1];
      default:
        return [1.0, 1.6];
    }
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      currentPageHolder.value = _controller.page ?? 0;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<double> arAndShadow = getAspectRatio();
    return Container(
      child: Center(
        child: AspectRatio(
          aspectRatio: arAndShadow[0],
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.children.length,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return ValueListenableBuilder<double>(
                valueListenable: currentPageHolder,
                child: widget.children[index],
                builder: (context, currentPage, child) => PerspectiveCustomPage(
                  child: child!,
                  number: index,
                  fraction: fraction,
                  hasShadow: widget.hasShadow,
                  shadowColor: widget.shadowColor,
                  shadowScale: arAndShadow[1],
                  currentPage: currentPage,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
