// ignore_for_file: use_build_context_synchronously
import 'dart:io';

import 'package:demo/screens/bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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


  Future<void> _checkBiometric() async {
    bool canCheckBiometric = false;
    try{
      canCheckBiometric = await auth.canCheckBiometrics;
      if(canCheckBiometric == false){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> BottomBar()), (route) => false);
      }
    } on PlatformException catch(e){
      debugPrint('$e');
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
    } on PlatformException catch (e) {
     debugPrint('$e');
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
    } on PlatformException catch (e) {
      debugPrint('$e');
    }
    setState(() {
      authorized =
      authenticated ? "Authorized success" : "Failed to authenticate";
    });
     authenticated? Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> BottomBar()), (route) => false) : null;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => _onWillPop(context),
        child: const Scaffold(backgroundColor: Colors.black,));
  }

  Future<bool> _onWillPop(BuildContext context) async {
    DateTime now = DateTime.now();
    if (lastPressed == null || now.difference(lastPressed!) > Duration(seconds: 2)) {
      lastPressed = now;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Press back again to exit.')));
      return Future.value(false);
    }
    return Future.value(true);
  }

  DateTime? lastPressed;
  }

