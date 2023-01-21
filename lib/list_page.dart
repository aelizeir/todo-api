import 'package:api/add_todo.dart';
import 'package:api/todo_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {

  bool isLoading = true;
  List items = [];
  // List todos = <dynamic>[];

  @override
  void initState() {
    super.initState();
    // getTodo();
    fetchTodo();
  }

  // getTodo() async {
  //   var url = 'https://jsonplaceholder.typicode.com/todos';
  //   var response = await http.get(Uri.parse(url));
  //
  //   setState(() {
  //     todos = convert.jsonDecode(response.body) as List<dynamic>;
  //   });
  // }

  Future<void> navigateToAddTodo() async {
    final route = MaterialPageRoute(builder: (context) => const AddTodo(),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> navigateToEditTodo(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodo(todo: item),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> deleteById(String id) async {
    final url = 'http://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    if(response.statusCode == 200) {
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    }
    else {
      showErrorMessage('Unable to Delete');
    }
  }

  Future<void> fetchTodo() async {
    setState(() {
      isLoading = true;
    });
    const url = 'http://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = convert.jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      setState(() {
        items = result;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  void showErrorMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(CupertinoIcons.checkmark_square_fill),
        title: const Text('Todo'),
      ),
      body: Visibility(
        visible: isLoading,
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(
              child: Text(
                'No Todo Item',
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index] as Map;
                final id = items[index]['_id'] as String;
                return Card(
                  child: ListTile(
                    leading: Text('${index + 1}'),
                    title: Text(items[index]['title']),
                    subtitle: Text(items[index]['description']),
                    trailing: PopupMenuButton(
                      onSelected: (value) {
                        if(value == 'edit'){
                          navigateToEditTodo(item);
                        } else if(value == 'delete'){
                          deleteById(id);
                        }
                      },
                      itemBuilder: (context) {
                        return [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Text('Edit'),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('Delete'),
                          ),
                        ];
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TodoDetails(todo: items[index]))
                      );
                    },
                  ),
                );
              }),
          ),
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: navigateToAddTodo,
          child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
