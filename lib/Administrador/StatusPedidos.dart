// Importa bibliotecas necessárias para o Flutter e Firebase
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:liquidop/Administrador/MenuAdm.dart';
import 'package:liquidop/Utils/gradientUtils.dart';

// Classe que representa a tela de Status dos Pedidos
class StatusPedidos extends StatefulWidget {
  // Construtor da classe
  const StatusPedidos({Key? key}) : super(key: key);

  // Método obrigatório para criar o estado associado à tela
  @override
  State<StatusPedidos> createState() => _StatusPedidosState();
}

// Estado associado à tela de Status dos Pedidos
class _StatusPedidosState extends State<StatusPedidos> {
  // Lista para armazenar os documentos do Firestore
  late List<QueryDocumentSnapshot<Map<String, dynamic>>> documents = [];
  // Índice do item selecionado na lista
  int selectedItemIndex = -1;

  // Função chamada ao inicializar o estado da tela
  @override
  void initState() {
    super.initState();
    // Carrega os pedidos do Firestore ao iniciar a tela
    fetchPedidos();
  }

  // Função para buscar os pedidos no Firestore
  Future<void> fetchPedidos() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('Pedidos').get();
    setState(() {
      documents = querySnapshot.docs;
    });
  }

  // Função para atualizar o status de preparo no Firestore
  Future<void> updateStatusPreparo(String documentId, String novoStatus) async {
    try {
      // Atualiza o status de preparo no Firestore
      await FirebaseFirestore.instance
          .collection('Pedidos')
          .doc(documentId)
          .update({'statusDePreparo': novoStatus});
      // Atualiza a lista de pedidos após a alteração
      await fetchPedidos();
    } catch (e) {
      // Exibe mensagem de erro no console caso ocorra algum problema
      print('Erro ao atualizar status de preparo: $e');
    }
  }

  // Função para filtrar os documentos com status de pagamento não pago
  List<QueryDocumentSnapshot<Map<String, dynamic>>> getFilteredDocuments() {
    return documents.where((document) {
      final data = document.data();
      final statusPagamento = data['statusPagamento'] as String?;
      return statusPagamento != null && statusPagamento != 'pago';
    }).toList();
  }

  // Método para construir a interface gráfica da tela
  @override
  Widget build(BuildContext context) {
    // Obtém a lista de documentos filtrados
    final filteredDocuments = getFilteredDocuments();

    // Configuração da barra superior da tela
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
            // Navega de volta para a tela do menu do administrador
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const MenuAdm()));
          },
        ),
      ),
      // Configuração do conteúdo central da tela
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            gradient: gradientUtils.getLinearGradient(),
          ),
          // Lista expandida de pedidos usando SingleChildScrollView e Column
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
                  // Gera widgets para cada documento filtrado
                  child: Column(
                    children: List.generate(filteredDocuments.length, (index) {
                      // Obtém o documento atual
                      final document = filteredDocuments[index];
                      // Obtém os dados do documento
                      final data = document.data();

                      // Extrai informações relevantes do documento
                      final nome = data['nome'] as String?;
                      final bebida = data['bebida'] as String?;
                      final statusDePreparo =
                          data['statusDePreparo'] as String?;
                      final preco = data['preco'] as String?;
                      final status = data['status'] as String?;

                      // Constrói o item da lista como um GestureDetector
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            // Atualiza o índice do item selecionado
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
                            color: Colors.black,
                          ),
                          // Coluna de informações do pedido
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Exibe o nome do cliente se disponível
                              if (nome != null) ...[
                                SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    'Nome: $nome',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(height: 5),
                              ],
                              // Exibe informações adicionais se o item estiver selecionado
                              if (selectedItemIndex == index &&
                                  bebida != null) ...[
                                const Divider(
                                  color: Colors.white,
                                  height: 5.0,
                                  thickness: 5.0,
                                  indent: 0,
                                  endIndent: 0,
                                ),
                                const SizedBox(height: 20),
                                // Exibe a bebida do pedido
                                Text(
                                  'Bebida: $bebida',
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                // Exibe o status de preparo se disponível
                                if (statusDePreparo != null) ...[
                                  const SizedBox(height: 10),
                                  Text(
                                    'Status de Preparo: $statusDePreparo',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                                const SizedBox(height: 10),
                                // Linha com botões para alterar o status de preparo
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        // Atualiza o status de preparo para Em preparo
                                        updateStatusPreparo(
                                            document.id, 'Em preparo');
                                      },
                                      child: const Text(
                                        'Em preparo',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        // Atualiza o status de preparo para Concluído
                                        updateStatusPreparo(
                                            document.id, 'Concluído');
                                      },
                                      child: const Text(
                                        'Concluído',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                              // Exibe o status do pedido se disponível
                              if (selectedItemIndex == index &&
                                  status != null) ...[
                                Text(
                                  'Status: $status',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
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
