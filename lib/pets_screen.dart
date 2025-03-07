//PARTE 1

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PetsScreen extends StatefulWidget {
  @override
  _PetsScreenState createState() => _PetsScreenState();
}

class _PetsScreenState extends State<PetsScreen> {
  final CollectionReference petsCollection = FirebaseFirestore.instance.collection('pets');
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isSearchVisible = false;
  bool _isFilterVisible = false;
  TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  List<String> selectedPets = [];
  String selectedFrequencia = 'Todos';

  String formatDate(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }





//PARTE 2
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xFFF6F6FF),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF6F6FF),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: Offset(0, 2),
                blurRadius: 6,
              ),
            ],
          ),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: Image.asset('assets/icons/voltar.png', width: 24, height: 24),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0), // Ajuste o espaço do título
                  child: Text(
                    'Cadastro de Pets',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7A6BBC),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Image.asset('assets/icons/pesquisar.png', width: 24, height: 24),
                onPressed: () {
                  setState(() {
                    _isSearchVisible = !_isSearchVisible;
                  });
                },
              ),









//PARTE 3

             IconButton(
  icon: Image.asset('assets/icons/lixeira.png', width: 24, height: 24),
  onPressed: () {
    setState(() {
      // Ao clicar na lixeira, torna a seleção de pets visível
      _isSearchVisible = false;
    });

    // Exibe o dialog com as opções
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Excluir Pet'),
              // Check roxo
              IconButton(
                icon: Icon(Icons.check_circle, color: Colors.purple),
                onPressed: () {
                  if (selectedPets.isNotEmpty) {
                    // Mostra a confirmação de exclusão
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Tem certeza que deseja excluir?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                selectedPets.forEach((petId) {
                                  petsCollection.doc(petId).delete();
                                });
                                setState(() {
                                  selectedPets.clear();
                                });
                                Navigator.of(context).pop(); // Fecha a confirmação
                                Navigator.of(context).pop(); // Fecha a lixeira
                              },
                              child: Text('Sim'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Fecha a confirmação sem excluir
                              },
                              child: Text('Não'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
              // X roxo
              IconButton(
                icon: Icon(Icons.close, color: Colors.purple),
                onPressed: () {
                  setState(() {
                    selectedPets.clear(); // Limpa a seleção de pets
                  });
                  Navigator.of(context).pop(); // Fecha a lixeira
                },
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Selecione um pet para excluir'),
              SizedBox(height: 10),
              // Aqui, mostra o StreamBuilder para pegar os pets cadastrados
              StreamBuilder<QuerySnapshot>(
                stream: petsCollection.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text('Nenhum pet cadastrado.');
                  }

                  var pets = snapshot.data!.docs;

                  return Column(
                    children: pets.map<Widget>((pet) {
                      bool isChecked = selectedPets.contains(pet.id);
                      return ListTile(
                        title: Text(pet['nome']),
                        leading: Checkbox(
                          value: isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value!) {
                                selectedPets.add(pet.id); // Adiciona à seleção
                              } else {
                                selectedPets.remove(pet.id); // Remove da seleção
                              }
                            });
                          },
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  },
),







//PARTE 4
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          if (_isSearchVisible)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (query) {
                        setState(() {
                          searchQuery = query;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Pesquisar...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Image.asset('assets/icons/filtro.png', width: 24, height: 24),
                    onPressed: () {
                      setState(() {
                        _isFilterVisible = !_isFilterVisible;
                      });
                    },
                  ),
                ],
              ),
            ),
          if (_isFilterVisible)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: DropdownButton<String>(
                value: selectedFrequencia,
                items: ['Todos', 'Momentâneo', 'Contínuo']
                    .map((frequencia) => DropdownMenuItem<String>(
                          value: frequencia,
                          child: Text(frequencia),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedFrequencia = value!;
                  });
                },
                isExpanded: true,
                hint: Text('Filtrar por Frequência'),
                underline: SizedBox(),
              ),
            ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: petsCollection.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('Nenhum pet cadastrado.'));
                }

                var pets = snapshot.data!.docs
                    .where((pet) =>
                        pet['nome'].toString().toLowerCase().contains(searchQuery.toLowerCase()) &&
                        (selectedFrequencia == 'Todos' || pet['frequencia'] == selectedFrequencia))
                    .toList();

                return ListView.builder(
                  itemCount: pets.length,
                  itemBuilder: (context, index) {
                    var pet = pets[index];
                    bool isMomentaneo = pet['frequencia'] == 'Momentâneo';
                    bool isExpanded = false;

                    return StatefulBuilder(
                      builder: (context, setState) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              isExpanded = !isExpanded;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                                          child: Text(
                                            pet['nome'],
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                                          child: Text(
                                            'Horário: ${pet.data() != null && pet.data() is Map<String, dynamic> && (pet.data() as Map<String, dynamic>).containsKey('horario_funcionamento_sab') ? (pet.data() as Map<String, dynamic>)['horario_funcionamento_sab'] : 'Não informado'}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (isMomentaneo)
                                      Container(
                                        padding: EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Color(0xFFFF5454),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    // Adicionando a setinha para expandir o card
                                    Icon(
                                      isExpanded
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                      color: Color(0xFF7A6BBC), // cor roxa
                                    ),
                                  ],
                                ),
                                if (isExpanded)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16, top: 8.0),
                                    child: Text(
                                      pet['endereco'] != null 
                                        ? 'Endereço: ${pet['endereco']}' 
                                        : 'Endereço: Não informado',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}






//PARTE 5
class CadastroPetScreen extends StatefulWidget {
  @override
  _CadastroPetScreenState createState() => _CadastroPetScreenState();
}

class _CadastroPetScreenState extends State<CadastroPetScreen> {
  final _nomeController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _horarioSegController = TextEditingController();
  final _horarioSabController = TextEditingController();
  final _contatoController = TextEditingController();
  String _rota = 'Rota 1';
  String _frequencia = 'Contínua';

  void _submitForm() async {
    await FirebaseFirestore.instance.collection('pets').add({
      'nome': _nomeController.text,
      'endereco': _enderecoController.text,
      'horario_funcionamento_seg': _horarioSegController.text,
      'horario_funcionamento_sab': _horarioSabController.text,
      'data_cadastro': Timestamp.now(),
      'rota': _rota,
      'frequencia': _frequencia,
      'contato': _contatoController.text,
    });
    Navigator.pop(context);
  }




//PARTE 6
 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: PreferredSize(
      preferredSize: Size.fromHeight(56.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFF6F6FF),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: Offset(0, 2),
              blurRadius: 6,
            ),
          ],
        ),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Cadastrar Pet',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF7A6BBC),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
    body: Container(
      color: Color(0xFFF6F6FF),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField('Nome do Pet', _nomeController),
          _buildTextField('Endereço', _enderecoController),
          _buildTextField('Horário Seg. a Sext.', _horarioSegController),
          _buildTextField('Horário Sáb.', _horarioSabController),
          _buildTextField('Contato', _contatoController),
          Row(
            children: [
              Expanded(child: _buildDropdown('Rota', ['Rota 1', 'Rota 2'], _rota, (value) => setState(() => _rota = value))),
              SizedBox(width: 16),
              Expanded(child: _buildDropdown('Frequência', ['Contínua', 'Momentânea'], _frequencia, (value) => setState(() => _frequencia = value))),
            ],
          ),
          SizedBox(height: 20),
          Center(
            child: SizedBox(
              width: double.infinity, // Ocupa toda a largura disponível
              child: ElevatedButton(
                onPressed: () {
                  _submitForm();
                  Navigator.pop(context); // Volta para a tela anterior
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF7A6BBC),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.symmetric(vertical: 14), // Aumenta a altura
                ),
                child: Text(
                  'Salvar Cadastro',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}


//PARTE 7

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
              ],
            ),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }




//PARTE 8

  Widget _buildDropdown(String label, List<String> options, String selectedValue, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedValue,
              onChanged: (String? newValue) {
                if (newValue != null) onChanged(newValue);
              },
              items: options.map((value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              icon: Icon(Icons.keyboard_arrow_down, color: Color(0xFF7A6BBC)),
            ),
          ),
        ),
      ],
    );
  }
}
