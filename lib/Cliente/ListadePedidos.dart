import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:liquidop/Cliente/MenuCliente.dart';
import 'package:liquidop/Utils/gradientUtils.dart';

class ListaDePedidos extends StatefulWidget {
  const ListaDePedidos({Key? key}) : super(key: key);

  @override
  State<ListaDePedidos> createState() => _ListaDePedidosState();
}

class _ListaDePedidosState extends State<ListaDePedidos> {
  late List<QueryDocumentSnapshot<Map<String, dynamic>>> documents = [];
  int selectedItemIndex = -1;

  @override
  void initState() {
    super.initState();
    fetchPedidos();
  }

  Future<void> fetchPedidos() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('Pedidos').get();
    setState(() {
      documents = querySnapshot.docs;
    });
  }

  List<QueryDocumentSnapshot<Map<String, dynamic>>> getFilteredDocuments() {
    return documents.where((document) {
      final data = document.data();
      final statusPagamento = data['statusPagamento'] as String?;
      return statusPagamento != null && statusPagamento != 'pago';
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredDocuments = getFilteredDocuments();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Lista de Pedidos',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const Menu()));
          },
        ),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            gradient: gradientUtils.getLinearGradient(),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Pedidos em espera',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: List.generate(filteredDocuments.length, (index) {
                      final document = filteredDocuments[index];
                      final data = document.data();

                      final nome = data['nome'] as String?;
                      final bebida = data['bebida'] as String?;
                      final statusDePreparo =
                          data['statusDePreparo'] as String?;
                      final preco = data['preco'] as String?;
                      final status = data['status'] as String?;

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
                              color: Colors.grey,
                            ),
                            color: Colors.black, // Adicionando background preto
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (nome != null) ...[
                                SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    'Nome: $nome',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors
                                          .white, // Mudando a cor do texto para branco
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(height: 5),
                              ],
                              if (selectedItemIndex == index &&
                                  bebida != null) ...[
                                const Divider(
                                  color: Colors
                                      .white, // Mudando a cor da linha para branco
                                  height: 5.0,
                                  thickness: 5.0,
                                  indent: 0,
                                  endIndent: 0,
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'Bebida: $bebida',
                                  style: const TextStyle(
                                    color: Colors
                                        .white, // Mudando a cor do texto para branco
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                if (statusDePreparo != null) ...[
                                  const SizedBox(height: 10),
                                  Text(
                                    'Status de Preparo: $statusDePreparo',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors
                                          .white, // Mudando a cor do texto para branco
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                                const SizedBox(height: 10),
                              ],
                              if (selectedItemIndex == index &&
                                  preco != null) ...[
                                Text(
                                  'Preço: R\$ $preco',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors
                                        .white, // Mudando a cor do texto para branco
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                              if (selectedItemIndex == index &&
                                  status != null) ...[
                                Text(
                                  'Status: $status',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors
                                        .white, // Mudando a cor do texto para branco
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
