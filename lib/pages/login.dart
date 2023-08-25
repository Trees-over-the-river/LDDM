import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                const SizedBox(height: 150),
                Form(
                  child: Column(
                    children: [
                      Text(
                        'O Pricely enviará uma mensagem SMS para verificar seu número de telefone.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                      ),
                      const SizedBox(height: 50),
                      Row(children: [
                        SizedBox(
                          width: 80,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'DDD',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(2)
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Número de telefone',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(11)
                            ],
                          ),
                        ),
                      ]),
                      const SizedBox(height: 50),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('Login'),
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
