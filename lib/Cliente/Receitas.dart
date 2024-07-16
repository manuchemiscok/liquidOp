import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:liquidop/Utils/gradientUtils.dart';

class Receitas extends StatefulWidget {
  const Receitas({Key? key}) : super(key: key);

  @override
  State<Receitas> createState() => _ReceitasState();
}

class _ReceitasState extends State<Receitas> {
  late List<QueryDocumentSnapshot<Map<String, dynamic>>> documents = [];
  String searchTerm = '';
  int selectedItemIndex = -1;

  @override
  void initState() {
    super.initState();
    fetchReceitas();
  }

  Future<void> fetchReceitas() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('Receitas').get();
      setState(() {
        documents = querySnapshot.docs;
      });
    } catch (error) {
      print('Erro ao carregar receitas: $error');
    }
  }

  List<QueryDocumentSnapshot<Map<String, dynamic>>> searchResults() {
    return documents.where((document) {
      final data = document.data();
      final bebida = data['bebida'] as String?;
      final modoPreparo = data['modoPreparo'] as String?;
      return (bebida != null &&
              bebida.toLowerCase().contains(searchTerm.toLowerCase())) ||
          (modoPreparo != null &&
              modoPreparo.toLowerCase().contains(searchTerm.toLowerCase()));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Receitas',
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchTerm = value;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Pesquisar Nome ou Modo de Preparo',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: searchTerm.isEmpty
                      ? documents.length
                      : searchResults().length,
                  itemBuilder: (context, index) {
                    final document = searchTerm.isEmpty
                        ? documents[index]
                        : searchResults()[index];
                    final data = document.data();

                    final bebida = data['bebida'] as String?;
                    final modoPreparo = data['modoPreparo'] as String?;
                    final rendimento = data['rendimento'] as String?;
                    final tempoPreparo = data['tempoPreparo'] as String?;
                    final ingredientesIDs =
                        data['ingredientesIds'] as List<dynamic>?;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedItemIndex =
                              selectedItemIndex == index ? -1 : index;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.white,
                          ),
                          color: Colors.black,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (bebida != null) ...[
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  '$bebida',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 5),
                            ],
                            const SizedBox(height: 20),
                            if (selectedItemIndex == index &&
                                modoPreparo != null) ...[
                              const Divider(
                                color: Colors.white,
                                height: 5.0,
                                thickness: 5.0,
                                indent: 0,
                                endIndent: 0,
                              ),
                              const SizedBox(height: 20),
                              if (selectedItemIndex == index &&
                                  ingredientesIDs != null) ...[
                                const SizedBox(height: 20),
                                const Text(
                                  'Ingredientes:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                const SizedBox(height: 10),
                                // Consulta Firebase para obter os detalhes dos ingredientes
                                Column(
                                  children: ingredientesIDs
                                      .map<FutureBuilder<DocumentSnapshot>>(
                                        (ingredienteId) =>
                                            FutureBuilder<DocumentSnapshot>(
                                          future: FirebaseFirestore.instance
                                              .collection('Ingredientes')
                                              .doc(ingredienteId)
                                              .get(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<DocumentSnapshot>
                                                  snapshot) {
                                            if (snapshot.hasError) {
                                              return const Text(
                                                'Erro ao carregar ingrediente',
                                                style: TextStyle(
                                                    color: Colors.red),
                                              );
                                            }
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const CircularProgressIndicator();
                                            }
                                            if (snapshot.hasData &&
                                                snapshot.data != null) {
                                              final ingrediente =
                                                  snapshot.data!;
                                              final nome = ingrediente['nome']
                                                  as String?;
                                              // Exibindo o nome do ingrediente recuperado
                                              return Text(
                                                nome ??
                                                    'Nome do ingrediente não encontrado',
                                                style: const TextStyle(
                                                    color: Colors.white),
                                                textAlign: TextAlign.center,
                                              );
                                            } else {
                                              return const Text(
                                                'Ingrediente não encontrado',
                                                style: TextStyle(
                                                    color: Colors.white),
                                                textAlign: TextAlign.center,
                                              );
                                            }
                                          },
                                        ),
                                      )
                                      .toList(),
                                ),
                              ],
                              const SizedBox(height: 20),
                              Text(
                                "Modo de preparo: " + modoPreparo,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 20),
                            ],
                            if (selectedItemIndex == index &&
                                rendimento != null) ...[
                              Text(
                                'Rendimento: $rendimento',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ],
                            const SizedBox(height: 20),
                            if (selectedItemIndex == index &&
                                tempoPreparo != null) ...[
                              Text(
                                'Tempo de Preparo: $tempoPreparo',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
