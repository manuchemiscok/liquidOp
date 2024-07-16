import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Administrador/MenuAdm.dart';
import '../Login/RecuperarSenha.dart';
import 'package:liquidop/Utils/gradientUtils.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();

  final firebaseAuth = FirebaseAuth.instance;
  bool isPasswordTooLong = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'LOGIN',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
          decoration: BoxDecoration(
            gradient: gradientUtils.getLinearGradient(),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black, // Alteração: Background preto
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "AVISO: Opção disponível apenas para Administradores.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.yellow, // Alteração: Texto amarelo
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 120),
              Container(
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 20,
                  right: MediaQuery.of(context).size.width / 20,
                  left: MediaQuery.of(context).size.width / 20,
                ),
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.black, // Alteração: Background preto
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 3,
                    ),
                  ],
                ),
                child: TextField(
                  controller: emailController,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(40),
                  ],
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: Colors.yellow,
                  style: const TextStyle(
                      color: Colors.white), // Alteração: Texto branco
                  decoration: const InputDecoration(
                    hintText: 'E-mail',
                    hintStyle: TextStyle(color: Colors.white),
                    prefixIcon: Icon(
                      Icons.alternate_email,
                      color: Colors.yellow,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 10,
                  right: MediaQuery.of(context).size.width / 20,
                  left: MediaQuery.of(context).size.width / 20,
                ),
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.black, // Alteração: Background preto
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 3,
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: senhaController,
                  obscureText: true,
                  cursorColor: Colors.yellow,
                  style: const TextStyle(
                      color: Colors.white), // Alteração: Texto branco
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                  ],
                  decoration: const InputDecoration(
                    hintText: 'Senha',
                    hintStyle: TextStyle(color: Colors.white),
                    prefixIcon: Icon(
                      Icons.vpn_key,
                      color: Colors.yellow,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    style: TextButton.styleFrom(),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecuperarSenha(),
                        ),
                      );
                    },
                    child: const Text(
                      "Recuperar Senha",
                      style: TextStyle(
                          color: Colors.black), // Alteração: Texto preto
                    ),
                  ),
                ),
              ),
              Container(
                height: 50,
                margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 20,
                  vertical: 25,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    login();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.black, // Alteração: Background preto
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: const Text(
                    'Entrar',
                    style: TextStyle(
                      color: Colors.yellow, // Alteração: Texto amarelo
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 230),
            ],
          ),
        ),
      ),
    );
  }

  login() async {
    try {
      UserCredential userCredential =
          await firebaseAuth.signInWithEmailAndPassword(
              email: emailController.text, password: senhaController.text);
      if (userCredential != null) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const MenuAdm()));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // ignore: use_build_context_synchronously
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Usuário não Encontrado"),
                actions: [
                  TextButton(
                    child: const Text("Ok"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      } else if (e.code == 'wrong-password') {
        // ignore: use_build_context_synchronously
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Verifique se sua senha esta correta"),
                actions: [
                  TextButton(
                    child: const Text("Ok"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      } else if (e.code == 'invalid-email') {
        // ignore: use_build_context_synchronously
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Formato de Email Incorreto"),
                actions: [
                  TextButton(
                    child: const Text("Ok"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      } else if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        // ignore: use_build_context_synchronously
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title:
                    const Text("Verifique se seu email e senha estao corretos"),
                actions: [
                  TextButton(
                    child: const Text("Ok"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      }
    }
  }
}
