import 'package:flutter/material.dart';
import 'package:pricely/pages/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pricely',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/login': (context) => Login(),
      },
      home: const MyHomePage(title: 'Pricely'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          _initialized = true;
        });
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'Logo',
              child: FlutterLogo(
                size: 150,
                curve: Curves.easeInOut,
                duration: const Duration(seconds: 1),
                style: _initialized
                    ? FlutterLogoStyle.markOnly
                    : FlutterLogoStyle.horizontal,
              ),
            ),
            SizedBox.fromSize(size: const Size.fromHeight(50)),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: const Text('Login'),
            ),
            SizedBox.fromSize(size: const Size.fromHeight(20)),
          ],
        ),
      ),
    );
  }
}
