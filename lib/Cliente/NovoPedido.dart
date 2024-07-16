import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:liquidop/Cliente/MenuCliente.dart';
import 'package:liquidop/Utils/gradientUtils.dart';
import 'package:liquidop/Cliente/Cardapio.dart';
import 'package:liquidop/Cliente/Receitas.dart';

class NovosPedidos extends StatefulWidget {
  const NovosPedidos({Key? key}) : super(key: key);

  @override
  State<NovosPedidos> createState() => _NovosPedidosState();
}

class _NovosPedidosState extends State<NovosPedidos> {
  TextEditingController nomeController = TextEditingController();
  String selectedBebida = '';
  late List<String> bebidasDisponiveis = [];
  late bool bebidasCarregadas = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _chatController = TextEditingController();
  final List<ChatMessage> _messages = [];
  int? selectedOption;

  @override
  void initState() {
    super.initState();
    _getBebidasDisponiveis();
    _startChat();
  }

  void _getBebidasDisponiveis() {
    _firestore.collection('Bebidas').get().then((QuerySnapshot querySnapshot) {
      List<String> bebidas = [];
      querySnapshot.docs.forEach((doc) {
        bebidas.add(doc['nome'] as String);
      });
      setState(() {
        bebidasDisponiveis = bebidas;
        bebidasCarregadas = true;
      });
    }).catchError((error) {
      print('Erro ao obter bebidas: $error');
    });
  }

  void _startChat() {
    _messages.add(
      ChatMessage(
        text: 'Olá! Como posso ajudar você hoje?',
        isBot: true,
      ),
    );
    _messages.add(
      ChatMessage(
        text: 'Escolha uma opção:\n1. Ver o cardápio\n2. Preparar uma bebida',
        isBot: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Novo Pedido',
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
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.09),
          decoration: BoxDecoration(
            gradient: gradientUtils.getLinearGradient(),
          ),
          child: ListView(
            // Envolver a seção em um ListView
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: _messages.map((message) {
                    return ChatBubble(
                      text: message.text,
                      isBot: message.isBot,
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 10),
              if (selectedOption == null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: Colors.white,
                    ),
                    color: Colors.black,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: selectedOption,
                      hint: const Text(
                        'Escolha uma opção',
                        style: TextStyle(color: Colors.white),
                      ),
                      onChanged: (int? newValue) {
                        setState(() {
                          selectedOption = newValue;
                        });
                      },
                      items: [1, 2].map((int option) {
                        return DropdownMenuItem<int>(
                          value: option,
                          child: Text(
                            option.toString(),
                            style: const TextStyle(
                              color: Color.fromARGB(255, 129, 105, 95),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Menu()));
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                ),
                child: const Text('Voltar para o Menu'),
              ),
              const SizedBox(height: 5),
              if (selectedOption != null)
                Column(
                  children: [
                    if (selectedOption == 1)
                      _buildCardapioWidget()
                    else if (selectedOption == 2)
                      _buildReceitasWidget(),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardapioWidget() {
    return Column(children: [
      const SizedBox(height: 20),
      const Text(
        'Cardápio de Bebidas:',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      const SizedBox(height: 10),
      if (!bebidasCarregadas)
        const CircularProgressIndicator()
      else
        Column(children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: Colors.white,
              ),
              color: Colors.black,
            ),
            child: Column(children: <Widget>[
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedBebida.isEmpty ? null : selectedBebida,
                  hint: const Text(
                    'Nossas bebida',
                    style: TextStyle(color: Colors.white),
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedBebida = newValue!;
                    });
                  },
                  items: bebidasDisponiveis.map((String bebida) {
                    return DropdownMenuItem<String>(
                      value: bebida,
                      child: Text(
                        bebida,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 129, 105, 95),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Cardapio()));
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
            ),
            child: const Text('Ir para Cardápio'),
          ),
          const SizedBox(height: 5),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Receitas()));
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
            ),
            child: const Text('Ir para Receitas'),
          )
        ])
    ]);
  }

  Widget _buildReceitasWidget() {
    // Substitua esta parte pelo widget que exibe as receitas
    return (Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SizedBox(height: 30),
        const Divider(
          color: Colors.white,
          height: 5.0,
          thickness: 5.0,
          indent: 0,
          endIndent: 0,
        ),
        const SizedBox(height: 20),
        if (!bebidasCarregadas)
          const CircularProgressIndicator()
        else
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                  color: Colors.white), // Adapte a cor conforme necessário
              color: Colors.black,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedBebida.isEmpty ? null : selectedBebida,
                hint: const Text(
                  'Escolher bebida',
                  style: TextStyle(color: Colors.white),
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedBebida = newValue!;
                  });
                },
                items: bebidasDisponiveis.map((String bebida) {
                  return DropdownMenuItem<String>(
                    value: bebida,
                    child: Text(
                      bebida,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 129, 105, 95)),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        const SizedBox(height: 10),
        TextFormField(
          controller: nomeController,
          decoration: InputDecoration(
            labelText: 'Nome do Cliente',
            labelStyle: const TextStyle(color: Colors.white),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            filled: true,
            fillColor: Colors.black,
          ),
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            String nome = nomeController.text;

            _adicionarPedido(selectedBebida, nome);
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
          ),
          child: const Text('Adicionar Pedido'),
        ),
      ],
    ));
  }

  void _adicionarPedido(String bebida, String nome) {
    if (bebida.isEmpty) {
      print('Selecione uma bebida antes de adicionar o pedido.');
      return;
    }

    _firestore
        .collection('Bebidas')
        .where('nome', isEqualTo: bebida)
        .get()
        .then(
      (QuerySnapshot querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          String preco = querySnapshot.docs.first['preco'] as String;
          _firestore.collection('Pedidos').add({
            'bebida': bebida,
            'nome': nome,
            'preco': preco,
            'statusDePreparo': 'Na Fila',
            'statusPagamento': 'pendente'
          }).then((value) {
            print('Pedido adicionado com ID: ${value.id}');
            nomeController.clear();
            setState(() {
              selectedBebida = '';
            });
          }).catchError((error) {
            print('Erro ao adicionar pedido: $error');
          });
        } else {
          print('Bebida não encontrada.');
        }
      },
    ).catchError((error) {
      print('Erro ao recuperar bebida: $error');
    });
  }

  void _processUserInput(String nome) {
    if (selectedOption == 1) {
      _messages.add(
        ChatMessage(
          text: 'Certo! Mostrando o cardápio...',
          isBot: true,
        ),
      );
      // Lógica para adicionar o pedido do cardápio
      _adicionarPedido(selectedBebida, nome);
    } else if (selectedOption == 2) {
      _messages.add(
        ChatMessage(
          text: 'Ótimo! Vamos preparar uma bebida...',
          isBot: true,
        ),
      );
      // Lógica para adicionar o pedido de receitas
      _adicionarPedidoReceita(
          /* Parâmetros necessários para adicionar o pedido de receitas */);
    } else if (selectedOption == 3) {
      _messages.add(
        ChatMessage(
          text: 'Operação cancelada.',
          isBot: true,
        ),
      );
      // Voltar para a tela principal
      Navigator.pop(context);
    } else {
      _messages.add(
        ChatMessage(
          text:
              'Desculpe, não entendi. Por favor, escolha entre "cardápio", "preparar bebida"',
          isBot: true,
        ),
      );
    }

    _chatController.clear();
    nomeController.clear();
    setState(() {
      selectedBebida = '';
      selectedOption = null;
    });
  }

  void _adicionarPedidoReceita() {
    // Implemente a lógica para adicionar o pedido de receitas
    // ...

    nomeController.clear();
    setState(() {
      selectedBebida = '';
      selectedOption = null;
    });
  }
}

class ChatMessage {
  final String text;
  final bool isBot;

  ChatMessage({
    required this.text,
    required this.isBot,
  });
}

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isBot;

  ChatBubble({
    required this.text,
    required this.isBot,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment:
            isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: isBot ? Colors.grey[300] : Colors.blue,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: isBot ? Colors.black : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
