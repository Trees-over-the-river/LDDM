import 'package:flutter/material.dart';
import 'package:pricely/database/itemdb.dart';
import 'package:pricely/database/listdb.dart';
import 'package:pricely/pages/item_list_page.dart';
import 'package:pricely/pages/lists_page.dart';
import 'package:pricely/pages/login.dart';
import 'package:pricely/pages/about.dart';
import 'package:pricely/widgets/item_dialog.dart';
import 'package:pricely/widgets/create_lists_dialog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'model/item.dart';
import 'model/list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ListDB listDB;
  late ItemDB itemDB;
  bool databasesOpened = false;

  @override
  void initState() {
    super.initState();
    _initializeDatabases();
  }

  Future<void> _initializeDatabases() async {
    listDB = ListDB();
    itemDB = ItemDB();
    await listDB.open('listdb.sqlite');
    await itemDB.open('itemdb.sqlite');
    setState(() {
      databasesOpened = true;
    });
  }

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
        '/items': (context) {
          final Map<String, dynamic>? args =
              ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

          if (args != null) {
            final int listId = args['listId'] as int;
            return ItemListPage(
              title: args['title'] ?? 'Nome da Lista',
              listId: listId,
            );
          }

          return const ItemListPage(title: 'Nome da Lista', listId: 0);
        },
        '/about': (context) => const AboutPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/item') {
          if (settings.arguments == null) {
            return ItemDialog(Item.empty(), true, listId: 0).route;
          }
          final item = (settings.arguments! as List)[0] as Item;
          final isNew = (settings.arguments! as List)[1] as bool;
          final listId = (settings.arguments! as List)[2] as int;

          return ItemDialog(item, isNew, listId: listId).route;
        } else if (settings.name == '/list') {
          if (settings.arguments == null) {
            return CreateListsDialog(ItemList.empty()).route;
          }
          final list = (settings.arguments! as List)[0] as ItemList;

          return CreateListsDialog(list).route;
        }
        return null;
      },
      home: databasesOpened ? const ListsPage() : const CircularProgressIndicator(),
    );
  }
}
