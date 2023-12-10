import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _dddController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsCodeController = TextEditingController();

  String verificationId = '';
  bool codeSent = false;

  User? _user;

  @override
  void initState() {
    super.initState();
    // Verifica se o usuário já está autenticado
    checkCurrentUser();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.primary),
      body: _user != null ? buildAuthenticatedView() : buildLoginView(),
    );
  }

  void checkCurrentUser() {
    // Verificar se o usuário já está autenticado
    FirebaseAuth auth = FirebaseAuth.instance;
    
    final currentUser = auth.currentUser;
    if (currentUser != null) {
      setState(() {
        _user = currentUser;
      });
    }
  }

  Widget buildAuthenticatedView() {
    return CustomPaint(
      painter: TrianglePainter(
        height: MediaQuery.of(context).size.height / 4,
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 50,
              bottom: MediaQuery.of(context).padding.bottom + 50,
              left: 50,
              right: 50),
          child: Column(
            children: [
              Text('Pricely',
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      fontFamily: 'Pacifico',
                      color: Colors.green,
                      fontSize: 80),
                  textAlign: TextAlign.center),
              const SizedBox(height: 160),
              Text(
                'Você já está autenticado no Pricely!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontStyle: FontStyle.italic,
                  fontSize: 25
                ),
              ),
              const SizedBox(height: 160),
              ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  
                  setState(() {
                    _user = null;
                  });
                },
                child: const Text('Sair'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLoginView() {
    return CustomPaint(
      painter: TrianglePainter(
        height: MediaQuery.of(context).size.height / 4,
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 50,
              bottom: MediaQuery.of(context).padding.bottom + 50,
              left: 50,
              right: 50),
          child: Column(
            children: [
              Text('Pricely',
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      fontFamily: 'Pacifico',
                      color: Colors.green,
                      fontSize: 80),
                  textAlign: TextAlign.center),
              const SizedBox(height: 53),
              Text(
                'O Pricely enviará uma mensagem SMS para verificar seu número de telefone.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
              ),
              const SizedBox(height: 50),
              Row(children: [
                  SizedBox(
                    width: 80,
                    child: TextFormField(
                      controller: _dddController,
                      decoration: const InputDecoration(
                        labelText: 'DDD',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(2)
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: _phoneNumberController,
                      decoration: const InputDecoration(
                        labelText: 'Número de telefone',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(9),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  String ddd = _dddController.text;
                  String phoneNumber = _phoneNumberController.text;
                  String combinedPhoneNumber = '+55$ddd$phoneNumber';
                  verifyPhoneNumber(combinedPhoneNumber);
                },
                child: const Text('Enviar'),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    child: TextFormField(
                      controller: _smsCodeController,
                      decoration: const InputDecoration(
                        labelText: 'Código SMS',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  signInWithPhoneAuthCredential(_smsCodeController.text);
                },
                child: const Text('Verificar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Caso a verificação seja completada automaticamente
        await auth.signInWithCredential(credential);

        // Exibe mensagem de confirmação
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Autenticação realizada com sucesso'),
          ),
        );

        // Volta para a página anterior (ListsPage)
        Navigator.pop(context);
      },
      verificationFailed: (FirebaseAuthException e) {
        print('Falha na verificação do número');
        print(e.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        // Código SMS foi enviado -> Solicitar que usuário digite o código
        // Pode exibir um diálogo ou um Snackbar para coletar o código SMS
        // Neste exemplo, exibirei um SnackBar

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Digite o código SMS'),
            action: SnackBarAction(
              label: 'OK',
              onPressed: () {
                // Você pode utilizar o código SMS digitado aqui
                // Chame a função signInWithPhoneAuthCredential() passando o código
                signInWithPhoneAuthCredential(_smsCodeController.text);
              },
            ),
          ),
        );

        // Armazena o ID de verificação enviado para usar posteriormente
        setState(() {
          this.verificationId = verificationId;
          codeSent = true;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Tempo limite para autenticação automática excedido
       
      },
    );
  }

  Future<void> signInWithPhoneAuthCredential(String smsCode) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      // SMS foi enviado, fazer verificação
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      await auth.signInWithCredential(credential);

      // Exibe mensagem de confirmação
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Autenticação realizada com sucesso'),
        ),
      );

      // Volta para a página anterior (ListsPage)
      Navigator.pop(context);

    } catch (e) {
      print('Falha na verificação do SMS');
      print(e.toString());
    }
  }
}

class TrianglePainter extends CustomPainter {
  const TrianglePainter(
      {this.color = Colors.blue,
      this.backgroundColor = Colors.white,
      this.height = 80});

  final Color color;
  final Color backgroundColor;
  final double height;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, height);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawColor(backgroundColor, BlendMode.srcOver);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
