part of 'widgets.dart';
class RouletteWidget extends StatelessWidget {
  const RouletteWidget({
    Key? key,
    required this.widthRoulette,
    required this.widthIndicator,
    required this.heightIndicator,
  }) : super(key: key);

  final double widthRoulette;
  final double widthIndicator;
  final double heightIndicator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Center(
        child: Stack(
          children: [
            CustomRoulette(
              width: widthRoulette,
              elements: [
                RouletteElementModel(text: 'text', color: Colors.red)
              ],
            ),
            Positioned(
              child: Transform.rotate(
                angle: 160.2,
                child: TriangleWidget(
                  width: widthIndicator, 
                  height: heightIndicator
                )), 
              left: widthRoulette / 2 - widthIndicator / 2,
              top: 0,
            ),
          ],
        ),
      ),
    );
  }
}