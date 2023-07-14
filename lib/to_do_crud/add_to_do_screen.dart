//import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:demo/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest.dart' as tz;

class AddToDoScreen extends StatefulWidget {
 User user;
 AddToDoScreen(this.user);

  @override
  State<AddToDoScreen> createState() => _AddToDoScreenState();
}

class _AddToDoScreenState extends State<AddToDoScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController date = TextEditingController();
  final TextEditingController time = TextEditingController();

  DateTime dateTime = DateTime.now();

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF063A64),
    appBar: AppBar(
    title: const Text("New Task"),
    backgroundColor: const Color(0xFF1A71B6),
    ),
    body:  Padding(
      padding: const EdgeInsets.all(15),
      child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("What is to be done?", style: TextStyle(color: Colors.lightBlueAccent, fontSize: 18, fontWeight: FontWeight.bold),),
                const SizedBox(height: 15,),
                TextFormField(
                  //enabled: true,
                  style: const TextStyle(color: Colors.white),
                  controller: titleController,
                  obscureText: false,
                  decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.task_alt),
                    suffixIconColor: Colors.lightBlueAccent,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    //labelText: label, labelStyle: const TextStyle(color: Colors.black,),
                    hintText: 'Add Task',
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
                SizedBox(height: 15,),
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: time,
                  decoration: InputDecoration(
                    hintText: 'Add Time',
                    hintStyle: TextStyle(color: Color(0xFF1A71B6)),
                    enabledBorder: UnderlineInputBorder(
                      //borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(
                        color: Colors.lightBlueAccent,
                        width: 1.0,
                      ),
                    ),
                      suffixIcon: InkWell(
                        child: const Icon(
                          Icons.timer,
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
                      suffixIconColor: Colors.lightBlueAccent
                      //label: Text("Add Due Time", style: TextStyle(),)
                  ),
                ),
                SizedBox(height: 25,),
              ]
          )
      ),
    ),//All the TextFields in the add task,


      floatingActionButton: isLoading ? Center(child: CircularProgressIndicator(),): FloatingActionButton(
        onPressed: () async{
          if(titleController.text == "" && time.text == ""){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All Fields are required")));
          }else {
            setState(() {
              isLoading = true;
            });
            //await FirestoreService().insertTodo(titleController.text, time.text, widget.user.uid, isLoading);
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
