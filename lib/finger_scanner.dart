import 'dart:io';

import 'package:demo/screens/bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/local_auth.dart';


class Finger extends StatefulWidget {
  const Finger({super.key});

  @override
  State<Finger> createState() => _FingerState();
}

class _FingerState extends State<Finger> {
  final auth = LocalAuthentication();
  DateTime timeBackPressed = DateTime.now();
  late final User result;

  late bool _canCheckBiometric;

  late List<BiometricType> _availableBiometric;

  String authorized = "Not authorized";

  @override
  void initState() {
    _checkBiometric();
    _getAvailableBiometric();
    _authenticate();
    super.initState();
  }

  Future<bool> _willPopCallback() async {
    SystemNavigator.pop();
    // await showDialog or Show add banners or whatever
    // thenreturn true;
    // return true if the route to be popped
    return true;
  }

  Future<void> _checkBiometric() async {
    bool canCheckBiometric = false;
    try{
      canCheckBiometric = await auth.canCheckBiometrics;
      print("Checking ${canCheckBiometric}");
      if(canCheckBiometric == false){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> BottomBar()), (route) => false);
      }
    } on PlatformException catch(e){
      print(e);
    }
    if(!mounted) return;
    setState(() {
      _canCheckBiometric = canCheckBiometric;
    });
  }

  Future _getAvailableBiometric() async {
    List<BiometricType> availableBiometric = [];

    try {
      availableBiometric = await auth.getAvailableBiometrics();
      print(availableBiometric);
    } on PlatformException catch (e) {
      print(e);
    }

    setState(() {
      _availableBiometric = availableBiometric;
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
    //Deprecated Version use
      authenticated = await auth.authenticate(
        biometricOnly: false,
          localizedReason: "Please hold your finger at the fingerprint scanner to verify your identity",
          useErrorDialogs: true,
          stickyAuth: true);
      print("Hello ${auth.isDeviceSupported()}");
    } on PlatformException catch (e) {
      print(e);
    }
    setState(() {
      authorized =
      authenticated ? "Authorized success" : "Failed to authenticate";
      print(authorized);
      print(authenticated);
    });
     authenticated? Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> BottomBar()), (route) => false) : null;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
     backgroundColor: Colors.black,
    // appBar: AppBar(
    //   backgroundColor: Colors.black,
    //   leading: IconButton(onPressed: ()=> exit(0), icon: Icon(Icons.close),
    //
    //   ),
    // ),
  );
  }

