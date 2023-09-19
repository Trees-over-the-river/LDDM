import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.primary),
      body: CustomPaint(
        painter: TrianglePainter(
          height: MediaQuery.of(context).size.height / 4,
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 50,
                bottom: MediaQuery.of(context).padding.bottom + 50,
                left: 50,
                right: 50),
            child: Column(
              children: [
                Text('Pricely',
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        fontFamily: 'Pacifico',
                        color: Colors.green,
                        fontSize: 80),
                    textAlign: TextAlign.center),
                const SizedBox(height: 50),
                Form(
                  child: Column(
                    children: [
                      Text(
                        'O Pricely tem como objetivo facilitar o dia a dia dos usuários ao oferecer uma forma mais rápida e fácil de manter e organizar suas listas de compras. Nele, você poderá criar várias listas, adicionando, deletando e concluindo items delas, além de poder compartilhar uma lista com seus contatos que também estão usando o app para que todos possam editá-la.\nEste aplicativo foi desenvolvido na disciplina de Laboratório de Desenvolvimento para Dispositivos Móveis por alunos de Ciência da Computação da PUC Minas.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontStyle: FontStyle.normal,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  const TrianglePainter(
      {this.color = Colors.blue,
      this.backgroundColor = Colors.white,
      this.height = 80});

  final Color color;
  final Color backgroundColor;
  final double height;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, height);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawColor(backgroundColor, BlendMode.srcOver);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
