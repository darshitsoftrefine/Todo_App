import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FirestoreTodoService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  //Delete tasks
  Future deleteTodo() async {
    try{
      var uid = auth.currentUser!.uid;
      firestore.collection('users').doc(uid).collection('todo').where('isDone', isEqualTo: true).get().then((snapshot) {
        for(var i = 0; i < snapshot.docs.length; i++){
            if(snapshot.docs[i]['isDone'] == true){

              firestore.collection('users').doc(uid).collection('completed').add(snapshot.docs[i].data());
             firestore.collection('users').doc(uid).collection('todo').doc(snapshot.docs[i].id).delete();
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