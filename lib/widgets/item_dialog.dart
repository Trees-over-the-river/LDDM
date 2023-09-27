import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pricely/model/item.dart';

class ItemDialog extends StatefulWidget {
  const ItemDialog(this.item, {Key? key}) : super(key: key);

  final Item item;

  //build route
  Route<ItemDialog> get route => PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, animation, secondaryAnimation) =>
            ItemDialog(item),
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
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Hero(
        tag: "Item image ${widget.item.id}",
        child: (widget.item.image != null)
            ? ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  constraints: const BoxConstraints.expand(height: 150),
                  child: Image(
                    image: widget.item.image!,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: TextEditingController(text: widget.item.name),
              decoration: const InputDecoration(
                labelText: 'Nome',
              ),
            ),
            TextField(
              controller: TextEditingController(text: widget.item.description),
              decoration: const InputDecoration(
                labelText: 'Descrição',
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: TextEditingController(
                        text: widget.item.amount.toString()),
                    decoration: const InputDecoration(
                      labelText: 'Quantidade',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
                DropdownButton<AmountUnit>(
                  alignment: Alignment.centerLeft,
                  value: widget.item.amountUnit,
                  onChanged: (value) {
                    setState(() {
                      widget.item.amountUnit = value ?? AmountUnit.none;
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
          onPressed: () => Navigator.pop(context),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
