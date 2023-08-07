import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/todo.dart';
import '../widgets/todo_item.dart'; 

class Home extends StatefulWidget {
  const Home ({ Key? key }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late SharedPreferences prefs;
  List<ToDo> todoList = [];
  final _todoController = TextEditingController();
  
  void  _loadToDoList() async {
    prefs = await SharedPreferences.getInstance();
    String? stringTodo = prefs.getString('todo');
    List? todos = jsonDecode(stringTodo!);
    for (var todo in todos!) {
      setState(() {
        todoList.add(ToDo().fromJson(todo));
      });
    }
  }

  void _saveToDo(){
    List items = todoList.map((ToDo e) => e.toJson()).toList();
    prefs.setString('todo',jsonEncode(items));
  }

  @override
  void initState() {
    super.initState();
    _loadToDoList();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-do List'),
      ),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 5,
            ),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      
                        Container(
                          margin: const EdgeInsets.only(
                            top: 50,
                            bottom: 20
                          ),
                          child: const Text(
                            'Todos',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w500,
                            )
                          )
                        ),
                        for (ToDo todo in todoList)
                          TodoItem(
                            todo: todo,
                            onDeleteItem: _handleDeleteTodo,
                            onToDoToggled: _handleToggleTodo,
                          ),
                        
                    ]
                  )
                ),
                Container(
                          margin: const EdgeInsets.only(
                            bottom: 60
                          ),
                        )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(children: [
              Expanded(child: Container(
                margin: const EdgeInsets.only(
                  bottom: 20, 
                  right: 20, 
                  left: 20
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(255, 255, 255, 1),
                    boxShadow:const [
                      BoxShadow(
                      color: Color.fromRGBO(204, 204, 204, 1),
                      offset: Offset(0.0, 0.0),
                      blurRadius: 10.0,
                      spreadRadius: 0.0,
                    ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: _todoController,
                    decoration: const InputDecoration(
                      hintText: 'Add a new todo',
                      border: InputBorder.none
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  bottom: 20, 
                  right:20,
                ),
                child: ElevatedButton(
                  child: const Text("+", style: TextStyle(fontSize: 40),),
                  onPressed: (){
                    _addToDoItem(_todoController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    primary:const Color.fromRGBO(0, 191, 255, 1),
                    minimumSize: const Size(60, 60),
                    elevation: 10,
                  ),
                ),
              )
            ]),
          ),
          
        ],
      ),
    );
  }
  
  void _handleToggleTodo(ToDo todo) {
    setState((){
      todo.isDone = !todo.isDone;
    });
    _saveToDo();
  }

  void _handleDeleteTodo(String id) {
    setState(() {
      todoList.removeWhere((element) => element.id == id);
    });
    _saveToDo();
  }

  void _addToDoItem(String text){
    setState(() {
      todoList.add(ToDo(
        id: DateTime.now().microsecondsSinceEpoch.toString(), 
        text: text,
      ));
    });
    _todoController.clear();
    _saveToDo();
  }
}


