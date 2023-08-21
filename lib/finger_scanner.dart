import 'package:demo/screens/bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';


class FingerScanner extends StatefulWidget {
  const FingerScanner({super.key});

  @override
  State<FingerScanner> createState() => _FingerScannerState();
}

class _FingerScannerState extends State<FingerScanner> {
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
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const BottomBar()), (route) => false);
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
     // ignore: use_build_context_synchronously
     authenticated? Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const BottomBar()), (route) => false) : null;
  }

  @override
  void dispose() {
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
    if (lastPressed == null || now.difference(lastPressed!) > const Duration(seconds: 2)) {
      lastPressed = now;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Press back again to exit.')));
      return Future.value(false);
    }
    return Future.value(true);
  }

  DateTime? lastPressed;
  }

