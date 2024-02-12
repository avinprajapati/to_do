import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(home: TaskList(),));
}

class Task {
  String title;
  bool isCompleted;

  Task(this.title, this.isCompleted);
}

class TaskList extends StatefulWidget {
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  List<Task> tasks = [];
  TextEditingController taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  void loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedTasks = prefs.getStringList('tasks');
    if (savedTasks != null) {
      setState(() {
        tasks = savedTasks.map((task) => Task(task, false)).toList();
      });
    }
  }

  void saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> taskStrings = tasks.map((task) => task.title).toList();
    prefs.setStringList('tasks', taskStrings);
  }

  void addTask() {
    String newTaskTitle = taskController.text.trim();
    if (newTaskTitle.isNotEmpty) {
      setState(() {
        tasks.add(Task(newTaskTitle, false));
      });
      saveTasks();
      taskController.clear();
    }
  }

  void toggleTask(int index) {
    setState(() {
      tasks[index].isCompleted = !tasks[index].isCompleted;
    });
    saveTasks();
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
    saveTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: taskController,
                    decoration: InputDecoration(
                      hintText: 'Enter task...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: addTask,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(tasks[index].title),
                  leading: Checkbox(
                    value: tasks[index].isCompleted,
                    onChanged: (value) => toggleTask(index),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => deleteTask(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter To-Do App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TaskList(),
    );
  }
}