import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:liquidop/Administrador/MenuAdm.dart';
import 'package:liquidop/Utils/gradientUtils.dart';

class CadastroDeReceitas extends StatefulWidget {
  const CadastroDeReceitas({Key? key}) : super(key: key);

  @override
  State<CadastroDeReceitas> createState() => _CadastroDeReceitasState();
}

class _CadastroDeReceitasState extends State<CadastroDeReceitas> {
  TextEditingController bebidaController = TextEditingController();
  TextEditingController modoPreparoController = TextEditingController();
  TextEditingController rendimentoController = TextEditingController();
  TextEditingController tempoPreparoController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late List<DocumentSnapshot> ingredientes = [];
  List<String> selectedIngredientes = [];

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
          'Cadastro de Receitas',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MenuAdm(),
              ),
            );
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
              DropdownButton<String>(
                value: selectedIngredientes.isNotEmpty
                    ? selectedIngredientes.last
                    : null,
                items: ingredientes.map((DocumentSnapshot document) {
                  return DropdownMenuItem<String>(
                    value: document.id,
                    child: Text(
                      document['nome'] ?? '',
                      style: const TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
                onChanged: (String? value) {
                  if (value != null) {
                    setState(() {
                      selectedIngredientes.add(value);
                    });
                  }
                },
                hint: const Text(
                  'Selecione um Ingrediente',
                  style: TextStyle(color: Colors.white),
                ),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 10),
              Wrap(
                children: selectedIngredientes
                    .map(
                      (ingredienteId) => Chip(
                        label: FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('Ingredientes')
                              .doc(ingredienteId)
                              .get(),
                          builder: (BuildContext context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.hasData) {
                              final ingredienteData =
                                  snapshot.data!.data() as Map<String, dynamic>;
                              final ingredienteNome =
                                  ingredienteData['nome'] as String?;
                              return Text(ingredienteNome ?? '',
                                  style: const TextStyle(color: Colors.white));
                            } else {
                              return Container();
                            }
                          },
                        ),
                        onDeleted: () {
                          setState(() {
                            selectedIngredientes.remove(ingredienteId);
                          });
                        },
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: bebidaController,
                decoration: InputDecoration(
                  labelText: 'Bebida da Receita',
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
                controller: modoPreparoController,
                decoration: InputDecoration(
                  labelText: 'Modo de Preparo',
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
                controller: rendimentoController,
                decoration: InputDecoration(
                  labelText: 'Quantidade de Rendimento',
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
              TextFormField(
                controller: tempoPreparoController,
                decoration: InputDecoration(
                  labelText: 'Tempo de Preparo',
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
              ElevatedButton(
                onPressed: () {
                  String bebida = bebidaController.text;
                  String modoPreparo = modoPreparoController.text;
                  String rendimento = rendimentoController.text;
                  String tempoPreparo = tempoPreparoController.text;

                  _adicionarReceita(
                    bebida,
                    modoPreparo,
                    rendimento,
                    tempoPreparo,
                    selectedIngredientes,
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                ),
                child: const Text('Cadastrar Receita'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _adicionarReceita(
    String bebida,
    String modoPreparo,
    String rendimento,
    String tempoPreparo,
    List<String> ingredientesIds,
  ) {
    _firestore.collection('Receitas').add({
      'bebida': bebida,
      'modoPreparo': modoPreparo,
      'rendimento': rendimento,
      'tempoPreparo': tempoPreparo,
      'ingredientesIds': ingredientesIds,
    }).then((value) {
      print('Receita cadastrada com ID: ${value.id}');
      // Limpa os campos após cadastrar
      bebidaController.clear();
      modoPreparoController.clear();
      rendimentoController.clear();
      tempoPreparoController.clear();
      setState(() {
        selectedIngredientes = [];
      });
    }).catchError((error) {
      print('Erro ao cadastrar receita: $error');
    });
  }
}
