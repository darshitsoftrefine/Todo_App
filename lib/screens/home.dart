import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/themes_and_constants/themes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../models/todo.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

const List<String> list = <String>['Today', 'Tomorrow'];
class Home extends StatefulWidget {
  User user;
  Home(this.user);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  int counter = 1;
  String dropdownValue = list.first;
  TextEditingController titleController = TextEditingController();
  final TextEditingController _desc = TextEditingController();
  TextEditingController timeController = TextEditingController();
  DateTime dateTime = DateTime.now();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings("@mipmap/ic_launcher");



    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: androidInitializationSettings,
      //iOS: iosInitializationSettings,
      macOS: null,
      linux: null,
    );

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse: (dataYouNeedToUseWhenNotificationIsClicked) {},
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundColor,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 15.0, left: 15, right: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(onPressed: (){}, child: Icon(Icons.check, size: 30,),  backgroundColor: CustomColors.circColor),
            FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(25.0),
                      ),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    context: context,
                    isScrollControlled: true,
                    builder: (context){
                  return Container(
                    height: 550,
                    padding: EdgeInsets.only(top: 25, right: 25, left: 25, bottom: MediaQuery.of(context).viewInsets.bottom,),
                    color: CustomColors.onboardColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Add Task", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: CustomColors.primaryColor),),
                        SizedBox(height: 14,),
                        SizedBox(
                          width: 330,
                          height: 50,
                          child: TextField(
                            autofocus: true,
                            style: TextStyle(color: Colors.white),
                            textCapitalization: TextCapitalization.sentences,
                            controller: titleController,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                    color: Colors.grey,
                                    style: BorderStyle.solid
                                ),
                              ),
                              hintText: 'Enter Title',
                              hintStyle: TextStyle(color: CustomColors.primaryColor),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                    color: Colors.grey,
                                    style: BorderStyle.solid
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 40,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(onPressed: () async {
                  final TimeOfDay? slectedTime = await showTimePicker(
                  context: context, initialTime: TimeOfDay.now());

                  if (slectedTime == null) {
                  return;
                  }

                  timeController.text =
                  "Today at "+"${slectedTime.hour}:${slectedTime.minute}";

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
                  }, icon: Icon(Icons.timer_outlined, color: CustomColors.primaryColor,)),

                            IconButton(onPressed: () async{
                              if(titleController.text == ""){
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please Enter title")));
                              } else {
                                await FirestoreService().insertTodo(Timestamp.now(),titleController.text, timeController.text, widget.user.uid, false);
                                showNotification();
                                Navigator.pop(context);
                                titleController.clear();
                                timeController.clear();
                              }
                            }, icon: Icon(Icons.send, color: CustomColors.primaryColor,))
                          ],
                        )
                      ],
                    ),
                  );
                });
              },
              backgroundColor: CustomColors.circColor,
              child: Icon(Icons.add, size: 30,),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: Image.asset('assets/images/leading_icon.png'),
        backgroundColor: CustomColors.backgroundColor,
        title: const Text("Index"),
        centerTitle: true,
        actions: [
          CircleAvatar(
            child: Icon(Icons.person),
          ),
          IconButton(onPressed: ()async{
            await AuthService().signOut();
          }, icon: const Icon(Icons.logout, color: Colors.white,),)
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 76,
                      height: 41,
                      padding: EdgeInsets.only(left: 10, right: 1),
                      decoration: BoxDecoration(
                        color: CustomColors.onboardColor,
                        borderRadius: BorderRadius.circular(8)
                      ),
                      child: Row(
                        children: [
                          Text("Today", style: TextStyle(color: CustomColors.primaryColor, fontSize: 12),),
                          SizedBox(width: 5,),
                          Icon(Icons.keyboard_arrow_down_outlined, color: CustomColors.primaryColor,)
                        ],
                      ),
                    ),
                  ],
                ),
            SizedBox(height: 20,),
            //   Container(
            //     padding: EdgeInsets.all(2),
            //     decoration: BoxDecoration(
            //       color: CustomColors.onboardColor
            //     ),
            //     child: DropdownButton<String>(
            //     value: dropdownValue,
            //     icon: Icon(Icons.keyboard_arrow_down, color: CustomColors.primaryColor,),
            //     elevation: 16,
            //     underline: SizedBox(),
            //     style: TextStyle(color: CustomColors.circColor),
            //     onChanged: (String? value) {
            //       // This is called when the user selects an item.
            //       setState(() {
            //         dropdownValue = value!;
            //       });
            //     },
            //     items: list.map<DropdownMenuItem<String>>((String value) {
            //       return DropdownMenuItem<String>(
            //         value: value,
            //         child: Text(value),
            //       );
            //     }).toList(),
            // ),
            //   ),
                StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('todo').orderBy('create', descending: true).snapshots(),
                    builder: (context, AsyncSnapshot snapshot){
                      if(snapshot.hasData){
                        if(snapshot.data.docs.length > 0){
                          List<DocumentSnapshot> todoList = snapshot.data.docs;
                          return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                              itemCount: todoList.length,
                              itemBuilder: (context, index){
                              //print(snapshot.data.docs[index]);
                                final Map<String, dynamic> data = todoList[index].data() as Map<String, dynamic>;
                                print(data);
                                TodoModel todo = TodoModel.fromJson(snapshot.data.docs[index]);
                                return Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Card(
                                    color: CustomColors.onboardColor,
                                    elevation: 5,
                                    margin: const EdgeInsets.all(5),
                                    child: CheckboxListTile(
                                      controlAffinity: ListTileControlAffinity.leading,
                                      value: data['isDone'],
                                      onChanged: (bool? value) {
                                        FirebaseFirestore.instance.collection('todo').doc(todoList[index].id).update(
                                            {'isDone': value!});
                                    },
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      checkboxShape: CircleBorder(),
                                      title: Text(data['title'].toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: CustomColors.primaryColor, decoration: data['isDone']? TextDecoration.lineThrough:null),),
                                      subtitle: Text(data['time'].toString(), style: TextStyle(color: CustomColors.primaryColor),),
                                    ),
                                  ),
                                );
                              });
                        }else{
                          return Center(
                            child: Column(
                              children: [
                                SizedBox(height: 75,),
                                Image.asset('assets/images/no_todo.png'),
                                SizedBox(height: 10,),
                                Text("What do you want to do today?", style: TextStyle(color: CustomColors.primaryColor, fontWeight: FontWeight.w400, fontSize: 20),),
                                SizedBox(height: 10,),
                                Text("Tap + to add your tasks", style: TextStyle(color: CustomColors.primaryColor, fontSize: 16),)

                              ],
                            ),
                          );
                        }
                      } return const Center(child: CircularProgressIndicator(),);
                    }
                ),
                Center(child: ElevatedButton(onPressed: () async{
                  await FirestoreService().deleteTodo();
                }, child: const Text("Completed")))
              ],
            ),
          ),
        ),
      ),
    );
  }
  }