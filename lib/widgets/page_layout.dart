import 'package:flutter/material.dart';

@immutable
class TitleSection extends StatelessWidget {
  TitleSection({
    super.key,
    required this.title,
    required this.backgroundImage
  });

  final String title;
  final String backgroundImage;
  final GlobalKey _backgroundImageKey = GlobalKey();



  @override
  Widget build(BuildContext context) {

    return AspectRatio(
      aspectRatio: 19 / 9,
      child: Stack(
        children: [
          _buildParallaxBackground(context),
          _buildGradient(),
          _buildTitleAndSubtitle(context),
        ],
      ),
    );
  }

  Widget _buildParallaxBackground(BuildContext context) {
    return  Flow(
      delegate: ParallaxFlowDelegate(
        scrollable: Scrollable.of(context),
        titleSectionContext: context,
        backgroundImageKey: _backgroundImageKey,
      ),
      children: [
        Image.asset(
          backgroundImage,
          key: _backgroundImageKey,
          fit: BoxFit.cover,
        ),
      ],
    );
  }

  Widget _buildGradient() {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.75, 1],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleAndSubtitle(BuildContext context) {
    return Positioned(
      left: 20,
      bottom: 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: Colors.white
            )
          ),
        ],
      ),
    );
  }

}

class ParallaxFlowDelegate extends FlowDelegate {
  ParallaxFlowDelegate({
    required this.scrollable,
    required this.titleSectionContext,
    required this.backgroundImageKey,
  }) : super (repaint: scrollable.position);

  final ScrollableState scrollable;
  final BuildContext titleSectionContext;
  final GlobalKey backgroundImageKey;

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
    return BoxConstraints.tightFor(
      width: constraints.maxWidth,
    );
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    // Calculate the position of this list item within the viewport.
    final scrollableBox = scrollable.context.findRenderObject() as RenderBox;
    final listItemBox = titleSectionContext.findRenderObject() as RenderBox;
    final listItemOffset = listItemBox.localToGlobal(
        listItemBox.size.centerLeft(Offset.zero),
        ancestor: scrollableBox);

    // Determine the percent position of this list item within the
    // scrollable area.
    final viewportDimension = scrollable.position.viewportDimension;
    final scrollFraction =
    (listItemOffset.dy / viewportDimension).clamp(0.0, 1.0);

    // Calculate the vertical alignment of the background
    // based on the scroll percent.
    final verticalAlignment = Alignment(0.0, scrollFraction * 2 - 1);

    // Convert the background alignment into a pixel offset for
    // painting purposes.
    final backgroundSize =
        (backgroundImageKey.currentContext!.findRenderObject() as RenderBox)
            .size;
    final listItemSize = context.size;
    final childRect =
    verticalAlignment.inscribe(backgroundSize, Offset.zero & listItemSize);

    // Paint the background.
    context.paintChild(
      0,
      transform:
      Transform.translate(offset: Offset(0.0, childRect.top)).transform,
    );
  }

  @override
  bool shouldRepaint(ParallaxFlowDelegate oldDelegate) {
    return scrollable != oldDelegate.scrollable ||
        titleSectionContext != oldDelegate.titleSectionContext ||
        backgroundImageKey != oldDelegate.backgroundImageKey;
  }

}

class UnorderedList extends StatelessWidget {
  final String indicatorCharacter;
  final List<Widget> children;
  final TextStyle indicatorStyle;
  final double separation;

  const UnorderedList({
    super.key,
    String? indicatorCharacter,
    required this.children,
    TextStyle? indicatorStyle,
    double? separation
  }) :
    indicatorCharacter = indicatorCharacter ?? '\u2022',
    indicatorStyle = indicatorStyle ?? const TextStyle(
      fontSize: 16,
      height: 1.55,
    ),
    separation = separation ?? 5
  ;


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children.map((childWidget) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              indicatorCharacter,
              style: indicatorStyle
            ),
            SizedBox(
              width: separation,
            ),
            Expanded(child: childWidget),
          ],
        );
      }).toList(),
    );
  }

}

class OrderedList extends StatelessWidget {
  final List<Widget> children;
  final TextStyle numberingStyle;
  final double separation;

  const OrderedList({
    super.key,
    required this.children,
    TextStyle? numberingStyle,
    double? separation
  }) :
        numberingStyle = numberingStyle ?? const TextStyle(
          fontSize: 16,
          height: 1.55,
        ),
        separation = separation ?? 5
  ;


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List<Widget>.generate(children.length, (index) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                "${index + 1}.",
                style: numberingStyle
            ),
            SizedBox(
              width: separation,
            ),
            Expanded(child: children[index]),
          ],
        );
      })
    );
  }

}
