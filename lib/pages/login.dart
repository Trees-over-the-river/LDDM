import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                Navigator.of(context).pushNamed('/home');
              },
            )
          ],
        ),
        body: Center(
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Coloque seu email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe um email';
                      } else if (!value.contains(
                          RegExp(r'^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$'))) {
                        return 'Email inválido';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Coloque sua senha',
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    validator: (value) {
                      if (value == null) {
                        return 'Senha inválida';
                      } else if (value.isEmpty) {
                        return 'Informe uma senha';
                      } else if (value.length < 6) {
                        return 'Senha deve ter no mínimo 6 caracteres';
                      }
                      return null;
                    },
                    obscureText: true,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Logado com sucesso')),
                        );
                      }
                    },
                    child: const Text('Login'),
                  ),
                ],
              )),
        ));
  }
}
