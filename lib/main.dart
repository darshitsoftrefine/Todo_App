import 'package:demo/auth_screen/login_screen.dart';
import 'package:demo/screens/bottom_bar.dart';
import 'package:demo/services/notifications_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:timezone/data/latest.dart' as tz;

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  NotifyService().initNotification();
  tz.initializeTimeZones();
  runApp(MyApp()
      );
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        //stream:  AuthService.firebaseAuth.userChanges(),
        builder: (context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            print(snapshot.data);
            return BottomBar(snapshot.data);
          }else {
            return LoginScreen();
          }
        },
      )
    );
  }
}

// final auth = LocalAuthentication();
//
// late bool _canCheckBiometric;
// bool authenticateds = false;
//
// late List<BiometricType> _availableBiometric;
//
// String authorized = "Not authorized";
//
// @override
// void initState() {
//   _checkBiometric();
//   _getAvailableBiometric();
//
//   super.initState();
// }
//
// Future<void> _checkBiometric() async {
//   bool canCheckBiometric = false;
//   try{
//     canCheckBiometric = await auth.canCheckBiometrics;
//   } on PlatformException catch(e){
//     print(e);
//   }
//   if(!mounted) return;
//   setState(() {
//     _canCheckBiometric = canCheckBiometric;
//   });
// }
//
// Future _getAvailableBiometric() async {
//   List<BiometricType> availableBiometric = [];
//
//   try {
//     availableBiometric = await auth.getAvailableBiometrics();
//   } on PlatformException catch (e) {
//     print(e);
//   }
//
//   setState(() {
//     _availableBiometric = availableBiometric;
//   });
// }
//
// Future<void> _authenticate() async {
//   bool authenticated = false;
//   try {
//     authenticated = await auth.authenticateWithBiometrics(
//         localizedReason: "Scan your finger to authenticate",
//         useErrorDialogs: true,
//         stickyAuth: true);
//   } on PlatformException catch (e) {
//     print(e);
//   }
//   setState(() {
//     authorized =
//     authenticated ? "Authorized success" : "Failed to authenticate";
//     authenticateds = authenticated;
//     print(authorized);
//   });
// }