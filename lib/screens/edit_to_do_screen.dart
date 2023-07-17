import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/models/todo.dart';
import 'package:flutter/material.dart';

import '../services/firestore_service.dart';

class EditTodoScreen extends StatefulWidget {
  TodoModel todo;
  EditTodoScreen(this.todo);

  @override
  State<EditTodoScreen> createState() => _EditTodoScreenState();
}

class _EditTodoScreenState extends State<EditTodoScreen> {

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final TextEditingController date = TextEditingController();
  final TextEditingController time = TextEditingController();

  DateTime dateTime = DateTime.now();

  bool isLoading = false;

  @override
  void initState() {
    titleController.text = widget.todo.title;
    time.text = widget.todo.time as String;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF063A64),
      appBar: AppBar(
        title: const Text("Edit Task"),
        backgroundColor: const Color(0xFF1A71B6),
        actions: [
          IconButton(onPressed: () async{
            await showDialog(context: context, builder: (BuildContext context){
              return AlertDialog(
               title: Text("Please Confirm"),
                content: Text("Are you sure you want to delete the todo ?"),
                actions: [
                  //Yes Button
                  TextButton(onPressed: () async{
                   // await FirestoreService().deleteTodo(widget.todo.id);
                    //Close Dialog
                    Navigator.pop(context);
                    // Close the edit Screen
                    Navigator.pop(context);
                  }, child: Text("Yes")),

                  // No Button
                  TextButton(onPressed: (){
                    Navigator.pop(context);
                  }, child: Text("No"))
                ],
              );
            });
          }, icon: Icon(Icons.delete, color: Colors.black,))
        ],
      ),
      body:  Padding(
        padding: const EdgeInsets.all(15),//All the TextFields in the add task,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Edit title", style: TextStyle(color: Colors.lightBlueAccent, fontSize: 18, fontWeight: FontWeight.bold),),
              const SizedBox(height: 15,),
              TextFormField(
                //enabled: true,
                style: const TextStyle(color: Colors.white),
                controller: titleController,
                obscureText: false,
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.edit),
                  suffixIconColor: Colors.lightBlueAccent,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  //labelText: label, labelStyle: const TextStyle(color: Colors.black,),
                  hintStyle: TextStyle(color: Color(0xFF1A71B6)),
                  enabledBorder: UnderlineInputBorder(
                    //borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(
                      color: Colors.lightBlueAccent,
                      width: 1.0,
                    ),
                  ),


                ),
              ),
              const SizedBox(height: 25,),
              const Text("Due Time", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.lightBlueAccent),),
        TextField(
        controller: time,
          //enabled: true,
          style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              //borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide(
                color: Colors.lightBlueAccent,
                width: 1.0,
              ),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            suffixIconColor: Colors.lightBlueAccent,
            suffixIcon: InkWell(
              child: const Icon(
                Icons.timer_outlined,
              ),
              onTap: () async {
                final TimeOfDay? slectedTime = await showTimePicker(
                    context: context, initialTime: TimeOfDay.now());

                if (slectedTime == null) {
                  return;
                }

                time.text =
                "${slectedTime.hour}:${slectedTime.minute}";

                DateTime newDT = DateTime(
                  dateTime.year,
                  dateTime.month,
                  dateTime.day,
                  slectedTime.hour,
                  slectedTime.minute,
                );
                setState(() {
                  dateTime = newDT;
                });
              },
            ),
            label: Text("Time"),
          labelStyle: TextStyle(color: Colors.white)
        ),
          ),
              SizedBox(height: 25,),

            ]
        ),
    ),
      floatingActionButton: isLoading ? Center(child: CircularProgressIndicator(),): FloatingActionButton(
        onPressed: () async{
          if(titleController.text == "" || time.text== ""){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All Fields are required")));
          }else {
            setState(() {
              isLoading = true;
            });
            await FirestoreService().updateTodo(widget.todo.id, titleController.text, date.text, time.text);
            setState(() {
              isLoading = false;
            });
            Navigator.pop(context);
          }
        },
        backgroundColor: Colors.white,
        child: Icon(Icons.check, color: Colors.blue,),
      ),
    );
  }
}
