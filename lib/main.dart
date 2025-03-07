import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Importa as configurações do Firebase
import 'login.dart'; // Importando o arquivo de login
import 'home_recepcionista.dart'; // Importando a página de home

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Garante a inicialização correta do Firebase
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
      title: 'App de Recepção',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/login', // Define a rota inicial como login
      routes: {
        '/login': (context) => const LoginPage(), // Página de login
        '/home': (context) => const HomeRecepcionistaPage(), // Página inicial após login
      },
    );
  }
}
