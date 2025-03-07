import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Importando o pacote necessário para SystemNavigator
import 'pets_screen.dart';  // Altere o caminho se necessário


class HomeRecepcionistaPage extends StatefulWidget {
  const HomeRecepcionistaPage({super.key});

  @override
  _HomeRecepcionistaPageState createState() => _HomeRecepcionistaPageState();
}

class _HomeRecepcionistaPageState extends State<HomeRecepcionistaPage> {
  // Controlador para o Drawer
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // Índice da página ativa
  int _selectedIndex = 0;
  // Variável para controlar o modo escuro
  bool _isDarkMode = false;

  // Função para mudar a página
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Função de logout
  void _logout() {
    Navigator.pushReplacementNamed(context, '/login'); // Navega para a tela de login
  }

  // Função para sair do app
  void _exitApp() {
    Navigator.of(context).pop(); // Fecha a tela atual
    SystemNavigator.pop(); // Fecha o aplicativo
  }

  // Função para alternar entre modo claro e escuro
  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  // Variáveis para o cadastro de coleta
  TextEditingController _dataController = TextEditingController();
  TextEditingController _horaController = TextEditingController();
  TextEditingController _observacaoController = TextEditingController();
  String? _motoboyResponsavel;
  String? _clinicaResponsavel;

  // Lista de coletas cadastradas (simulação para exibição)
  List<Map<String, String>> coletas = [];

  // Função para salvar o cadastro
  void _salvarCadastro() {
    if (_dataController.text.isNotEmpty && _horaController.text.isNotEmpty) {
      setState(() {
        coletas.add({
          'data': _dataController.text,
          'hora': _horaController.text,
          'motoboy': _motoboyResponsavel ?? 'Não definido',
          'clinica': _clinicaResponsavel ?? 'Não definida',
          'observacao': _observacaoController.text.isEmpty ? 'Sem observação' : 'Com observação',
        });
      });
      // Limpar os campos após salvar
      _dataController.clear();
      _horaController.clear();
      _observacaoController.clear();
      setState(() {
        _motoboyResponsavel = null;
        _clinicaResponsavel = null;
      });
      Navigator.pop(context); // Fecha o formulário
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      Column(
        children: [
          // Exibe as coletas cadastradas
          Expanded(
            child: ListView.builder(
              itemCount: coletas.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Clínica: ${coletas[index]['clinica']}'),
                  subtitle: Text('Motoboy: ${coletas[index]['motoboy']}\nData: ${coletas[index]['data']} - Hora: ${coletas[index]['hora']}'),
                  trailing: Icon(
                    coletas[index]['observacao'] == 'Com observação' ? Icons.check : Icons.close,
                    color: coletas[index]['observacao'] == 'Com observação' ? Colors.green : Colors.red,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      const Center(child: Text('Visualização do Mapa')),
    ];

    return Scaffold(
      key: _scaffoldKey,
     appBar: PreferredSize(
  preferredSize: Size.fromHeight(56.0), // Define a altura do AppBar
  child: Container(
    decoration: BoxDecoration(
      color: const Color(0xFFF6F6FF), // Cor de fundo
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2), // Cor da sombra
          offset: Offset(0, 2), // A sombra vai para baixo
          blurRadius: 6, // A difusão da sombra
        ),
      ],
    ),
    child: AppBar(
      backgroundColor: Colors.transparent, // Torna o fundo do AppBar transparente
      elevation: 0, // Remove a sombra padrão
      title: Padding(
        padding: const EdgeInsets.only(left: 20.0), // Ajuste a distância da esquerda
        child: Align(
          alignment: Alignment.centerLeft, // Alinha o título à esquerda
          child: Text(
            _selectedIndex == 0 ? 'Coletas Cadastradas' : 'Mapa de Pets',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold, // Deixando o texto em negrito
              color: Color(0xFF7A6BBC), // Cor do texto
            ),
          ),
        ),
      ),
      leading: IconButton(
        icon: Image.asset(
          'assets/icons/menu.png', // Novo ícone do menu
          width: 25, // Ajuste o tamanho conforme necessário
          height: 25,
        ),
        onPressed: () {
          _scaffoldKey.currentState?.openDrawer(); // Abre o Drawer
        },
      ),
    ),
  ),
),




      body: pages[_selectedIndex], // Exibe a página ativa

      // Menu Lateral (Drawer)
drawer: Drawer(
  child: Container(
    color: _isDarkMode ? const Color(0xFF1B1B1B) : Color(0xFF1B1B1B), // Fundo do menu lateral (alterado para #1b1b1b)
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        const UserAccountsDrawerHeader(
          accountName: Text('Recepcionista', style: TextStyle(color: Colors.white)),
          accountEmail: Text('user@empresa.com', style: TextStyle(color: Colors.white)),
          currentAccountPicture: CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: Color(0xFF46156D)), // Ícone do perfil em roxo
          ),
        ),
        ListTile(
          title: Text('Cadastrar Motoboy', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
          leading: Icon(Icons.motorcycle, color: _isDarkMode ? Colors.white : Colors.black), // Ícone de motoboy
          onTap: () {
            // Lógica para navegar para a tela de cadastro de motoboy
          },
        ),
        ListTile(
          title: Text('Cadastrar Pet', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
          leading: Icon(Icons.pets, color: _isDarkMode ? Colors.white : Colors.black), // Ícone de pet
          onTap: () {
            // Navegar para a tela de cadastro de pet
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PetsScreen()), // Certifique-se de usar a classe PetsScreen
            );
          },
        ),
        const Divider(),
        ListTile(
          title: Text('Modo Escuro', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
          leading: Icon(Icons.nights_stay, color: _isDarkMode ? Colors.white : Colors.black), // Ícone de modo escuro
          onTap: _toggleDarkMode, // Altera o modo de tema
        ),
        const Divider(),
        // Espaço para separar os itens
        const Spacer(),
        ListTile(
          title: Text('Fazer Logout', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
          leading: Icon(Icons.exit_to_app, color: _isDarkMode ? Colors.white : Colors.black), // Ícone de logout
          onTap: _logout, // Vai para a tela de login
        ),
        ListTile(
          title: Text('Sair', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
          leading: Icon(Icons.close, color: _isDarkMode ? Colors.white : Colors.black), // Ícone de fechar
          onTap: _exitApp, // Fecha o app
        ),
      ],
    ),
  ),
),


  // Menu Inferior com sombra para separação visual
bottomNavigationBar: Container(
  decoration: const BoxDecoration(
    color: Color(0xFFF6F6FF), // Cor da barra do menu inferior
    boxShadow: [
      BoxShadow(
        color: Colors.black26, // Cor da sombra
        blurRadius: 4, // Suavidade da sombra
        spreadRadius: 1, // Espalhamento da sombra
        offset: Offset(0, -2), // Posição da sombra (direção para cima)
      ),
    ],
  ),
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      // Linha que se move
      AnimatedContainer(
        duration: Duration(milliseconds: 300), // Duração da animação
        width: MediaQuery.of(context).size.width / 2, // Largura da linha (metade da tela)
        height: 4, // Espessura maior da linha
        color: const Color(0xFF7A6BBC), // Cor da linha
        margin: EdgeInsets.only(
          left: _selectedIndex == 0 ? 0 : MediaQuery.of(context).size.width / 2, // Posição da linha
          right: _selectedIndex == 1 ? 0 : MediaQuery.of(context).size.width / 2, // Posição da linha
        ),
        curve: Curves.easeInOut, // Efeito suave
      ),
      // BottomNavigationBar
      BottomNavigationBar(
        backgroundColor: const Color(0xFFF6F6FF), // Cor da barra do menu inferior
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/pacote.png', // Caminho do ícone do pacote
              width: 25, // Ajuste de tamanho do ícone
              height: 25,
              color: const Color(0xFF7A6BBC), // Cor do ícone
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/ponto.png', // Caminho do ícone do ponto
              width: 25,
              height: 25,
              color: const Color(0xFF7A6BBC),
            ),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF7A6BBC), // Cor do item selecionado
        onTap: _onItemTapped,
        iconSize: 30, // Tamanho dos ícones
        selectedFontSize: 0, // Remove qualquer espaço extra relacionado ao texto
        unselectedFontSize: 0, // Remove qualquer espaço extra relacionado ao texto
        elevation: 0, // Remove a sombra do menu inferior, se necessário
        type: BottomNavigationBarType.fixed, // Impede que o ícone se mova
      ),
    ],
  ),
),


      // Botão flutuante
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Exibe o formulário de cadastro de coleta
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Cadastro de Coleta'),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        controller: _dataController,
                        decoration: const InputDecoration(labelText: 'Data da Solicitação'),
                        keyboardType: TextInputType.datetime,
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              _dataController.text = "${pickedDate.toLocal()}".split(' ')[0];
                            });
                          }
                        },
                      ),
                      TextField(
                        controller: _horaController,
                        decoration: const InputDecoration(labelText: 'Horário da Solicitação'),
                        keyboardType: TextInputType.datetime,
                      ),
                      DropdownButton<String>(
                        value: _motoboyResponsavel,
                        hint: const Text('Motoboy Responsável'),
                        onChanged: (String? newValue) {
                          setState(() {
                            _motoboyResponsavel = newValue;
                          });
                        },
                        items: <String>['Motoboy 1', 'Motoboy 2', 'Motoboy 3']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      DropdownButton<String>(
                        value: _clinicaResponsavel,
                        hint: const Text('Clínica'),
                        onChanged: (String? newValue) {
                          setState(() {
                            _clinicaResponsavel = newValue;
                          });
                        },
                        items: <String>['Clínica 1', 'Clínica 2', 'Clínica 3']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      TextField(
                        controller: _observacaoController,
                        decoration: const InputDecoration(labelText: 'Observação da Recepção'),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      _salvarCadastro();
                    },
                    child: const Text('Salvar'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Fecha o formulário
                    },
                    child: const Text('Cancelar'),
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: const Color(0xFF7A6BBC), // Cor roxa
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
