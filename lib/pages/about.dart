import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);
  @override
  createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.primary),
      body: Stack(
        children: [
          CustomPaint(
            painter: TrianglePainter(
              height: MediaQuery.of(context).size.height / 4,
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Container(),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 90),
                  Text(
                    'Pricely',
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                          fontFamily: 'Pacifico',
                          color: Colors.green,
                          fontSize: 80,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'O Pricely é a sua solução completa para listas de compras inteligentes e compartilhadas. Simplificamos a maneira como você gerencia suas compras diárias, permitindo criar, organizar e compartilhar suas listas com facilidade.\n\nCrie várias listas, adicione ou remova itens, marque itens como concluídos e convide seus contatos para colaborar nas listas compartilhadas. Tudo em um só lugar!',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Image(
                      image: AssetImage('assets/logoPUC.jpg'),
                      width: 120,  
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Aplicativo desenvolvido por alunos do 4° período de Ciência da Computação na PUC Minas Coração Eucarístico como trabalho da disciplina Laboratório de Desenvolvimento para Dispositivos Móveis.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
