import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreCompleteService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  //Inserting pending Tasks after deleting it
  // Future insertCompleteTodo(String docId) async {
  //   try {
  //     await firestore.collection('completed').add({
  //     });
  //   } catch (e) {
  //     //Error Message
  //   }
  // }

  //Delete All completed Tasks
  Future deleteTodo() async {
    try{
      var db = FirebaseFirestore.instance;
      var todo = 'completed';
      db.collection(todo).where('isDone', isEqualTo: true).get().then((snapshot) {
        for(var i = 0; i < snapshot.docs.length; i++){
          if(snapshot.docs[i]['isDone'] == true){
            //firestore.collection('completed').doc(snapshot.docs[i]['time']).delete();
            firestore.collection('completed').doc(snapshot.docs[i].id).delete();
          }
        }
      });
    } catch(e){
      //Error Message
    }
  }

}