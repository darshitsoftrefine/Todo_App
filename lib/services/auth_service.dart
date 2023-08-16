import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/auth_screen/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //Register new user
  Future<User?> register(String email, String password,
      BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      CollectionReference<Object?> usersCollection = firestore.collection(
          'users');

// Specify the id of the document you want to create or update
      DocumentReference<Object?> userDoc = usersCollection.doc(
          userCredential.user?.uid);
      userDoc.set({
        'email': userCredential.user!.email.toString(),
        'uid': userCredential.user!.uid,
      });
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
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      CollectionReference<Object?> usersCollection = firestore.collection(
          'users');

// Specify the id of the document you want to create or update
      DocumentReference<Object?> userDoc = usersCollection.doc(
          userCredential.user?.uid);
      userDoc.set({
        'email': userCredential.user!.email.toString(),
        'uid': userCredential.user!.uid,
      });
      print(userCredential.user);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message.toString()), backgroundColor: Colors.red,));
    }
    return null;
  }

  // Google Sign In User
  Future<User?> signInWithGoogle() async {
    try {
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
        DocumentReference<Object?> userDoc = usersCollection.doc(
            userCredential.user?.uid);
        userDoc.set({
          'email': userCredential.user!.email,
          'uid': userCredential.user!.uid,
        });
        print(userCredential.user);
        return userCredential.user;
      }
    } catch (e) {
      //Error Message
    }
    return null;
  }

  // Sign Out
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future insertTodoUser(Timestamp create, String title, String time,
      bool isDone) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    var ui = auth.currentUser?.uid;
    final CollectionReference collection = FirebaseFirestore.instance
        .collection('users');
    final DocumentReference document = collection.doc(ui);
    final CollectionReference subcollection = document.collection('todo');

    await subcollection.add({
      'create': create,
      'isDone': isDone,
      'time': time,
      'title': title,
      // Add other properties as needed
    });
  }

  Future del(BuildContext context) async {
    try {
      await firestore.collection('users').doc(
          FirebaseAuth.instance.currentUser!.uid).delete();
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()), (
              route) => false);
      await FirebaseAuth.instance.currentUser!.unlink(
          EmailAuthProvider.PROVIDER_ID);
      await FirebaseAuth.instance.currentUser!.unlink(
          GoogleAuthProvider.PROVIDER_ID);
      //await firebaseAuth.currentUser!.reauthenticateWithCredential(EmailAuthProvider.credential(email: email, password: password));
      //await firebaseAuth.currentUser!.delete();
    } catch (e) {
      debugPrint('$e');

    }
  }

  Future deleteUser(BuildContext context) async {
    try {
      await firebaseAuth.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      debugPrint('${e}');

      if (e.code == "requires-recent-login") {
        await _reauthenticateAndDelete();
      } else {
        // Handle other Firebase exceptions
      }
    } catch (e) {
      debugPrint('${e}');

      // Handle general exception
    }
    var uid = firebaseAuth.currentUser?.uid;
    var docRef = FirebaseFirestore.instance.collection('users').doc(uid);
    // ignore: use_build_context_synchronously
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
    await firebaseAuth.currentUser?.delete();
    await docRef.delete();
  }

  Future<void> _reauthenticateAndDelete() async {
    try {
      final providerData = firebaseAuth.currentUser?.providerData.first;

      if (GoogleAuthProvider().providerId == providerData?.providerId) {
        await firebaseAuth.currentUser!
            .reauthenticateWithProvider(GoogleAuthProvider());
      }
      else if (EmailAuthProvider.PROVIDER_ID == providerData?.providerId) {
        await firebaseAuth.currentUser!
            .reauthenticateWithProvider(EmailAuthProvider as OAuthProvider);
      }

      await firebaseAuth.currentUser?.delete();
    } catch (e) {
      // Handle exceptions
    }
  }
}
