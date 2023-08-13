import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>(debugLabel: "Login Form");
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _signUp = false;

  void _validateForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Logado!"),
        ),
      );

      // Go to home page
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/',
        (route) => false,
        arguments: {
          'email': _emailController.text,
          'password': _passwordController.text,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_signUp ? 'Cadastro' : 'Login'),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            constraints: const BoxConstraints(maxWidth: 800),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Hero(
                  tag: 'Logo',
                  child: FlutterLogo(
                    size: 150,
                    style: FlutterLogoStyle.markOnly,
                  ),
                ),
                SizedBox.fromSize(size: const Size.fromHeight(50)),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Coloque seu email',
                        ),
                        controller: _emailController,
                        autofocus: true,
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
                        controller: _passwordController,
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
                      AnimatedCrossFade(
                        crossFadeState: _signUp
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        firstChild: const SizedBox.shrink(),
                        sizeCurve: Curves.easeInOut,
                        duration: const Duration(milliseconds: 300),
                        secondChild: TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Confirme sua senha',
                          ),
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Informe uma senha';
                            } else if (value.length < 6) {
                              return 'Senha deve ter no mínimo 6 caracteres';
                            } else if (value != _passwordController.text) {
                              return 'Senhas não conferem';
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) => _validateForm(context),
                          obscureText: true,
                        ),
                      ),
                      SizedBox.fromSize(size: const Size.fromHeight(20)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _signUp = !_signUp;
                              });
                            },
                            child: Text(
                              _signUp
                                  ? 'Já tem conta? Login'
                                  : 'Não tem conta? Cadastre-se',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => _validateForm(context),
                            child: Text(_signUp ? 'Cadastrar' : 'Entrar'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
