// Importa bibliotecas necessárias para o Flutter e Firebase
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:liquidop/Administrador/MenuAdm.dart';
import 'package:liquidop/Utils/gradientUtils.dart';

// Classe que representa a tela de cadastro de administrador
class CadastroDeAdministrador extends StatefulWidget {
  const CadastroDeAdministrador({Key? key}) : super(key: key);

  @override
  State<CadastroDeAdministrador> createState() =>
      _CadastroDeAdministradorState();
}

// Estado associado à tela de cadastro de administrador
class _CadastroDeAdministradorState extends State<CadastroDeAdministrador> {
  // Controladores para os campos de nome, e-mail e senha
  TextEditingController nomeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Configuração da aparência da tela
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Cadastro de Administrador',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navega de volta para a tela do menu do administrador
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const MenuAdm()));
          },
        ),
      ),
      body: Center(
        child: Container(
          // Configuração do conteúdo central da tela
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
          decoration: BoxDecoration(
            gradient: gradientUtils.getLinearGradient(),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 10),
              // Campo de texto para inserir o nome
              TextFormField(
                controller: nomeController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.black,
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 10),
              // Campo de texto para inserir o e-mail
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.black,
                ),
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 10),
              // Campo de texto para inserir a senha
              TextFormField(
                controller: senhaController,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.black,
                ),
                obscureText: true,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),
              // Botão para cadastrar o administrador
              ElevatedButton(
                onPressed: () {
                  // Obtém os valores inseridos nos campos
                  String nome = nomeController.text;
                  String email = emailController.text;
                  String senha = senhaController.text;

                  // Chama a função para adicionar o administrador
                  _adicionarAdministrador(nome, email, senha);
                },
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 0, 0, 0),
                ),
                child: Text('Cadastrar Administrador'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Função para adicionar um administrador ao Firebase
  Future<void> _adicionarAdministrador(
      String nome, String email, String senha) async {
    try {
      // Cria um usuário no Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: senha);

      // Envia um e-mail de verificação para o usuário
      await userCredential.user!.sendEmailVerification();

      // Obtém o ID do usuário recém-criado
      String userId = userCredential.user!.uid;

      // Adiciona os detalhes do administrador ao Firestore
      await FirebaseFirestore.instance
          .collection('Administrador')
          .doc(userId)
          .set({
        'nome': nome,
        'email': email,
      });

      // Exibe mensagem no console indicando que o administrador foi cadastrado
      print('Administrador cadastrado com ID: $userId');

      // Limpa os campos após o cadastro
      nomeController.clear();
      emailController.clear();
      senhaController.clear();
    } catch (error) {
      // Exibe mensagem de erro no console caso ocorra algum problema
      print('Erro ao cadastrar administrador: $error');
    }
  }
}
