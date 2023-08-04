import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var logDocId;
  var googLodId;

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
      FirebaseFirestore firestores = FirebaseFirestore.instance;
      CollectionReference<Object?> usersCollection = firestores.collection(
          'users');

// Specify the id of the document you want to create or update
      DocumentReference<Object?> userDoc = usersCollection.doc(
          userCredential.user?.uid);
      logDocId = userCredential.user?.uid;
      userDoc.set({
        'email': userCredential.user!.email.toString(),
        'uid': userCredential.user!.uid,
        'todo': {},
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
      var uids = firebaseAuth.currentUser?.uid;
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
        CollectionReference<Object?> usersCollection = firestore.collection(
            'users');

// Specify the id of the document you want to create or update
        DocumentReference<Object?> userDoc = usersCollection.doc(
            userCredential.user?.uid);
        googLodId = userCredential.user?.uid;
        userDoc.set({
          'email': userCredential.user!.email.toString(),
          'uid': userCredential.user!.uid,
          'todo': {},
        });
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
    //FirebaseFirestore fire = FirebaseFirestore.instance.collection('users').doc(id).delete() as FirebaseFirestore;
    await GoogleSignIn().signOut();
    await firebaseAuth.signOut();
  }

  Future insertTodoUser(Timestamp create, String title, String time, bool isDone) async {

    FirebaseFirestore fire = FirebaseFirestore.instance;
    FirebaseFirestore db = FirebaseFirestore.instance;
    var uids = firebaseAuth.currentUser?.uid;
    // final docRef = db.collection("users").doc("XcZlpfCItqtwb91pdB6T");
    // docRef.get().then(
    //       (DocumentSnapshot doc) {
    //     final data = doc.data() as Map<String, dynamic>;
    //     print(data);
    //   },
    //   onError: (e) => print("Error getting document: $e"),
    // );
    // db.collection("users").where("email", isNotEqualTo: "").get().then(
    //       (querySnapshot) {
    //     print("Successfully completed");
    //     for (var docSnapshot in querySnapshot.docs) {
    //       print('${docSnapshot.id} => ${docSnapshot.data()}');
    //     }
    //   },
    //   onError: (e) => print("Error completing: $e"),
    // );
    fire.collection('users').where("email", isNotEqualTo: "").get().then((
        querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        print('${docSnapshot.id} => ${docSnapshot.data()}');
      }
    });
    var a = await FirebaseFirestore.instance
        .collection("users")
        .doc(uids)
        .get();
    if (a.exists) {
      final DocumentReference documentReference = FirebaseFirestore.instance
          .collection("users")
          .doc(uids);
      //print(documentReference.snapshots().length);

      var index = 8;
      index++;
      return await documentReference.set({
        //your data
        'todo': FieldValue.arrayUnion([
          {
            'create': create,
            'title': title,
            'time': time,
            'isDone': isDone,
          }
        ])

      }, SetOptions(merge: true));

      //   await todoList.doc(ui).update({
      //   'create': create,
      //   'title': title,
      //   'time': time,
      //   'isDone': isDone,
      // });
    }
  }

    Future deleteUser() async {
      var uids = firebaseAuth.currentUser?.uid;
      final DocumentReference documentReference = FirebaseFirestore.instance
          .collection("users")
          .doc(uids);

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
// await AuthService().insertTodoUser(
// widget.user?.uid.toString(),
// Timestamp.now(),
// titleController.text,
// timeController.text,
// false);
