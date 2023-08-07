import 'package:flutter/material.dart';

import '../model/todo.dart';

class TodoItem extends StatelessWidget {
  final ToDo todo;
  final onToDoToggled;
  final onDeleteItem;
  
  const TodoItem({ 
    Key? key, 
    required this.todo, 
    required this.onToDoToggled, 
    required this.onDeleteItem
    }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: ListTile(
        onTap: () {
          onToDoToggled(todo);
        },
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        leading: Icon(todo.isDone ? Icons.check_box : Icons.check_box_outline_blank, color: Color.fromRGBO(0, 191, 255, 1),),
        title: Text(
          todo.text!,
          style: TextStyle(
            decoration: todo.isDone ? TextDecoration.lineThrough : null,
          ),
          ),
        trailing: Container(
          padding: EdgeInsets.all(0),
          height: 35,
          width: 35,
          decoration: BoxDecoration(
            color: Color.fromRGBO(255, 0, 0, 1),
            borderRadius: BorderRadius.circular(5),
          ),
          child: IconButton(
            color: Color.fromRGBO(255, 255, 255, 1),
            iconSize: 18,
            icon: Icon(Icons.delete),
            onPressed: () {
              onDeleteItem(todo.id);
            },
          ),
        ),
      )
    );
  }
}