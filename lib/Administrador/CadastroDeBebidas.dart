import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:liquidop/Administrador/MenuAdm.dart';
import 'package:liquidop/Utils/gradientUtils.dart';

class CadastroDeBebidas extends StatefulWidget {
  const CadastroDeBebidas({Key? key}) : super(key: key);

  @override
  State<CadastroDeBebidas> createState() => _CadastroDeBebidasState();
}

class _CadastroDeBebidasState extends State<CadastroDeBebidas> {
  TextEditingController nomeController = TextEditingController();
  TextEditingController descricaoController = TextEditingController();
  TextEditingController precoController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late List<QueryDocumentSnapshot> ingredientes = [];
  List<QueryDocumentSnapshot> selectedIngredientes = [];

  @override
  void initState() {
    super.initState();
    _carregarIngredientes();
  }

  Future<void> _carregarIngredientes() async {
    final querySnapshotIngredientes =
        await FirebaseFirestore.instance.collection('Ingredientes').get();

    setState(() {
      ingredientes = querySnapshotIngredientes.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Cadastro de Bebidas',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const MenuAdm()));
          },
        ),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
          decoration: BoxDecoration(
            gradient: gradientUtils.getLinearGradient(),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              TextFormField(
                controller: nomeController,
                decoration: InputDecoration(
                  labelText: 'Nome da Bebida',
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
              TextFormField(
                controller: descricaoController,
                decoration: InputDecoration(
                  labelText: 'Descrição de Bebida',
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
              TextFormField(
                controller: precoController,
                decoration: InputDecoration(
                  labelText: 'Preço da Bebida',
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
              DropdownButton<QueryDocumentSnapshot>(
                value: null,
                items: ingredientes.map((QueryDocumentSnapshot document) {
                  return DropdownMenuItem<QueryDocumentSnapshot>(
                    value: document,
                    child: Text(
                      document['nome'] ?? '',
                      style: const TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
                onChanged: (QueryDocumentSnapshot? value) {
                  setState(() {
                    if (value != null) {
                      selectedIngredientes.add(value);
                    }
                  });
                },
                hint: const Text(
                  'Selecione um Ingrediente',
                  style: TextStyle(color: Colors.white),
                ),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: selectedIngredientes
                    .map((QueryDocumentSnapshot ingrediente) {
                  return Chip(
                    label: Text(ingrediente['nome'] ?? ''),
                    onDeleted: () {
                      setState(() {
                        selectedIngredientes.remove(ingrediente);
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  String nome = nomeController.text;
                  String descricao = descricaoController.text;
                  String preco = precoController.text;

                  _adicionarBebida(
                      nome, descricao, preco, selectedIngredientes);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                ),
                child: const Text('Cadastrar Bebida'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _adicionarBebida(String nome, String descricao, String preco,
      List<QueryDocumentSnapshot> ingredientes) {
    List<String> ingredientesIds =
        ingredientes.map((ingrediente) => ingrediente.id).toList();

    _firestore.collection('Bebidas').add({
      'nome': nome,
      'descricao': descricao,
      'preco': preco,
      'ingredientesIds': ingredientesIds,
    }).then((value) {
      print('Bebida cadastrada com ID: ${value.id}');
      // Limpa os campos após cadastrar
      nomeController.clear();
      descricaoController.clear();
      precoController.clear();
      setState(() {
        selectedIngredientes.clear();
      });
    }).catchError((error) {
      print('Erro ao cadastrar bebida: $error');
    });
  }
}
