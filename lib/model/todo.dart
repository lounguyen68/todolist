class ToDo {
  String? id;
  String? text;
  bool isDone;

  ToDo({
    this.id,
    this.text,
    this.isDone = false,
  });

  static List<ToDo> todoList() {
    return [
      ToDo(id: '01', text: 'Morning Excercise', isDone: true ),
      ToDo(id: '02', text: 'Buy Groceries', isDone: true ),
      ToDo(id: '03', text: 'Check Emails', ),
      ToDo(id: '04', text: 'Team Meeting', ),
      ToDo(id: '05', text: 'Work on mobile apps for 2 hour', ),
      ToDo(id: '06', text: 'Dinner with Jenny', ),
    ];
  }

  ToDo fromJson(jsonData) {
    return ToDo(id: jsonData['id'], text: jsonData['text'], isDone: jsonData['isDone']);
  }

  Object toJson() {
    return {
      "id": id,
      "text": text,
      "isDone": isDone
    };
  }
}

