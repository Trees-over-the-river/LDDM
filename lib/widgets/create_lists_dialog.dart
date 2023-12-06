import 'package:flutter/material.dart';

class CreateListsDialog extends StatefulWidget {
  const CreateListsDialog({Key? key}) : super(key: key);

  @override
  createState() => _CreateListsDialogState();
}

class _CreateListsDialogState extends State<CreateListsDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Nova Lista', style: TextStyle(fontSize: 30)),
            const SizedBox(height: 20),
            const TextField(
              decoration: InputDecoration(
                  labelText: 'Nome da Lista', border: OutlineInputBorder()),
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
                  onPressed: () { // TODO: salvar lista
                    Navigator.pop(context);
                  },
                  child: const Text('Criar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
