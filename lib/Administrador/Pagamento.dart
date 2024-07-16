// Importa bibliotecas necessárias para o Flutter e Firebase
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:liquidop/Administrador/MenuAdm.dart';
import 'package:liquidop/Utils/gradientUtils.dart';

// Classe que representa a tela de Pagamentos
class Pagamento extends StatefulWidget {
  // Construtor da classe
  const Pagamento({Key? key}) : super(key: key);

  // Método obrigatório para criar o estado associado à tela
  @override
  State<Pagamento> createState() => _PagamentoState();
}

// Estado associado à tela de Pagamentos
class _PagamentoState extends State<Pagamento> {
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

  // Método para construir a interface gráfica da tela
  @override
  Widget build(BuildContext context) {
    // Configuração da barra superior da tela
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Pagamentos',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navega de volta para a tela do menu do administrador
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MenuAdm(),
              ),
            );
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
          // Lista de widgets que compõem o conteúdo da tela
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Pedidos a Pagar',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Lista expandida de pedidos usando ListView.builder
              Expanded(
                child: ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    // Obtém o documento atual
                    final document = documents[index];
                    // Obtém os dados do documento
                    final data = document.data();

                    // Extrai informações relevantes do documento
                    final nome = data['nome'] as String?;
                    final bebida = data['bebida'] as String?;
                    final statusDePreparo = data['statusDePreparo'] as String?;
                    final preco = data['preco'] as String?;
                    final status = data['status'] as String?;
                    final statusPagamento = data['statusPagamento'] as String?;
                    final valor = data['valor'] as String?;

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
                          color: Colors.black, // Adicionando background preto
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
                                    color: Colors
                                        .white, // Mudando a cor do texto para branco
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
                                color: Colors
                                    .white, // Mudando a cor da linha para branco
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
                                  color: Colors
                                      .white, // Mudando a cor do texto para branco
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
                                    color: Color.fromARGB(255, 255, 121,
                                        121), // Mudando a cor do texto para branco
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                              const SizedBox(height: 10),
                            ],
                            // Exibe o preço do pedido se disponível
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
                            // Exibe o status do pedido se disponível
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
                            // Exibe o valor do pedido se disponível
                            if (selectedItemIndex == index &&
                                valor != null) ...[
                              Text(
                                'Valor: $valor',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                            const SizedBox(height: 10),
                            // Exibe o status de pagamento e botões de ação se disponíveis
                            if (selectedItemIndex == index &&
                                statusPagamento != null) ...[
                              Text(
                                'Status Pagamento: $statusPagamento',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              // Linha com botões para alterar o status de pagamento
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      // Atualiza o status de pagamento para Pendente
                                      updateStatusPagamento(
                                          document.id, 'Pendente');
                                    },
                                    child: const Text('Pendente'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Atualiza o status de pagamento para Pago
                                      updateStatusPagamento(
                                          document.id, 'Pago');
                                    },
                                    child: const Text('Pago'),
                                  ),
                                ],
                              ),
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

  // Função para atualizar o status de pagamento no Firestore
  void updateStatusPagamento(String documentId, String novoStatus) async {
    try {
      // Atualiza o status de pagamento no Firestore
      await FirebaseFirestore.instance
          .collection('Pedidos')
          .doc(documentId)
          .update({'statusPagamento': novoStatus});

      // Atualiza a lista de pedidos após a alteração
      setState(() {
        fetchPedidos();
      });
    } catch (e) {
      // Exibe mensagem de erro no console caso ocorra algum problema
      print('Erro ao atualizar o status de pagamento: $e');
    }
  }
}
