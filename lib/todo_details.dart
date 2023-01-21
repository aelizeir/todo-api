import 'package:flutter/material.dart';

class TodoDetails extends StatefulWidget {

  final dynamic todo;

  const TodoDetails({
    required this.todo,
    Key? key}) : super(key: key);

  @override
  State<TodoDetails> createState() => _TodoDetailsState();
}

class _TodoDetailsState extends State<TodoDetails> {

  Widget rowItem(String title, dynamic value) {
    return Row(
      children: [
        Expanded(
            flex: 3,
            child: Text(title),
        ),
        const SizedBox(width: 5),
        Text(value.toString())
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("To Do Details"),
        backgroundColor: Colors.green.withOpacity(0.5),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          rowItem("ID", widget.todo["_id"]),
          rowItem("Title", widget.todo['title']),
          rowItem("Description", widget.todo["description"])
        ],
      ),
    );
  }
}
