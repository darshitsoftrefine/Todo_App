import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/themes_and_constants/custom_widgets.dart';
import 'package:demo/themes_and_constants/string_constants.dart';
import 'package:demo/themes_and_constants/themes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../services/auth_service.dart';
import '../services/firestore_todo_service.dart';
import '../themes_and_constants/image_constants.dart';
//ignore: must_be_immutable
class Home extends StatefulWidget {
  Home({super.key});

  User? user;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  //Declaring Variables
  TextEditingController titleController = TextEditingController();
  final TextEditingController _desc = TextEditingController();
  TextEditingController timeController = TextEditingController();
  DateTime dateTime = DateTime.now();
  FirebaseAuth auth = FirebaseAuth.instance;


  //Notifications Logic
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

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

  //Notifications cancel
  void stopNotifications() async {
    flutterLocalNotificationsPlugin.cancel(01);
  }

  @override
  Widget build(BuildContext context) {
    var uid = auth.currentUser!.uid;
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
                heroTag: "btn1",
                onPressed: () async {
                  await FirestoreTodoService().deleteTodo();
                  stopNotifications();
                },
                backgroundColor: CustomColors.circColor,
                child: const Icon(
                  Icons.check,
                  size: 30,
                )),

            //Bottom Sheet to Add Task and Time
            FloatingActionButton(
              heroTag: "btn2",
              onPressed: () {
                showModalBottomSheet(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(32.0),
                      ),
                    ),
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
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ConstantStrings.addTaskText,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: CustomColors.primaryColor),
                                ),
                                const SizedBox(
                                  height: 14,
                                ),
                                CustomWidgets().textFieldBottomSheet(titleController),
                                const SizedBox(
                                  height: 40,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                        onPressed: () async {
                                          final TimeOfDay? selectedTime =
                                              await showTimePicker(
                                                  context: context,
                                                  initialTime: TimeOfDay.now());

                                          if (selectedTime == null) {
                                            return;
                                          }

                                          timeController.text =
                                              "${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}";

                                          DateTime newDT = DateTime(
                                            dateTime.year,
                                            dateTime.month,
                                            dateTime.day,
                                            selectedTime.hour,
                                            selectedTime.minute,
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
                                          if (titleController.text.isEmpty) {
                                            return;
                                          } else {
                                            //await firestore.collection('users').doc()
                                            await AuthService().insertTodoUser(
                                                Timestamp.now(),
                                                titleController.text,
                                                timeController.text,
                                                false,

                                            );
                                            showNotification();
                                            titleController.clear();
                                            timeController.clear();
                                            // ignore: use_build_context_synchronously
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
        title: const Text(ConstantStrings.todoTitleText),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ConstantStrings.pendingText,
                  style:
                  TextStyle(color: CustomColors.primaryColor, fontSize: 20),
                ),
                const SizedBox(
                  height: 10,
                ),

                // Firebase display of todo Tasks
                StreamBuilder(

                    stream: firestore.collection('users').doc(uid).collection('todo').orderBy("create", descending: true).snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        final documents = snapshot.data!.docs;
                        if (documents.length > 0) {
                          return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: documents.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Card(
                                    color: CustomColors.onboardColor,
                                    elevation: 5,
                                    margin: const EdgeInsets.all(5),
                                    child: CheckboxListTile(
                                      activeColor: CustomColors.circColor,
                                      controlAffinity: ListTileControlAffinity.leading,
                                      value: documents[index]['isDone'],
                                      onChanged:  (bool? value) async{
                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(uid).collection('todo').doc(documents[index].id).update(
                                            {
                                              'isDone': value!
                                            });
                                      },
                                      contentPadding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      checkboxShape: const CircleBorder(),
                                      title: Text(
                                        documents[index]['title'],
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: CustomColors.primaryColor,
                                            decoration: documents[index]['isDone']
                                                ? TextDecoration.lineThrough
                                                : null),
                                      ),
                                      subtitle: documents[index]['time'].toString().isEmpty
                                          ? null
                                          : Text(
                                        documents[index]['time'].toString(),
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
                                Image.asset(ConstantImages.notodoImage),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  ConstantStrings.noTodoTitle,
                                  style: TextStyle(
                                      color: CustomColors.primaryColor,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 20),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  ConstantStrings.notTodoSubtitle,
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
