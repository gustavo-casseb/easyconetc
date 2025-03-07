import 'package:flutter/material.dart';
import 'home_recepcionista.dart';  // Importa a tela inicial do recepcionista

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  void _login() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Verificação do usuário e senha
    if (username == 'admin' && password == '1234') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login bem-sucedido!')),
      );
      // Navega para a tela inicial do recepcionista
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeRecepcionistaPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário ou senha inválidos.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor:Color(0xFF46156D),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock, size: 80, color: Colors.white),
              const SizedBox(height: 20),

              // CAMPO USUÁRIO
              Container(
                width: screenWidth * 0.8, // 80% da largura da tela
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _usernameController,
                  style: const TextStyle(color:Color(0xFF46156D)),
                  decoration: const InputDecoration(
                    labelText: 'Usuário',
                    labelStyle: TextStyle(color:Color(0xFF46156D)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // CAMPO SENHA
              Container(
                width: screenWidth * 0.8, // 80% da largura da tela
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _passwordController,
                  obscureText: _obscureText,
                  style: const TextStyle(color:Color(0xFF46156D)),
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    labelStyle: const TextStyle(color:Color(0xFF46156D)),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color:Color(0xFF46156D),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30), // Espaçamento entre os campos e o botão

              // BOTÃO DE CLICAR
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Color(0xFF46156D),
                  minimumSize: Size(screenWidth * 0.4, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  shadowColor: Colors.black.withOpacity(0.2),
                  elevation: 5,
                ),
                child: const Text(
                  'Entrar',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
