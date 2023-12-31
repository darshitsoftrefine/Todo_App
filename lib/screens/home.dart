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
class Home extends StatelessWidget {
  Home({super.key});

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController _desc = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;

  final ValueNotifier<DateTime> dateTim = ValueNotifier<DateTime>(DateTime.now());

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
    final tz.TZDateTime scheduledAt = tz.TZDateTime.from(dateTim.value, tz.local);

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
    var uid = auth.currentUser?.uid;
    return Scaffold(
      backgroundColor: CustomColors.backgroundColor,

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10.0, left: 15, right: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            FloatingActionButton(
                heroTag: "btn1",
                onPressed: () async {
                  await FirestoreTodoService().deleteTodo();
                  stopNotifications();
                },
                backgroundColor: CustomColors.circle1Color,
                child: const Icon(
                  Icons.check,
                  size: 30,
                  color: Colors.white,
                )),


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
                                            dateTim.value.year,
                                            dateTim.value.month,
                                            dateTim.value.day,
                                            selectedTime.hour,
                                            selectedTime.minute,
                                          );
                                          dateTim.value = newDT;
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
                                            await AuthService().insertTodoUser(
                                                Timestamp.now(),
                                                titleController.text,
                                                timeController.text,
                                                false,

                                            );
                                            showNotification();
                                            titleController.clear();
                                            timeController.clear();
                                            if(context.mounted) {
                                              Navigator.pop(context);
                                            }
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
              backgroundColor: CustomColors.circle1Color,
              child: const Icon(
                Icons.add,
                size: 30,
                color: Colors.white,
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
                                      activeColor: CustomColors.circle1Color,
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
                                Image.asset(ConstantImages.noTodoImage),
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
