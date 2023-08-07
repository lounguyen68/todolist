import 'package:flutter/material.dart';

import '../model/todo.dart';

class TodoItem extends StatelessWidget {
  final ToDo todo;
  final onToDoToggled;
  final onDeleteItem;
  final onEditItem;
  
  const TodoItem({ 
    Key? key, 
    required this.todo, 
    required this.onToDoToggled, 
    required this.onDeleteItem,
    required this.onEditItem
    }) : super(key: key);
    
  

  @override
  Widget build(BuildContext context){
    String text = "";
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: ListTile(
        onTap: () {
          onToDoToggled(todo);
        },
        onLongPress: (){
          showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Wrap(
                        // alignment: Alignment.bottomCenter,
                        children: [
                          Row(children: [
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
                              child: TextFormField(
                                initialValue: todo.text!,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                                autofocus: true,
                                onChanged: (value) => {
                                  text = value }
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 20,
                              ),
                            margin: const EdgeInsets.only(
                              bottom: 20, 
                              right:20,
                            ),
                            child: ElevatedButton(
                              child: const Text("OK", style: TextStyle(fontSize: 24),),
                              onPressed: (){
                                if (text.isNotEmpty){
                                  onEditItem(todo.id, text);
                                  Navigator.pop(context);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                primary:const Color.fromRGBO(0, 191, 255, 1),
                                minimumSize: const Size(60, 60),
                                elevation: 10,
                              ),
                            ),
                          )
                        ]),
                        ]
                      );
                    },
                  );
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