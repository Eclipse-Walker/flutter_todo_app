import 'package:flutter/material.dart';
import 'package:todo_app/utils/todo_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = TextEditingController();
  List<List<dynamic>> todoList = [
    ['Read manga', false],
    ['Watch anime', false],
    ['Play game', false],
    ['Coding?', false],
  ];

  /* List todoList = [
    ['Read manga', false],
    ['Watch anime', false],
    ['Play game', false],
    ['Coding?', false],
  ]; */

  @override
  void initState() {
    super.initState();
    loadTodoList();
  }

  Future<void> loadTodoList() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('todoList');

    if (jsonString != null) {
      setState(() {
        todoList = List<List<dynamic>>.from(
            jsonDecode(jsonString).map((item) => List<dynamic>.from(item)));
      });
    }
  }

  Future<void> saveTodoList() async {
    final prefs = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(todoList);
    await prefs.setString('todoList', jsonString);
  }

  void checkBoxChanged(int index) {
    setState(() {
      todoList[index][1] = !todoList[index][1];
      saveTodoList();
    });
  }

  void saveNewTask() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        todoList.add([_controller.text, false]);
        _controller.clear();
        saveTodoList();
      });
    }
  }

  void deleteTask(int index) {
    setState(() {
      todoList.removeAt(index);
      saveTodoList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        /* leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.tag),
        ), */
        title: const Text(
          "Reminder",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
          itemCount: todoList.length,
          itemBuilder: (BuildContext context, index) {
            return TodoList(
              taskName: todoList[index][0],
              taskCompleted: todoList[index][1],
              onChanged: (value) => checkBoxChanged(index),
              deleteFunction: (context) => deleteTask(index),
            );
          }),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  controller: _controller,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    hintText: 'New Reminder',
                    filled: true,
                    fillColor: Colors.grey.shade300,
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            Theme(
              data: Theme.of(context).copyWith(highlightColor: Colors.black),
              child: FloatingActionButton(
                onPressed: saveNewTask,
                backgroundColor: Colors.white,
                hoverColor: Colors.grey,
                child: const Icon(
                  Icons.add,
                  color: Colors.black87,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
