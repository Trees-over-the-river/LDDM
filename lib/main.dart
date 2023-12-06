import 'package:flutter/material.dart';
import 'package:pricely/database/itemdb.dart';
import 'package:pricely/pages/item_list_page.dart';
import 'package:pricely/pages/lists_page.dart';
import 'package:pricely/pages/login.dart';
import 'package:pricely/pages/about.dart';
import 'package:pricely/widgets/item_dialog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'model/item.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ItemDB itemDB = ItemDB.open('db.sqlite');

  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pricely',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green[800]!),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/login': (context) => const Login(),
        '/lists': (context) => const ListsPage(),
        '/items': (context) => const ItemListPage(),
        '/about': (context) => const AboutPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/item') {
          if (settings.arguments == null) {
            return ItemDialog(Item.empty(), true).route;
          }
          final item = (settings.arguments! as List)[0] as Item;
          final isNew = (settings.arguments! as List)[1] as bool;

          return ItemDialog(item, isNew).route;
        }
        return null;
      },
      home: const ListsPage(),
    );
  }
}

/*
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
                style: FlutterLogoStyle.markOnly,
              ),
            ),
            SizedBox.fromSize(size: const Size.fromHeight(50)),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/items');
                  },
                  child: const Text('Items'),
                ),
                const Spacer(),
                Hero(
                  tag: 'LoginButton',
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                    child: const Text('Entrar'),
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/lists'),
                    child: const Text('Lists')),
              ],
            ),
            SizedBox.fromSize(size: const Size.fromHeight(20)),
          ],
        ),
      ),
    );
  }
}
*/