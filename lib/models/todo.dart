import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  String id;
  String title;
  String time;
  bool isDone;
  String userId;

  TodoModel({
    required this.id,
    required this.title,
    required this.time,
    required this.userId,
    this.isDone = false,
});
  factory TodoModel.fromJson(DocumentSnapshot snapshot){
    return TodoModel(
        id: snapshot.id,
        title: snapshot['title'],
        time: snapshot['time'],
        userId: snapshot['userId'],
        isDone: snapshot['isDone'],
    );
  }
}