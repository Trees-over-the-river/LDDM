import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  void _validateForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logado com sucesso')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.center,
          child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const FlutterLogo(
                      size: 150,
                    ),
                    SizedBox.fromSize(size: const Size.fromHeight(20)),
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
                      onFieldSubmitted: (_) => _validateForm(context),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Coloque sua senha',
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe uma senha';
                        } else if (value.length < 6) {
                          return 'Senha deve ter no mínimo 6 caracteres';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) => _validateForm(context),
                      obscureText: true,
                    ),
                    SizedBox.fromSize(size: const Size.fromHeight(20)),
                    ElevatedButton(
                      onPressed: () => _validateForm(context),
                      child: const Text('Login'),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  ],
                ),
              )),
        ));
  }
}
