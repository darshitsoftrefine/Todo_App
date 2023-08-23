import 'package:demo/themes_and_constants/image_constants.dart';
import 'package:demo/themes_and_constants/themes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../auth_screen/login_screen.dart';
import '../services/auth_service.dart';
import '../themes_and_constants/string_constants.dart';
class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  final FirebaseAuth auth = FirebaseAuth.instance;

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
          padding: const EdgeInsets.only(top: 40, left: 34, right: 34, bottom: 190),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              auth.currentUser?.photoURL == null? const CircleAvatar(backgroundImage: AssetImage(ConstantImages.placeHoldImage), radius: 50,): CircleAvatar(backgroundImage: NetworkImage('${auth.currentUser!.photoURL}'), radius: 50,),
              const SizedBox(height: 30,),
              auth.currentUser?.displayName == null || auth.currentUser?.displayName == ''? Text('${auth.currentUser?.email?.split('@').first}',style: const TextStyle(color: Colors.white, fontSize: 20),) :Text("${auth.currentUser?.displayName}",style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),),
              const SizedBox(height: 20,),
              Text("${auth.currentUser?.email}", style: const TextStyle(color: Colors.white, fontSize: 14),),
              const SizedBox(height: 20,),
              ElevatedButton.icon(
                onPressed: () async{
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Delete your Account?'),
                        content: const Text(
                            '''If you select Delete we will delete your account on our server.
                           Your app tasks will also be deleted and you won't be able to retrieve it.'''),
                        actions: [
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text(
                              'Delete',
                              ),
                            onPressed: () async{
                              await AuthService().deleteUser(context);// Call the delete account function
                            },
                          ),
                        ],
                      );
                    },
                  );

                  },
                icon: const Icon(
                  Icons.delete,
                  size: 24.0,
                ),
                label: const Text('Delete your account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                    backgroundColor: CustomColors.backgroundColor
                ),
              ),
              const SizedBox(height: 8,),
              ElevatedButton.icon(onPressed: () async{
                await AuthService().signOut();
                if(context.mounted) {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()),(route) => false);
                }
              }, icon: const Icon(Icons.logout, color: Colors.red, size: 24,), label: const Text("Log out", style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.w400),),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.only(left: 3),
                    backgroundColor: Colors.black
                ),)
            ],
          ),
        ),
      ),
    );
  }
}
