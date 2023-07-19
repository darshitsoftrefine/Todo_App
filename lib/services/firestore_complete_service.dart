import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreCompleteService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future insertCompleteTodo(String docId) async {
    try {
      await firestore.collection('completed').add({
        //DocumentReference existingDoc = FirebaseFirestore.instance.doc('todo/docId')
      });
    } catch (e) {
      print(e);
    }
  }
  Future deleteTodo() async {
    try{
      var db = FirebaseFirestore.instance;
      var todo = 'completed';
      db.collection(todo).where('isDone', isEqualTo: true).get().then((snapshot) {
        //print(snapshot);
        //print(snapshot.docs.length);
        for(var i = 0; i < snapshot.docs.length; i++){
          //print('here ${snapshot.docs[i]['isDone']}');
          if(snapshot.docs[i]['isDone'] == true){
            firestore.collection('completed').doc(snapshot.docs[i].id).delete();
          }
        }
      });
    } catch(e){
      print(e);
    }
  }

}