import 'dart:convert';
import 'package:flutter/material.dart'; //usado para Andriod
import 'package:shared_preferences/shared_preferences.dart'; //usado para persistir dados
import 'package:flutter/widgets.dart';
import 'models/item.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // A aplicação sempre retorna um MaterialApp
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  var items = new List<Item>(); //lista de itens

  HomePage() {
    //metodo construtor
    items = [];
    // items.add(Item(title: "Banana", done: false));
    // items.add(Item(title: "Laranja", done: true));
    // items.add(Item(title: "Uva", done: false));
  }
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var newTaskCtrl =
      TextEditingController(); //controla meu texto, define a váriavel primeiro

  void add() {
    if (newTaskCtrl.text.isEmpty) return;
    setState(() {
      widget.items.add(
        Item(
          title: newTaskCtrl.text,
          done: false,
        ),
      );
      newTaskCtrl.text = "";
      save();
    });
  }

  void remove(int index) {
    setState(() {
      widget.items.removeAt(index);
      save();
    });
  }

  Future load() async {
    //funções assíncronas, tem essa "async" atrelado a ela.
    var prefs = await SharedPreferences
        .getInstance(); //Não procegue se o SharedPreferences não estiver carregado
    var data = prefs.getString('data');

    if (data != null) {
      //aqui estão convertendo uma String em um Json
      Iterable decoded = jsonDecode(//decode usado para decodificar
          data); //Iterable significa que temos uma coluna com interação
      List<Item> result = decoded
          .map((x) => Item.fromJson(x))
          .toList(); //map percore todos os itens. Mapeamento
      setState(() {
        //atualiza o estado da página
        widget.items = result;
      });
    }
  }

  save() async {
    var prefs =
        await SharedPreferences.getInstance(); //pegando a instacia do prefs
    await prefs.setString('data', jsonEncode(widget.items));
  }

  _HomePageState() {
    load();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //representa uma página por completo (página sempre e usado Scaffold)
      appBar: AppBar(
        //Scaffold trabalha com body / Container trabalha com child
        title: TextFormField(
          controller: newTaskCtrl, //ativa a variavel dentro do TextFormField
          keyboardType: TextInputType.text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
          decoration: InputDecoration(
            //coloca um titulo em um Textfield
            labelText: "Nova tarefa",
            labelStyle: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: ListView.builder(
        //exibe os itens da lista setada acima, exibe a lista sob demanda
        itemCount: widget.items.length, //quantidade de itens que a lista tem
        itemBuilder: (BuildContext context, int index) {
          final item = widget.items[index];
          return Dismissible(
              child: CheckboxListTile(
                title: Text(item.title),
                value: item.done,
                onChanged: (value) {
                  setState(() {
                    item.done = value;
                    save();
                  });
                },
              ),
              key: Key(item.title),
              background: Container(
                child: Icon(Icons.restore_from_trash),
                color: Colors.red.withOpacity(0.4),
              ),
              onDismissed: (direction) {
                remove(index);
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: add,
        child: Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
    );
  }
}
