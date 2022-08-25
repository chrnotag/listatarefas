import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:async/async.dart';
import 'dart:convert';

void main() {
  runApp(
    MaterialApp(
      home: Home(),
    ),
  );
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _listaTarefas = [];
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas"),
        backgroundColor: Colors.purple,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Adicionar Tarefa"),
                  content: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: "Digite sua tarefa",
                    ),
                    onChanged: (text) {},
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        _salvarTarefa();
                        _controller.text = "";
                        Navigator.pop(context);
                      },
                      child: Text("Salvar"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Cancelar"),
                    ),
                  ],
                );
              });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (contex, index) {
                return Dismissible(
                  background: Container(
                    color: Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.delete_forever,
                            color: Colors.white,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Text(
                              "Deletar",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: Text(
                              "Deletar",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          Icon(
                            Icons.delete_forever,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  direction: DismissDirection.horizontal,
                  key: UniqueKey(),
                  child: Column(
                    children: [
                      CheckboxListTile(
                        value: _listaTarefas[index]["realizada"],
                        onChanged: (value) {
                          setState(() {
                            _listaTarefas[index]["realizada"] = value;
                          });
                          _salvarArquivo();
                        },
                        title: Text(_listaTarefas[index]["titulo"]),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 9.0, right: 9.0),
                        child: Divider(),
                      ),
                    ],
                  ),
                  onDismissed: (direction) {
                    if (direction == DismissDirection.startToEnd) {
                      setState(() {
                        _listaTarefas.removeAt(index);
                        _salvarArquivo();
                      });
                    }else{
                      setState(() {
                        _listaTarefas.removeAt(index);
                        _salvarArquivo();
                      });
                    }
                  },
                );
              },
              itemCount: _listaTarefas.length,
            ),
          ),
        ],
      ),
    );
  }

  _salvarTarefa() async {
    var texto = _controller.text;
    Map<String, dynamic> tarefa = Map();
    tarefa["titulo"] = texto;
    tarefa["realizada"] = false;
    setState(() {
      _listaTarefas.add(tarefa);
    });
    _salvarArquivo();
  }

  Future<File> _getFile() async {
    final diretorio = await getApplicationDocumentsDirectory();
    return File("${diretorio.path}/listaTarefas.json");
  }

  _returnArquivo() async {
    try {
      final arquivo = await _getFile();
      return arquivo.readAsString();
    } catch (e) {
      return null;
    }
  }

  _salvarArquivo() async {
    var arquivo = await _getFile();
    String dados = json.encode(_listaTarefas);
    arquivo.writeAsString(dados);
  }

  @override
  void initState() {
    super.initState();
    _returnArquivo().then((dados) {
      setState(() {
        _listaTarefas = json.decode(dados);
      });
    });
  }
}
