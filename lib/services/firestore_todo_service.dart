import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/models/todo.dart';

class FirestoreService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;


  //insert Tasks
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

  //Delete tasks
  Future deleteTodo() async {
    try{
      var db = FirebaseFirestore.instance;
      var todo = 'todo';
      db.collection(todo).where('isDone', isEqualTo: true).get().then((snapshot) {
        for(var i = 0; i < snapshot.docs.length; i++){
            if(snapshot.docs[i]['isDone'] == true){
              firestore.collection('completed').add(snapshot.docs[i].data());
             firestore.collection('todo').doc(snapshot.docs[i].id).delete();
            }
        }
      });
    } catch(e){
    }
  }
}