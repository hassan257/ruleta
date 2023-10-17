part of 'widgets.dart';


// ignore: must_be_immutable
class CustomRoulette extends StatefulWidget {
  double? width;
  final List<RouletteElementModel> elements;
  CustomRoulette({Key? key, this.width, required this.elements}) : super(key: key);

  @override
  State<CustomRoulette> createState() => _CustomRouletteState();
}

class _CustomRouletteState extends State<CustomRoulette>  with SingleTickerProviderStateMixin{
  bool isSpinning = false;
  

  // ignore: unused_field
  late AnimationController _animationController;
  double rotationAngle = 0;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    super.initState();
  }

  void _spinRoulette() {
    if (!isSpinning) {
      setState(() {
        isSpinning = true;
        // currentPosition = Random().nextInt(5); // Genera un número aleatorio entre 0 y 4
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
    
    return Column(
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
                painter: RoulettePainter(elements: widget.elements),
              ),
            ),
          ),
        ),
        const SizedBox(height: 30,),
        CustomButton(
          text: 'Spin',
          colorButton: Colors.blueAccent,
          colorText: Colors.white,
          onPressed: _spinRoulette,
          icon: Icons.cyclone,
        ),
        const SizedBox(height: 10,),
        CustomButton(
          text: 'Reset',
          colorButton: Colors.redAccent,
          colorText: Colors.white,
          icon: Icons.restore,
          onPressed: () {
            final OptionsRouletteController optionsRouletteController = Get.find<OptionsRouletteController>();
            optionsRouletteController.options.clear();
            print('cantidad = ${optionsRouletteController.options.length}');
          },
        )
      ],
    );
  }
}

class RoulettePainter extends CustomPainter {
  final List<RouletteElementModel> elements;
  RoulettePainter({required this.elements});
  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width / 2;

    final OptionsRouletteController optionsRouletteController = Get.find<OptionsRouletteController>();

    // final colors = [Colors.red, Colors.blue, Colors.green, Colors.yellow, Colors.orange];
    // final texts = ['1', '2', '3', '4', '5'];

    final sectionAngle = 2 * pi / optionsRouletteController.options.length;

    double startAngle = -pi / 2;

    for (int i = 0; i < optionsRouletteController.options.length; i++) {
      final paint = Paint()..color = optionsRouletteController.options[i].color;
      canvas.drawArc(Rect.fromCircle(center: Offset(centerX, centerY), radius: radius), startAngle, sectionAngle, true, paint);

      final textPainter = TextPainter(
        text: TextSpan(
          text: optionsRouletteController.options[i].text,
          style: const TextStyle(color: Colors.black, fontSize: 30),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      final textAngle = startAngle + sectionAngle / 2;
      final textX = centerX + radius * cos(textAngle) - textPainter.width / 2;
      final textY = centerY + radius * sin(textAngle) - textPainter.height / 2;
      textPainter.paint(canvas, Offset(textX, textY));

      startAngle += sectionAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}