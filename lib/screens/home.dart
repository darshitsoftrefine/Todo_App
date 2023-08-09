import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/themes_and_constants/custom_widgets.dart';
import 'package:demo/themes_and_constants/image_constants.dart';
import 'package:demo/themes_and_constants/string_constants.dart';
import 'package:demo/themes_and_constants/themes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../services/auth_service.dart';
import '../services/firestore_todo_service.dart';
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
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
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

  //Notifications cancel
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
                                ConstantStrings.addTaskText,
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
                                    hintText: ConstantStrings.titleHintText,
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
                                        final TimeOfDay? selectedTime =
                                            await showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now());

                                        if (selectedTime == null) {
                                          return;
                                        }

                                        timeController.text = "Today at "
                                            "${selectedTime.hour}:${selectedTime.minute}";

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
                                        if (titleController.text == "") {
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
      appBar: CustomWidgets().appbar(),
      body: CustomWidgets().homeBody()
    );
  }
}
