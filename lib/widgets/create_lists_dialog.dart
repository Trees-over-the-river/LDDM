import 'package:flutter/material.dart';
import 'package:pricely/database/listdb.dart';
import 'package:pricely/model/list.dart';

class CreateListsDialog extends StatefulWidget {
  CreateListsDialog(this.list, {Key? key}) : super(key: key);

  final ItemList list;
  final ListDB _crudPricely = ListDB();

  //build route
  Route<CreateListsDialog> get route => PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, animation, secondaryAnimation) =>
            CreateListsDialog(list),
        barrierColor: Colors.black.withOpacity(0.5),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
          opacity: animation,
          child: child,
        ),
        barrierDismissible: true,
      );

  @override
  createState() => _CreateListsDialogState();
}

class _CreateListsDialogState extends State<CreateListsDialog> {
  late ItemList _list;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _list = widget.list;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AlertDialog(
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Nova Lista', style: TextStyle(fontSize: 30)),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: _list.name,
                onSaved: (newValue) => _list.name = newValue!,
                decoration: const InputDecoration(
                    labelText: 'Nome da Lista', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: _list.description,
                onSaved: (newValue) => _list.description = newValue!,
                decoration: const InputDecoration(
                    labelText: 'Descrição', border: OutlineInputBorder()),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        widget._crudPricely.create(_list);

                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Criar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
