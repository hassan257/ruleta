part of 'widgets.dart';


// ignore: must_be_immutable
class CustomRoulette extends StatefulWidget {
  double? width;
  CustomRoulette({Key? key, this.width}) : super(key: key);

  @override
  State<CustomRoulette> createState() => _CustomRouletteState();
}

class _CustomRouletteState extends State<CustomRoulette>  with SingleTickerProviderStateMixin{
  
  bool isSpinning = false;
  double rotationAngle = 0;

  // ignore: unused_field
  late AnimationController _animationController;
  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    super.initState();
  }

  void _spinRoulette() {
    if (!isSpinning) {
      setState(() {
        isSpinning = true;
      });

      // Simula una espera para la animación
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          isSpinning = false;
          final rand = Random();
          rotationAngle = rand.nextInt(360) * 2 * pi / 360;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    
    const double heightRoulette = 200;
    double widthRoulette = widget.width ?? 200;
    
    return GestureDetector(
      onTap: _spinRoulette,
      onVerticalDragEnd: (_) => _spinRoulette(),
      onHorizontalDragEnd: (_) => _spinRoulette(),
      child: Column(
        children: [
          Roulette(
            animate: isSpinning,
            spins: 10,
            duration: const Duration(seconds: 3),
            child: SizedBox(
              height: heightRoulette,
              width: widthRoulette,
              child: Transform.rotate(
                angle: rotationAngle,
                child: CustomPaint(
                  painter: RoulettePainter(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RoulettePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width / 2;

    final OptionsRouletteController optionsRouletteController = Get.find<OptionsRouletteController>();


    final sectionAngle = 2 * pi / optionsRouletteController.options.length;

    double startAngle = -pi / 2;

    for (int i = 0; i < optionsRouletteController.options.length; i++) {
      final paint = Paint()..color = optionsRouletteController.options[i].color;
      canvas.drawArc(Rect.fromCircle(center: Offset(centerX, centerY), radius: radius), startAngle, sectionAngle, true, paint);

      startAngle += sectionAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}