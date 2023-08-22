import 'package:demo/screens/bottom_bar.dart';
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

  @override
  void initState() {
    _authenticate();
    super.initState();
  }


  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        biometricOnly: false,
          localizedReason: "Please hold your finger at the fingerprint scanner to verify your identity",
          useErrorDialogs: true,
          stickyAuth: true);
    } on PlatformException {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>  BottomBar()), (route) => false);
    }
     if(context.mounted) {
       authenticated ? Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> BottomBar()), (route) => false): null;
     }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(backgroundColor: Colors.black,);
  }
  }

