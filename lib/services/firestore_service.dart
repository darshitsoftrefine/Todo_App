

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future insertTodo(String title, String date, String time, String userId) async {
    try{
      await firestore.collection('todo').add({
        "title": title,
        "date": date,
        "time": time,
        'userId': userId,
      });
    } catch(e){
        print(e);
    }
  }

  Future updateTodo(String docId, String title, String date, String time) async {
    try{
      await firestore.collection('todo').doc(docId).update({
        'title': title,
        'date': date,
        'time': time,

      });
    } catch(e){
      print(e);
    }

  }

  Future deleteTodo(String docId) async {
    try{
      await firestore.collection('todo').doc(docId).delete();
    } catch(e){
      print(e);
    }
  }
}