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
        '/login': (context) => const Login(),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Hero(
              tag: 'Logo',
              child: FlutterLogo(
                size: 150,
                curve: Curves.easeInOut,
                duration: Duration(seconds: 1),
                style: FlutterLogoStyle.markOnly,
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
