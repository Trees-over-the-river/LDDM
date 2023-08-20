import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pricely/model/item.dart';

class ItemDialog extends StatefulWidget {
  const ItemDialog(this.item, {Key? key}) : super(key: key);

  final Item item;

  @override
  _ItemDialogState createState() => _ItemDialogState();
}

class _ItemDialogState extends State<ItemDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.item.name),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: "Item image ${widget.item.id}",
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                    constraints: const BoxConstraints.expand(height: 100),
                    child: Image(
                      image: widget.item.image ??
                          const AssetImage('assets/images/no_image.png'),
                      fit: BoxFit.cover,
                    )),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: TextEditingController(text: widget.item.name),
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
              readOnly: true,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: TextEditingController(text: widget.item.description),
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
              readOnly: true,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: TextEditingController(
                        text: widget.item.amount.toString()),
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                    ),
                    readOnly: true,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
                DropdownButton<AmountUnit>(
                  alignment: Alignment.centerLeft,
                  value: widget.item.amountUnit,
                  onChanged: (value) {},
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
            TextField(
              controller:
                  TextEditingController(text: widget.item.category.join(', ')),
              decoration: const InputDecoration(
                labelText: 'Category',
              ),
              readOnly: true,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
