import 'package:flutter/material.dart';
import 'package:liquidop/Utils/gradientUtils.dart';
import 'package:liquidop/Cliente/MenuCliente.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:liquidop/Config/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Liquid Operator',
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Liquid Operator',
          selectionColor: Colors.white,
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.10),
          decoration: BoxDecoration(
            gradient: gradientUtils.getLinearGradient(),
          ),

          child: Column(
            children: [
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(20), // Define o borderRadius
                ),
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(20), // Também aplicado ao conteúdo
                  child: Image.asset('assets/images/logo.jpg'),
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              Container(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => (const Menu())),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                        255, 85, 65, 58), // Define a cor do botão aqui
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    minimumSize:
                        Size(150, 50), // Define o tamanho mínimo do botão
                  ),
                  child: const Text(
                    'ENTRAR',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
          //width: double.infinity, // Preenche a largura da tela
          //height: double.infinity, // Preenche a altura da tela
        ),
      ),
    );
  }
}
