// Importa bibliotecas necessárias para o Flutter e Firebase
import 'package:flutter/material.dart';
import 'package:liquidop/Utils/gradientUtils.dart';
import 'package:liquidop/Cliente/MenuCliente.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Classe que representa a tela do Cardápio
class Cardapio extends StatefulWidget {
  // Construtor da classe
  const Cardapio({Key? key}) : super(key: key);

  // Método obrigatório para criar o estado associado à tela
  @override
  State<Cardapio> createState() => _CardapioState();
}

// Estado associado à tela do Cardápio
class _CardapioState extends State<Cardapio> {
  // Lista para armazenar os documentos do Firestore
  late List<QueryDocumentSnapshot<Map<String, dynamic>>> documents = [];
  // Termo de pesquisa para filtrar bebidas
  String searchTerm = '';
  // Índice do item selecionado na lista
  int selectedItemIndex = -1;

  // Função chamada ao inicializar o estado da tela
  @override
  void initState() {
    super.initState();
    // Carrega as bebidas do Firestore ao iniciar a tela
    fetchBebidas();
  }

  // Função para buscar as bebidas no Firestore
  Future<void> fetchBebidas() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('Bebidas').get();
      setState(() {
        documents = querySnapshot.docs;
      });
    } catch (error) {
      // Exibe mensagem de erro no console caso ocorra algum problema
      print('Erro ao carregar bebidas: $error');
    }
  }

  // Função para filtrar as bebidas com base no termo de pesquisa
  List<QueryDocumentSnapshot<Map<String, dynamic>>> searchResults() {
    return documents.where((document) {
      final data = document.data();
      final nome = data['nome'] as String?;
      final descricao = data['descricao'] as String?;
      // Verifica se o nome ou descrição contêm o termo de pesquisa
      return (nome != null &&
              nome.toLowerCase().contains(searchTerm.toLowerCase())) ||
          (descricao != null &&
              descricao.toLowerCase().contains(searchTerm.toLowerCase()));
    }).toList();
  }

  // Método para construir a interface gráfica da tela
  @override
  Widget build(BuildContext context) {
    // Configuração da barra superior da tela
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Cardápio',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navega de volta para a tela do menu do cliente
            Navigator.pop(context);
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
          // Coluna de widgets com pesquisa e lista de bebidas
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Campo de texto para pesquisar bebidas por nome ou descrição
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      // Atualiza o termo de pesquisa ao digitar
                      searchTerm = value;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Pesquisar Nome ou Descrição',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              // Lista expandida de bebidas usando ListView.builder
              Expanded(
                child: ListView.builder(
                  itemCount: searchTerm.isEmpty
                      ? documents.length
                      : searchResults().length,
                  itemBuilder: (context, index) {
                    // Obtém o documento atual
                    final document = searchTerm.isEmpty
                        ? documents[index]
                        : searchResults()[index];
                    // Obtém os dados do documento
                    final data = document.data();

                    // Extrai informações relevantes do documento
                    final nome = data['nome'] as String?;
                    final descricao = data['descricao'] as String?;
                    final preco = data['preco'] as String?;
                    final ingredienteId = data['ingredienteId'] as String?;

                    // Número da bebida (índice + 1)
                    final beverageNumber = index + 1;

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
                            color: Colors.white,
                          ),
                          color: Colors.black,
                        ),
                        // Coluna de informações da bebida
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Exibe o nome da bebida com número (se disponível)
                            if (nome != null) ...[
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  '$beverageNumber ─ $nome',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 5),
                            ],
                            // Exibe informações adicionais se o item estiver selecionado
                            if (selectedItemIndex == index &&
                                descricao != null) ...[
                              const Divider(
                                color: Colors.white,
                                height: 5.0,
                                thickness: 5.0,
                                indent: 0,
                                endIndent: 0,
                              ),
                              const SizedBox(height: 20),
                              // Exibe a descrição da bebida
                              Text(descricao,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.white)),
                              const SizedBox(height: 10),
                            ],
                            // Exibe o preço da bebida se disponível
                            if (selectedItemIndex == index &&
                                preco != null) ...[
                              Text(
                                'Preço: R\$ $preco',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ],
                            // Exibe o ingrediente relacionado à bebida se disponível
                            if (selectedItemIndex == index &&
                                ingredienteId != null) ...[
                              // FutureBuilder para carregar o ingrediente do Firestore
                              FutureBuilder<DocumentSnapshot>(
                                future: FirebaseFirestore.instance
                                    .collection('Ingredientes')
                                    .doc(ingredienteId)
                                    .get(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                                  // Verifica se houve erro no carregamento
                                  if (snapshot.hasError) {
                                    // Exibe mensagem de erro no console
                                    print(
                                        'Erro ao carregar ingrediente: ${snapshot.error}');
                                    // Exibe mensagem de erro na interface
                                    return Text('Erro ao carregar ingrediente',
                                        style:
                                            const TextStyle(color: Colors.red));
                                  }

                                  // Verifica se o carregamento foi concluído
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    // Extrai dados do ingrediente do snapshot
                                    final ingredienteData = snapshot.data!
                                        .data() as Map<String, dynamic>;
                                    final ingredienteNome =
                                        ingredienteData['nome'] as String?;
                                    // Exibe mensagem de sucesso no console
                                    print(
                                        'Ingrediente carregado com sucesso: $ingredienteNome');
                                    // Exibe o nome do ingrediente na interface
                                    return Text(
                                      'Ingrediente: $ingredienteNome',
                                      style:
                                          const TextStyle(color: Colors.white),
                                      textAlign: TextAlign.center,
                                    );
                                  }

                                  // Se ainda estiver carregando, exibe indicador de progresso
                                  return const CircularProgressIndicator();
                                },
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
}
