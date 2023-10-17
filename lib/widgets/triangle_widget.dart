part of 'widgets.dart';

class TrianglePainter extends CustomPainter {
  final Offset p1;
  final Offset p2;
  final Offset p3;
  final Color? color;

  TrianglePainter({required this.p1, required this.p2, required this.p3, this.color});

  @override
  void paint(Canvas canvas, Size size) {
    // Define el color y el estilo del lápiz
    final paint = Paint()
      ..color = color ?? Colors.black
      ..style = PaintingStyle.fill
      ..strokeWidth = 4.0;

    // Crea un objeto Path y agrega las líneas del triángulo
    final path = Path();
    path.moveTo(p1.dx, p1.dy); // Mueve el lápiz al primer punto
    path.lineTo(p2.dx, p2.dy); // Dibuja una línea al segundo punto
    path.lineTo(p3.dx, p3.dy); // Dibuja una línea al tercer punto
    path.close(); // Cierra el path para formar un polígono

    // Dibuja el path en el canvas
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class TriangleWidget extends StatelessWidget {
  final double width;
  final double height;

  const TriangleWidget({Key? key, required this.width, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calcula los puntos del triángulo según el ancho y el alto del widget
    final p1 = Offset(0, height); // Punto inferior izquierdo
    final p2 = Offset(width / 2, 0); // Punto superior medio
    final p3 = Offset(width, height); // Punto inferior derecho

    return CustomPaint(
      painter: TrianglePainter(p1: p1, p2: p2, p3: p3),
      size: Size(width, height),
    );
  }
}
