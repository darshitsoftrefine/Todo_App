import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FirestoreCompleteService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  Future deleteTodo() async {
    try{
      var uid = auth.currentUser!.uid;
      var db = FirebaseFirestore.instance;
      db.collection('users').doc(uid).collection('completed').where('isDone', isEqualTo: true).get().then((snapshot) {
        for(var i = 0; i < snapshot.docs.length; i++){
          if(snapshot.docs[i]['isDone'] == true){
            firestore.collection('users').doc(uid).collection('completed').doc(snapshot.docs[i].id).delete();
          }
        }
      });
    } catch(e){
        debugPrint('$e');
    }
  }

}