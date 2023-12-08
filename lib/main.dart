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

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ListDB listDB = ListDB.open('listdb.sqlite');
  final ItemDB itemDB = ItemDB.open('itemdb.sqlite');

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
        // '/items': (context) => const ItemListPage(),
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
        } else if (settings.name == '/list') {
          if (settings.arguments == null) {
            return CreateListsDialog(ItemList.empty()).route;
          }
          final list = (settings.arguments! as List)[0] as ItemList;

          return CreateListsDialog(list).route;
        } else if (settings.name == '/items') {
          if (settings.arguments != null) {
            final listId = settings.arguments as int; // Supondo que você passará o ID da lista como um argumento

            return MaterialPageRoute(
              builder: (context) => ItemListPage(title: 'Nome da Lista', listId: listId),
            );
          }
        }
        return null;
      },
      home: const ListsPage(),
    );
  }
}
