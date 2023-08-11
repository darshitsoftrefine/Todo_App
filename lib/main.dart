import 'package:demo/screens/bottom_bar.dart';
import 'package:demo/services/auth_service.dart';
import 'package:demo/auth_screen/login_screen.dart';
import 'package:demo/services/notifications_service.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:timezone/data/latest.dart' as tz;

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  NotifyService().initNotification();
  tz.initializeTimeZones();
  runApp(DevicePreview(builder: (BuildContext context) => const MyApp(),)
      );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder(
        //stream: FirebaseAuth.instance.userChanges(),
        stream:  AuthService.firebaseAuth.userChanges(),
        builder: (context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            return BottomBar(snapshot.data);
          }else {
            return const LoginScreen();
          }
        },
      )
    );
  }
}
