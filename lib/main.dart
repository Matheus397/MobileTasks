import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/item.dart';
// import 'package:flutter/cupertino.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override 
  var items = new List<Item>();
 HomePage() {
   items = [];
  //  items.add(Item(title: "Melancia", done: false));
  //  items.add(Item(title: "Morango", done: false));
  //  items.add(Item(title: "Maracujá", done: false));
  }

 @override
 _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  var newTaskCtrl = TextEditingController();

  void add(){
    setState(() {
      widget.items.add(Item(title: newTaskCtrl.text, done: false));
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
  var prefs = await SharedPreferences.getInstance();
  var data = prefs.getString('data');

  if (data != null) {
    Iterable decoded = jsonDecode(data);
    List<Item> result = decoded.map((x) => Item.fromJson(x)).toList();
    setState(() {
      widget.items = result;
    });
  }
}

save() async {
  var prefs = await SharedPreferences.getInstance();
  await prefs .setString('data', jsonEncode(widget.items));
}

_HomePageState() {
  load();
}


  @override 
  Widget build(BuildContext context) {
    //newTaskCtrl.clear();
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: newTaskCtrl,
          keyboardType: TextInputType.text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
          decoration: InputDecoration(
            labelText: "Nova Tarefa",
            labelStyle: TextStyle(color: Colors.white),
          ),
        ),
    ),
    body: ListView.builder(

      itemCount: widget.items.length,
    itemBuilder: (BuildContext ctxt, int index){
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
         color: Colors.red.withOpacity(0.5),
         child: Text("Removendo")
       ),
       onDismissed: (direction) {
         print(direction);
       },
      );
    },
    ),
    floatingActionButton: FloatingActionButton(onPressed: add,
    child: Icon(Icons.add),
    backgroundColor: Colors.purple,
    ),
    );
  }
}

    