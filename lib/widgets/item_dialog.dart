import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pricely/database/itemdb.dart';
import 'package:pricely/model/item.dart';

class ItemDialog extends StatefulWidget {
  ItemDialog(this.item, this.isNew, {Key? key}) : super(key: key);

  final Item item;
  final bool isNew;
  final ItemDB _crudPricely = ItemDB();

  //build route
  Route<ItemDialog> get route => PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, animation, secondaryAnimation) =>
            ItemDialog(item, isNew),
        barrierColor: Colors.black.withOpacity(0.5),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
          opacity: animation,
          child: child,
        ),
        barrierDismissible: true,
      );

  @override
  createState() => _ItemDialogState();
}

class _ItemDialogState extends State<ItemDialog> {
  late Item _item;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _item = widget.item;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: AlertDialog(
          title: Hero(
            tag: "Item image ${widget.item.id}",
            child: (_item.image != null)
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      constraints: const BoxConstraints.expand(height: 150),
                      child: Image(
                        image: _item.image!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  initialValue: _item.name,
                  onSaved: (newValue) => _item.name = newValue!,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                  ),
                ),
                TextFormField(
                  onSaved: (newValue) => _item.description = newValue!,
                  initialValue: _item.description,
                  decoration: const InputDecoration(
                    labelText: 'Descrição',
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: widget.isNew
                            ? ''
                            : _item.amount.toString(),
                        onSaved: (newValue) =>
                            _item.amount = int.parse(newValue!),
                        decoration: const InputDecoration(
                          labelText: 'Quantidade',
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                    ),
                    DropdownButton<AmountUnit>(
                      alignment: Alignment.centerLeft,
                      value: _item.amountUnit,
                      onChanged: (value) {
                        setState(() {
                          _item.amountUnit = value ?? AmountUnit.none;
                        });
                      },
                      items: AmountUnit.values
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e.name),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  if (widget.isNew) {
                    widget._crudPricely.create(_item);
                  } else {
                    widget._crudPricely.update(_item);
                  }
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        ));
  }
}
