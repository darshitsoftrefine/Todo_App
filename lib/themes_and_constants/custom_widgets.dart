import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/themes_and_constants/string_constants.dart';
import 'package:demo/themes_and_constants/themes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth_screen/register_screen.dart';
import '../services/auth_service.dart';
import '../services/firestore_complete_service.dart';
import 'image_constants.dart';



class CustomWidgets {


 PreferredSizeWidget appbar(){
   return  AppBar(
     backgroundColor: CustomColors.backgroundColor,
     title: const Text(ConstantStrings.todoTitleText),
     centerTitle: true,
     // actions: [
     //   IconButton(
     //     onPressed: () async {
     //       await AuthService().signOut();
     //     },
     //     icon: const Icon(
     //       Icons.logout,
     //       color: Colors.white,
     //     ),
     //   )
     // ],
   );
 }
 Widget textFieldBottomSheet(TextEditingController controller){
   return SizedBox(
     width: 330,
     height: 50,
     child: TextField(
       autofocus: true,
       style: const TextStyle(color: Colors.white),
       textCapitalization:
       TextCapitalization.sentences,
       controller: controller,
       decoration: InputDecoration(
         enabledBorder: OutlineInputBorder(
           borderRadius: BorderRadius.circular(10.0),
           borderSide: const BorderSide(
               color: Colors.grey,
               style: BorderStyle.solid),
         ),
         focusedBorder: OutlineInputBorder(
           borderSide: BorderSide(
             color: CustomColors.circColor,
             width: 1.0,
           ),
         ),
         hintText: ConstantStrings.titleHintText,
         hintStyle: TextStyle(
             color: CustomColors.primaryColor),
         border: OutlineInputBorder(
           borderRadius: BorderRadius.circular(10.0),
           borderSide: const BorderSide(
               color: Colors.grey,
               style: BorderStyle.solid),
         ),
       ),
     ),
   );
 }



 Widget bottomLoginBar(BuildContext context){
   return Padding(
     padding: const EdgeInsets.only(top: 10.0, bottom: 5),
     child: TextButton(onPressed: (){
       Navigator.push(
         context,
         MaterialPageRoute(builder: (context) => const RegisterScreen()),
       );
     }, child: RichText(
       text: const TextSpan(
         text: ConstantStrings.dontAccountText,
         style: TextStyle(color: Colors.grey, fontSize: 12),
         children: [
           TextSpan(
             text: ConstantStrings.registerText,
             style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12),
           ),
         ],
       ),
     )),
   );
 }
}