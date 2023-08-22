import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: TrianglePainter(
          color: Theme.of(context).colorScheme.primary,
          height: MediaQuery.of(context).size.height / 2),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 20),
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Hero(
                  tag: 'Logo',
                  child: FlutterLogo(
                    size: 150,
                    style: FlutterLogoStyle.markOnly,
                  ),
                ),
                SizedBox.fromSize(size: const Size.fromHeight(50)),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  obscureText: true,
                ),
                SizedBox.fromSize(size: const Size.fromHeight(20)),
                Hero(
                  tag: 'LoginButton',
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/items');
                    },
                    child: const Text('Entrar'),
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
