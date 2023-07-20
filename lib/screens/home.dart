import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/themes_and_constants/themes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../services/auth_service.dart';
import '../services/firestore_complete_service.dart';
import '../services/firestore_todo_service.dart';

class Home extends StatefulWidget {
  Home({super.key});

  User? user;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  //Declaring Variables
  int counter = 1;
  TextEditingController titleController = TextEditingController();
  final TextEditingController _desc = TextEditingController();
  TextEditingController timeController = TextEditingController();
  DateTime dateTime = DateTime.now();

  List<DocumentSnapshot> completedList = [];
  List<DocumentSnapshot> incompleteList = [];

  //Notifications Logic

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();

  }

  showNotification() {
    if (titleController.text.isEmpty) {
      return;
    }

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      "ScheduleNotification001",
      "Notify Me",
      importance: Importance.high,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      macOS: null,
      linux: null,
    );

    tz.initializeTimeZones();
    final tz.TZDateTime scheduledAt = tz.TZDateTime.from(dateTime, tz.local);

    flutterLocalNotificationsPlugin.zonedSchedule(
        01, titleController.text, _desc.text, scheduledAt, notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.wallClockTime,
        androidAllowWhileIdle: true,
        payload: 'Ths s the data');
  }

  void stopNotifications() async {
    flutterLocalNotificationsPlugin.cancel(01);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundColor,

      //Floating Action Buttons
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10.0, left: 15, right: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //Delete Button after checkboxListTile has been selected
            FloatingActionButton(
                onPressed: () async {
                  await FirestoreService().deleteTodo();
                  stopNotifications();
                },
                backgroundColor: CustomColors.circColor,
                child: const Icon(
                  Icons.check,
                  size: 30,
                )),

            //Bottom Sheet to Add Task and Time
            FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(25.0),
                      ),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Container(
                          padding: const EdgeInsets.only(
                            top: 25,
                            right: 25,
                            left: 25,
                          ),
                          color: CustomColors.onboardColor,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Add Task",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: CustomColors.primaryColor),
                              ),
                              const SizedBox(
                                height: 14,
                              ),
                              SizedBox(
                                width: 330,
                                height: 50,
                                child: TextField(
                                  autofocus: true,
                                  style: const TextStyle(color: Colors.white),
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  controller: titleController,
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                          color: Colors.grey,
                                          style: BorderStyle.solid),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: CustomColors.circColor,
                                        width: 1.0,
                                      ),
                                    ),
                                    hintText: 'Enter Title',
                                    hintStyle: TextStyle(
                                        color: CustomColors.primaryColor),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                          color: Colors.grey,
                                          style: BorderStyle.solid),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                      onPressed: () async {
                                        final TimeOfDay? slectedTime =
                                            await showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now());

                                        if (slectedTime == null) {
                                          return;
                                        }

                                        timeController.text = "Today at "
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
                                      icon: Icon(
                                        Icons.timer_outlined,
                                        color: CustomColors.primaryColor,
                                      )),
                                  IconButton(
                                      onPressed: () async {
                                        if (titleController.text == "") {
                                        } else {
                                          await FirestoreService().insertTodo(
                                              Timestamp.now(),
                                              titleController.text,
                                              timeController.text,
                                              false);
                                          showNotification();
                                          titleController.clear();
                                          timeController.clear();
                                          if(!mounted) return;
                                          Navigator.pop(context);
                                        }
                                      },
                                      icon: Icon(
                                        Icons.send,
                                        color: CustomColors.primaryColor,
                                      ))
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              },
              backgroundColor: CustomColors.circColor,
              child: const Icon(
                Icons.add,
                size: 30,
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: CustomColors.backgroundColor,
        title: const Text("To-Do Tasks"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await AuthService().signOut();
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Pending Tasks",
                  style:
                      TextStyle(color: CustomColors.primaryColor, fontSize: 20),
                ),
                const SizedBox(
                  height: 10,
                ),

                // Firebase display of todo Tasks
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('todo')
                        .orderBy('create', descending: true)
                        .snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data.docs.length > 0) {
                          List<DocumentSnapshot> todoList = snapshot.data.docs;
                          return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: todoList.length,
                              itemBuilder: (context, index) {
                                final Map<String, dynamic> data =
                                    todoList[index].data()
                                        as Map<String, dynamic>;
                                return Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Card(
                                    color: CustomColors.onboardColor,
                                    elevation: 5,
                                    margin: const EdgeInsets.all(5),
                                    child: CheckboxListTile(
                                      activeColor: CustomColors.circColor,
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      value: data['isDone'],
                                      onChanged: (bool? value) async {
                                        FirebaseFirestore.instance
                                            .collection('todo')
                                            .doc(todoList[index].id)
                                            .update({'isDone': value!});
                                        await FirestoreCompleteService()
                                            .insertCompleteTodo(
                                                todoList[index].id);
                                      },
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                      checkboxShape: const CircleBorder(),
                                      title: Text(
                                        data['title'].toString(),
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: CustomColors.primaryColor,
                                            decoration: data['isDone']
                                                ? TextDecoration.lineThrough
                                                : null),
                                      ),
                                      subtitle: data['time'].toString().isEmpty
                                          ? null
                                          : Text(
                                              data['time'].toString(),
                                              style: TextStyle(
                                                  color: CustomColors
                                                      .primaryColor),
                                            ),
                                    ),
                                  ),
                                );
                              });
                        } else {
                          return Center(
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 75,
                                ),
                                Image.asset('assets/images/no_todo.png'),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "What do you want to do today?",
                                  style: TextStyle(
                                      color: CustomColors.primaryColor,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 20),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Tap + to add your tasks",
                                  style: TextStyle(
                                      color: CustomColors.primaryColor,
                                      fontSize: 16),
                                )
                              ],
                            ),
                          );
                        }
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
