import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreTodoService {
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
      //Error Message
    }
  }

  Future updateTodo(Timestamp create, String docId, String title, String time, bool isDone) async {
    try{// Add users collection
      await firestore.collection('users').doc(docId).update({
        'create': create,
        'title': title,
        'time': time,
        'isDone': isDone
      });
    } catch(e){
      print(e);
    }

  }

  //Delete tasks
  Future deleteTodo() async {
    try{
      var db = FirebaseFirestore.instance;
      var todo = 'users';
      db.collection(todo).where('isDone', isEqualTo: true).get().then((snapshot) {
        for(var i = 0; i < snapshot.docs.length; i++){
            if(snapshot.docs[i]['isDone'] == true){
              firestore.collection('completed').add(snapshot.docs[i].data());
             firestore.collection('users').doc(snapshot.docs[i].id).delete();
            }
        }
      });
    } catch(e){
      //Error Message
    }
  }
}