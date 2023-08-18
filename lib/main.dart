import 'package:demo/auth_screen/login_screen.dart';
import 'package:demo/finger_scanner.dart';
import 'package:demo/screens/bottom_bar.dart';
import 'package:demo/services/notifications_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
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

class _MyAppState extends State<MyApp>{

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
            //print(snapshot.data);
            //_authenticate();
            return Finger();
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

// App Lifecycle State


// import 'package:flutter/material.dart';
//
// void main() => runApp(const MyApp());
//
// class MyApp extends StatelessWidget {
//
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       title: 'Woolha.com Flutter Tutorial',
//       home: DetectLifecycle(),
//     );
//   }
// }
//
// class DetectLifecycle extends StatefulWidget {
//
//   const DetectLifecycle({Key? key}) : super(key: key);
//
//   @override
//   State<StatefulWidget> createState() {
//     return _DetectLifecycleState();
//   }
// }
//
// class _DetectLifecycleState extends State<DetectLifecycle>
//     with WidgetsBindingObserver {
//
//   @override
//   void initState() {
//     WidgetsBinding.instance.addObserver(this);
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     switch (state) {
//       case AppLifecycleState.resumed:
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => const SecondRoute()),
//         );
//         print("RESUMED");
//         break;
//       case AppLifecycleState.inactive:
//         print("INACTIVE");
//         break;
//       case AppLifecycleState.paused:
//         print("PAUSED");
//         break;
//       case AppLifecycleState.detached:
//         print("DETACHED");
//         break;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Woolha.com Flutter Tutorial'),
//         backgroundColor: Colors.teal,
//       ),
//       body: const SizedBox(
//         width: double.infinity,
//         child: Center(
//           child: Text('Woolha.com'),
//         ),
//       ),
//     );
//   }
// }