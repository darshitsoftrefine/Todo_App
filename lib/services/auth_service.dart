
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  //Register new user
  Future<User?> register(String email, String password,
      BuildContext context) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message.toString()), backgroundColor: Colors.red,));
    }
    return null;
  }

  //Login existing user
  Future<User?> login(String email, String password,
      BuildContext context) async {
    try {
      var id;
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      Future<Null> firestore = FirebaseFirestore.instance.collection('users')
          .add({
        'uid': userCredential.user!.uid,
        'email': email.toString(),
        'todo': {}
      })
          .then((DocumentReference doc) {
        id = doc.id;
        print(id);
      });
      // DocumentReference docRef = FirebaseFirestore.instance.collection('users').doc(id);
      // CollectionReference subColRef = docRef.collection('todo');
      // subColRef.add({
      // 'name': userCredential.user!.email
      // });
      return userCredential.user;
      // FirebaseFirestore firestore = FirebaseFirestore.instance.collection('users').add({
      //   'email': email.toString(),
      // }) as FirebaseFirestore;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message.toString()), backgroundColor: Colors.red,));
    }
    return null;
  }

  // Google Sign In User
  Future<User?> signInWithGoogle() async {
    try {
      var id;
      CollectionReference users = firestore.collection('users');
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        GoogleSignInAuthentication? googleAuth = await googleUser
            .authentication;
        AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithCredential(credential);
        FirebaseFirestore firestore = FirebaseFirestore.instance.collection(
            'users').add({
          'email': userCredential.user!.email.toString(),
          'uid': userCredential.user!.uid,
          'todo': {},
        }).then((DocumentReference doc) {
          id = doc.id;
          print(id);
        })
        as FirebaseFirestore;
        // DocumentReference docRef = FirebaseFirestore.instance.collection('users').doc(id);
        // CollectionReference subColRef = docRef.collection('todo');
        // subColRef.add({
        //   'name': userCredential.user!.email.toString()
        // });
        //await addSubCollection(id: id);
        return userCredential.user;
      }
    } catch (e) {
      //Error Message
    }
    return null;
  }

  // Sign Out
  Future signOut() async {
    await GoogleSignIn().signOut();
    await firebaseAuth.signOut();
  }
}
//
//
//   Future<String?> addSubCollection({String? id}) async{
//     CollectionReference users = firestore.collection('users');
//     users.doc(id).collection('todo').add({
//       'id': id,
//       'created_at': DateTime.now()
//     });
//     return 'Success';
//   }
// }
// Future  sijks() async{
//   try {
//     String? fg;
//     var db = FirebaseFirestore.instance;
//     var todo = 'users';
//     db.collection(todo).where('email', isNotEqualTo: "").get().then((
//         snapshot) {
//       for (var i = 0; i < snapshot.docs.length; i++) {
//         var id = db.collection('users').doc(snapshot.docs[i].id);
//         print(id);
//         fg = id as String?;
//       }
//     });
//     return fg;
//     var id;
//     await FirebaseFirestore.instance.collection('users').add({
//
//     }).then((DocumentReference doc) {
//       id = doc.id;
//     });
//     return id;
//   }catch(e){
//
//   }
//}