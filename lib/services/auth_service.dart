import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService{
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //Register new user
  Future<User?> register(String email, String passsword, BuildContext context) async {
    try{
      UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: passsword);
      return userCredential.user;
    } on FirebaseAuthException catch(e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message.toString()), backgroundColor: Colors.red,));
    } catch(e){
      print(e);
    }
  }

  //Login existing user
  Future<User?> login(String email, String password, BuildContext context) async {
    try{
      UserCredential userCredential = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message.toString()), backgroundColor: Colors.red,));
    } catch(e){
      print(e);
    }

  }

  // Google Sign In User
  Future<User?> signInWithGoogle() async {
    try{
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if(googleUser != null){
        GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

        AuthCredential credential =  GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        return userCredential.user;
      }
    } catch(e){
      print(e);
    }
  }

  // Sign Out
  Future signOut() async{
    await GoogleSignIn().signOut();
    await firebaseAuth.signOut();
  }
}