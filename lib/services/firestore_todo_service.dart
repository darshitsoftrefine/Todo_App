import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/models/todo.dart';

class FirestoreService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future insertTodo(Timestamp create, String title, String time, bool isDone) async {
    try{
      await firestore.collection('todo').add({
        "create": create,
        "title": title,
        "time": time,
        'isDone': isDone
      });
    } catch(e){
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
    }

  }

  Future deleteTodo() async {
    try{
      var db = FirebaseFirestore.instance;
      var todo = 'todo';
      TodoModel todoModel;
      db.collection(todo).where('isDone', isEqualTo: true).get().then((snapshot) {
        //print(snapshot);
        //print(snapshot.docs.length);
        for(var i = 0; i < snapshot.docs.length; i++){
          //print('here ${snapshot.docs[i]['isDone']}');
            if(snapshot.docs[i]['isDone'] == true){
              firestore.collection('completed').add(snapshot.docs[i].data());
             firestore.collection('todo').doc(snapshot.docs[i].id).delete();
            }
        }
      });
     //await firestore.collection('todo').doc(docId).delete();
    } catch(e){
    }
  }
}