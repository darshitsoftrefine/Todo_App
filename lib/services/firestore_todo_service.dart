import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FirestoreTodoService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  //Delete tasks
  Future deleteTodo() async {
    try{
      var uids = auth.currentUser!.uid;
      firestore.collection('users').doc(uids).collection('todo').where('isDone', isEqualTo: true).get().then((snapshot) {
        for(var i = 0; i < snapshot.docs.length; i++){
            if(snapshot.docs[i]['isDone'] == true){
              // print(snapshot.docs[i].data());
              // print(snapshot.docs[i].id);
              firestore.collection('users').doc(uids).collection('completed').add(snapshot.docs[i].data());
             firestore.collection('users').doc(uids).collection('todo').doc(snapshot.docs[i].id).delete();
            }
        }
      });
    } catch(e){
      if (kDebugMode) {
        print(e);
      }
      //Error Message
    }
  }
}