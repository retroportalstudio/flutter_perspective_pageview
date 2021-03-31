import 'package:flutter/material.dart';

import 'perspective_custom_page.dart';
import 'pv_aspect_ratio.dart';

class PerspectivePageView extends StatefulWidget {
  final List<Widget> children;
  final bool hasShadow;
  final Color shadowColor;
  final PVAspectRatio aspectRatio;
  final PageController pageController;

  PerspectivePageView({
    required this.children,
    required this.hasShadow,
    this.shadowColor = Colors.black12,
    this.aspectRatio = PVAspectRatio.ONE_ONE,
    PageController? pageController,
  }) : this.pageController = pageController ?? PageController(viewportFraction: 0.5);

  @override
  _PerspectivePageViewState createState() => _PerspectivePageViewState();
}

class _PerspectivePageViewState extends State<PerspectivePageView> {
  PageController get _controller => widget.pageController;

  List<double> getAspectRatioAndShadowScale() {
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
  Widget build(BuildContext context) {
    final aspectRatioAndShadowScale = getAspectRatioAndShadowScale();
    final aspectRatio = aspectRatioAndShadowScale[0];
    final shadowScale = aspectRatioAndShadowScale[1];
    return Container(
      child: Center(
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.children.length,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              // return PerspectiveCustomPage(
              //   child: widget.children[index],
              //   number: index,
              //   fraction: _controller.viewportFraction,
              //   hasShadow: widget.hasShadow,
              //   shadowColor: widget.shadowColor,
              //   shadowScale: shadowScale,
              //   currentPage: currentPageHolder.value,
              // );
              return AnimatedBuilder(
                animation: _controller,
                child: widget.children[index],
                builder: (context, child) {
                  return PerspectiveCustomPage(
                    child: child!,
                    number: index,
                    fraction: _controller.viewportFraction,
                    hasShadow: widget.hasShadow,
                    shadowColor: widget.shadowColor,
                    shadowScale: shadowScale,
                    currentPage: (_controller.position.hasContentDimensions) ? _controller.page! : 0,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
