import 'package:demo/services/auth_service.dart';
import 'package:demo/themes_and_constants/themes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 14, right: 14, bottom: 10),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Email: ${auth.currentUser!.email}",style: TextStyle(color: CustomColors.primaryColor, fontSize: 16, fontWeight: FontWeight.bold),),
                const SizedBox(height: 50,),
                Text('Delete User Credentials', style: TextStyle(color: CustomColors.primaryColor, fontSize: 18, fontWeight: FontWeight.bold),),
                const SizedBox(height: 10,),
                ElevatedButton.icon(
                  onPressed: () async{
                    await AuthService().deleteUser();
                  },
                  icon: const Icon(
                    Icons.delete,
                    size: 24.0,
                  ),
                  label: const Text('Delete'),
                ),
                const SizedBox(height: 90,),
                Text("(If You Delete your account your Tasks Will be gone)", style: TextStyle(color: CustomColors.primaryColor),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
