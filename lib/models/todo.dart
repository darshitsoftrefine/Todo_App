import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  Timestamp create;
  String id;
  String title;
  String time;
  bool isDone;
  String userId;

  TodoModel({
    required this.create,
    required this.id,
    required this.title,
    required this.time,
    required this.userId,
    required this.isDone,
});
  factory TodoModel.fromJson(DocumentSnapshot snapshot){
    return TodoModel(
      create: snapshot['create'],
        id: snapshot.id,
        title: snapshot['title'],
        time: snapshot['time'],
        userId: snapshot['userId'],
        isDone: snapshot['isDone'],
    );
  }
}