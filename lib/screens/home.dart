// ignore_for_file: unused_field, no_leading_underscores_for_local_identifiers

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
  List<ToDo> todoFilters = [];
  final List<String> category = <String>['All', 'Done', 'Do'];
  String dropdownValue = 'All';
  final _todoController = TextEditingController();

  void _handleFilter(String value) {
    setState(() {
      if (value == 'Done'){
        todoFilters = todoList.where((e) => e.isDone).toList();
      } else if (value == 'Do'){
        todoFilters = todoList.where((e) => !e.isDone).toList();
      } else {
        todoFilters = todoList;
      }
    });  
  }
  
  void  _loadToDoList() async {
    prefs = await SharedPreferences.getInstance();
    String? stringTodo = prefs.getString('todo');
    List? todos = jsonDecode(stringTodo!);
    for (var todo in todos!) {
      setState(() {
        todoList.add(ToDo().fromJson(todo));
      });
    }
    _handleFilter(dropdownValue);
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
                                top: 20,
                                bottom: 10
                              ),
                              child:
                                  const Text(
                                    'Todos',
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w500,
                                    )
                                  ),
                          ),
                        Container(
                              margin: const EdgeInsets.only(
                                // top: 10,
                                bottom: 10,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 5,
                              ),
                              child:
                                  DropdownButton<String>(
                                    value: dropdownValue,
                                    elevation: 16,
                                    style: const TextStyle(color: Colors.deepPurple),
                                    onChanged: (String? value) {
                                      dropdownValue = value!;
                                      _handleFilter(dropdownValue);
                                    },
                                    items: category.map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                          ),
                        for (ToDo todo in todoFilters)
                          TodoItem(
                            todo: todo,
                            onDeleteItem: _handleDeleteTodo,
                            onToDoToggled: _handleToggleTodo,
                            onEditItem: _handleEditTodo,
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
                  onPressed: (){
                    _addToDoItem(_todoController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(0, 191, 255, 1),
                    minimumSize: const Size(60, 60),
                    elevation: 10,
                  ),
                  child: const Text("+", style: TextStyle(fontSize: 40),),
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
    _handleFilter(dropdownValue);
    _saveToDo();
  }

  void _handleDeleteTodo(String id) {
    setState(() {
      todoList.removeWhere((element) => element.id == id);
    });
    _handleFilter(dropdownValue);
    _saveToDo();
  }

  void _handleEditTodo(String id, String text) {
    List<ToDo> todoo = [];
    setState(() {
      for (ToDo todo in todoList) {
        if (todo.id == id) {
          todo.text = text;
        }
        todoo.add(todo);
      }
      todoList = todoo;
      });
    _saveToDo();
  }

  void _addToDoItem(String text){
    setState(() {
      if (text.isNotEmpty){
        todoList.add(ToDo(
          id: DateTime.now().microsecondsSinceEpoch.toString(), 
          text: text,
        ));
      }
    });
    _todoController.clear();
    _handleFilter(dropdownValue);
    _saveToDo();
  }
}


