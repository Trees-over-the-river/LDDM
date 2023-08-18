import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../model/item.dart';

class ItemPage extends StatefulWidget {
  const ItemPage(this.item, {Key? key}) : super(key: key);

  final Item item;

  @override
  State<StatefulWidget> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  bool _editMode = false;

  void _onEdit() {
    setState(() {
      _editMode = !_editMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
              onPressed: _onEdit,
              icon: Icon(_editMode ? Icons.done : Icons.edit))
        ],
        title: Text(widget.item.name),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Hero(
                tag: "Item image ${widget.item.id}",
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: Image(
                        image: widget.item.image ??
                            const AssetImage('assets/images/no_image.png'),
                        fit: BoxFit.cover,
                      )),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                readOnly: !_editMode,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge,
                decoration: InputDecoration(
                  isCollapsed: !_editMode,
                  border: OutlineInputBorder(
                      borderSide:
                          _editMode ? const BorderSide() : BorderSide.none),
                  labelText: 'Name',
                  floatingLabelBehavior: _editMode
                      ? FloatingLabelBehavior.always
                      : FloatingLabelBehavior.never,
                ),
                controller: TextEditingController(text: widget.item.name),
              ),
              const SizedBox(height: 20),
              TextField(
                readOnly: !_editMode,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  isCollapsed: !_editMode,
                  border: OutlineInputBorder(
                      borderSide:
                          _editMode ? const BorderSide() : BorderSide.none),
                  labelText: 'Description',
                  floatingLabelBehavior: _editMode
                      ? FloatingLabelBehavior.always
                      : FloatingLabelBehavior.never,
                ),
                controller:
                    TextEditingController(text: widget.item.description),
              ),
              const SizedBox(height: 20),
              Row(
                //TODO: Row out of bounds
                children: [
                  Expanded(
                    child: TextField(
                      readOnly: !_editMode,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[0-9]+([\.,][0-9]*)?')),
                      ],
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        isCollapsed: !_editMode,
                        border: OutlineInputBorder(
                            borderSide: _editMode
                                ? const BorderSide()
                                : BorderSide.none),
                        labelText: 'Amount',
                        floatingLabelBehavior: _editMode
                            ? FloatingLabelBehavior.always
                            : FloatingLabelBehavior.never,
                      ),
                      controller: TextEditingController(
                          text: widget.item.amount.toString()),
                    ),
                  ),
                  SizedBox(
                      width: 50,
                      child: DropdownMenu(
                        dropdownMenuEntries: AmountUnit.values
                            .map((e) => DropdownMenuEntry(
                                  label: e.name,
                                  value: e,
                                ))
                            .toList(),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
