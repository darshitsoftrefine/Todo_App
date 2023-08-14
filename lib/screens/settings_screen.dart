import 'package:demo/themes_and_constants/themes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../themes_and_constants/string_constants.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: CustomColors.backgroundColor,
        elevation: 0,
        title: const Text(ConstantStrings.settingsText),
        centerTitle: true,
      ),
      body:SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 150, left: 34, right: 34, bottom: 150),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                child: Column(
                  children: [
              Text("Name: ${auth.currentUser!.displayName}",style: const TextStyle(color: Colors.white, fontSize: 18),),
              const SizedBox(height: 20,),
              Text("E-Mail Id : ${auth.currentUser!.email}", style: const TextStyle(color: Colors.white, fontSize: 18),),
              ]),
              ),
              const Expanded(child: SizedBox()),
              ElevatedButton.icon(
                onPressed: () async{
                  await AuthService().del();
                  },
                icon: const Icon(
                  Icons.delete,
                  size: 29.0,
                ),
                label: const Text('Delete your account', style: TextStyle(fontSize: 20),),
                style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.backgroundColor
                ),
              ),
              const Expanded(child: SizedBox()),
              ElevatedButton.icon(onPressed: () async{
                await AuthService().signOut();
              }, icon: const Icon(Icons.logout, color: Colors.red, size: 30,), label: const Text("Log out", style: TextStyle(color: Colors.red, fontSize: 20),),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black
                ),)
            ],
          ),
        ),
      ),
    );
  }
}
