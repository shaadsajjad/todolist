import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Addtodo extends StatefulWidget {
  const Addtodo({super.key});

  @override
  State<Addtodo> createState() => _AddtodoState();
}

class _AddtodoState extends State<Addtodo> {
  TextEditingController todotext = TextEditingController();
  List<String> todoList = [];
  void loadData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      todoList = prefs.getStringList('items') ?? [];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        title: Text("Todo-list"),
        centerTitle: true,
        actions: [
          Icon(
            Icons.light_mode,
            size: 30,
          ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Padding(
                      padding: MediaQuery.of(context).viewInsets,
                      child: Container(
                        height: 208,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 7),
                                child: Text(
                                  "Add-Todo",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: TextField(
                                  autofocus: true,
                                  controller: todotext,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (todotext.text.isNotEmpty &&
                                        !todoList.contains(todotext.text)) {
                                      setState(() {
                                        todoList.insert(0, todotext.text);
                                      });

                                      final SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      Navigator.pop(context);

                                      await prefs.setStringList(
                                          'items', todoList);
                                    } else if (todoList
                                        .contains(todotext.text)) {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text("Already added!"),
                                              content: Text(
                                                  "This to-do have already been added to the list"),
                                              actions: [
                                                InkWell(
                                                  child: Text("Close"),
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                )
                                              ],
                                            );
                                          });
                                    } else if (todotext.text.isEmpty) {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text("write something"),
                                              content: Text(
                                                  "write something to add in the todo list"),
                                              actions: [
                                                InkWell(
                                                  child: Text("Close"),
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                )
                                              ],
                                            );
                                          });
                                    }
                                    todotext.text = '';
                                  },
                                  child: Text(
                                    "Add Todo",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.all(10),
                                      minimumSize: Size(double.infinity, 20)),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            },
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Icon(
                Icons.add,
                size: 30,
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
          itemCount: todoList.length,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.startToEnd,
              background: Container(
                color: Colors.red,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(Icons.delete)],
                ),
              ),
              onDismissed: (direction) {
                setState(() {
                  todoList.removeAt(index);
                });
              },
              child: ListTile(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              todoList.removeAt(index);
                            });

                            Navigator.pop(context);
                          },
                          child: Text(
                            "Mark as done",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 20)),
                        );
                      });
                },
                title: Text(
                  "${todoList[index]}",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            );
          }),
    );
  }
}
