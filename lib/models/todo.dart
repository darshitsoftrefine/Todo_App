import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  String id;
  String title;
  String date;
  String time;
  String description;
  String userId;

  TodoModel({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.description,
    required this.userId
});
  factory TodoModel.fromJson(DocumentSnapshot snapshot){
    return TodoModel(
        id: snapshot.id,
        title: snapshot['title'],
        date: snapshot['date'],
        time: snapshot['time'],
        description: snapshot['description'],
        userId: snapshot['userId']
    );
  }
}