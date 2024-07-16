// Importa as bibliotecas necessárias para criar a tela e interagir com o banco de dados
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:liquidop/Administrador/MenuAdm.dart';
import 'package:liquidop/Utils/gradientUtils.dart';

// Classe que representa a tela de cadastro de ingredientes
class CadastroDeIngredientes extends StatefulWidget {
  // Construtor da classe
  const CadastroDeIngredientes({Key? key}) : super(key: key);

  // Método obrigatório para criar o estado associado à tela
  @override
  State<CadastroDeIngredientes> createState() => _CadastroDeIngredientesState();
}

// Estado associado à tela de cadastro de ingredientes
class _CadastroDeIngredientesState extends State<CadastroDeIngredientes> {
  // Controladores para os campos de nome, descrição, preço e quantidade
  TextEditingController nomeController = TextEditingController();
  TextEditingController descricaoController = TextEditingController();
  TextEditingController precoController = TextEditingController();
  TextEditingController quantidadeController = TextEditingController();

  // Instância do Firestore para interagir com o banco de dados
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Método para construir a interface gráfica da tela
  @override
  Widget build(BuildContext context) {
    // Configuração da barra superior da tela
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Cadastro de Ingredientes',
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
      // Configuração do conteúdo central da tela
      body: Center(
        child: Container(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
          decoration: BoxDecoration(
            gradient: gradientUtils.getLinearGradient(),
          ),
          // Lista de widgets que compõem o conteúdo da tela
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              // Campo de texto para inserir o nome do ingrediente
              TextFormField(
                controller: nomeController,
                decoration: InputDecoration(
                  labelText: 'Nome do Ingrediente',
                  labelStyle: const TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.black,
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10),
              // Campo de texto para inserir a descrição do ingrediente
              TextFormField(
                controller: descricaoController,
                decoration: InputDecoration(
                  labelText: 'Descrição do Ingrediente',
                  labelStyle: const TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.black,
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10),
              // Campo de texto para inserir o preço do ingrediente
              TextFormField(
                controller: precoController,
                decoration: InputDecoration(
                  labelText: 'Preço do Ingrediente',
                  labelStyle: const TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.black,
                ),
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10),
              // Campo de texto para inserir a quantidade do ingrediente
              TextFormField(
                controller: quantidadeController,
                decoration: InputDecoration(
                  labelText: 'Quantidade do Ingrediente',
                  labelStyle: const TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.black,
                ),
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              // Botão para cadastrar o ingrediente
              ElevatedButton(
                onPressed: () {
                  // Obtém os valores inseridos nos campos
                  String nome = nomeController.text;
                  String descricao = descricaoController.text;
                  String preco = precoController.text;
                  String quantidade = quantidadeController.text;

                  // Chama a função para adicionar o ingrediente
                  _adicionarIngrediente(nome, descricao, preco, quantidade);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                ),
                child: const Text('Cadastrar Ingrediente'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Função para adicionar um ingrediente ao Firestore
  void _adicionarIngrediente(
      String nome, String descricao, String preco, String quantidade) {
    _firestore.collection('Ingredientes').add({
      'nome': nome,
      'descricao': descricao,
      'preco': preco,
      'quantidade': quantidade,
    }).then((value) {
      // Exibe mensagem no console indicando que o ingrediente foi cadastrado
      print('Ingrediente cadastrado com ID: ${value.id}');
      // Limpa os campos após cadastrar
      nomeController.clear();
      descricaoController.clear();
      precoController.clear();
      quantidadeController.clear();
    }).catchError((error) {
      // Exibe mensagem de erro no console caso ocorra algum problema
      print('Erro ao cadastrar ingrediente: $error');
    });
  }
}
