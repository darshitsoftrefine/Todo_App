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
  late final User result;

  late bool _canCheckBiometric;

  late List<BiometricType> _availableBiometric;

  String authorized = "Not authorized";

  @override
  void initState() {
    _checkBiometric();
    _getAvailableBiometric();

    super.initState();
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
     authenticated? Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> BottomBar()), (route) => false) : Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> BottomBar()), (route) => false);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade600,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0,     horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                "Login",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 48.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 50.0),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 15.0),
                    child: const Text(
                      "Authenticate using your fingerprint instead of your password \n\n  If you don't have fingerprint option you can use your security pin instead",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white,
                          height: 1.5),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 15.0),
                    width: double.infinity,
                    child: FloatingActionButton(
                      onPressed: _authenticate,
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 14.0),
                        child: Text(
                          "Authenticate",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
