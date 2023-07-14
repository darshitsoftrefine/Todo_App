import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/to_do_crud/edit_to_do_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../models/todo.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
class Home extends StatefulWidget {
  User user;
  Home(this.user);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  int counter = 1;
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

    // const IOSNotificationDetails iosNotificationDetails =
    // DarwinNotificationDetails(
    //   presentAlert: true,
    //   presentBadge: true,
    //   presentSound: true,
    // );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      //iOS: iosNotificationDetails,
      macOS: null,
      linux: null,
    );

    // flutterLocalNotificationsPlugin.show(
    //     01, _title.text, _desc.text, notificationDetails);

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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: Image.network('https://icon-library.com/images/todo-icon/todo-icon-5.jpg'),
        backgroundColor: Color(0xFF1A71B6),
        title: Text("All Lists of Todo"),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.search)),
          IconButton(onPressed: ()async{
            await AuthService().signOut();
          }, icon: Icon(Icons.logout, color: Colors.white,),)
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text("Enter Task Title and Deadline", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 15, top: 15, bottom: 10),
              child: Row(
                children: [
                  SizedBox(
                    width: 330,
                    height: 50,
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      controller: titleController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                              color: Colors.grey,
                              style: BorderStyle.solid
                          ),
                        ),
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

                            timeController.text =
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
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  IconButton(onPressed: () async{
                    if(titleController.text == ""){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please Enter title")));
                    } else {
                      await FirestoreService().insertTodo(Timestamp.now(),titleController.text, timeController.text, widget.user.uid, false);
                      showNotification();
                      titleController.clear();
                      timeController.clear();
                    }
                  }, icon: Icon(Icons.check))
                ],
              ),
            ),

            StreamBuilder(
                stream: FirebaseFirestore.instance.collection('todo').orderBy('create', descending: true).snapshots(),
                builder: (context, AsyncSnapshot snapshot){
                  if(snapshot.hasData){
                    if(snapshot.data.docs.length > 0){
                      List<DocumentSnapshot> todoList = snapshot.data.docs;
                      return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                          itemCount: todoList.length,
                          itemBuilder: (context, index){
                          //print(snapshot.data.docs[index]);
                            final Map<String, dynamic> data = todoList[index].data() as Map<String, dynamic>;
                            print(data);
                            TodoModel todo = TodoModel.fromJson(snapshot.data.docs[index]);
                            return Padding(
                              padding: const EdgeInsets.all(15),
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => EditTodoScreen(todo)),
                                  );
                                },
                                child: Card(
                                  color: Color(0xFF1A71B6),
                                  elevation: 5,
                                  margin: EdgeInsets.all(5),
                                  child: CheckboxListTile(
                                    controlAffinity: ListTileControlAffinity.leading,
                                    value: data['isDone'],
                                    onChanged: (bool? value) {
                                      FirebaseFirestore.instance.collection('todo').doc(todoList[index].id).update(
                                          {'isDone': value!});
                                  },
                                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    title: Text(data['title'].toString(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.lightBlueAccent, decoration: data['isDone']? TextDecoration.lineThrough:null),),
                                    subtitle: Text(data['time'].toString(), style: TextStyle(color: Colors.lightBlueAccent),),

                                  ),
                                ),
                              ),
                            );
                          });
                    }else{
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 15.0),
                          child: Text("No Todos Added", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25),),
                        ),
                      );
                    }
                  } return const Center(child: CircularProgressIndicator(),);
                }
            ),
            Center(child: ElevatedButton(onPressed: () async{
              var db = FirebaseFirestore.instance;
              var batch = db.batch();
              var d = FirebaseFirestore.instance.collection('todo').where('isDone', isEqualTo: true).snapshots();
              await FirestoreService().deleteTodo();
            }, child: Text("Completed")))
          ],
        ),
      ),
    );
  }
}
