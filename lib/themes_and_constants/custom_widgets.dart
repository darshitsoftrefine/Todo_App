import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/themes_and_constants/string_constants.dart';
import 'package:demo/themes_and_constants/themes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'image_constants.dart';



class CustomWidgets {


 PreferredSizeWidget appbar(){
   return  AppBar(
     backgroundColor: CustomColors.backgroundColor,
     title: const Text(ConstantStrings.todoTitleText),
     centerTitle: true,
     actions: [
       IconButton(
         onPressed: () async {
           await AuthService().signOut();
         },
         icon: const Icon(
           Icons.logout,
           color: Colors.white,
         ),
       )
     ],
   );
 }

 Widget homeBody(){
   FirebaseAuth auth = FirebaseAuth.instance;
   FirebaseFirestore firestore = FirebaseFirestore.instance;
   var uid = auth.currentUser!.uid;
   return SafeArea(
     child: SingleChildScrollView(
       child: Padding(
         padding: const EdgeInsets.all(15.0),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Text(
               ConstantStrings.pendingText,
               style:
               TextStyle(color: CustomColors.primaryColor, fontSize: 20),
             ),
             const SizedBox(
               height: 10,
             ),

             // Firebase display of todo Tasks
             StreamBuilder(

                 stream: firestore.collection('users').doc(uid).collection('todo').orderBy("create", descending: true).snapshots(),
                 builder: (context, AsyncSnapshot snapshot) {
                   //print(snapshot.data);
                   if (snapshot.hasData) {
                     final documents = snapshot.data!.docs;
                     //print(documents);
                     //print("data ${snapshot.data}");
                     if (documents.length > 0) {
                       // print("todo ${snapshot.data.data()["todo"]}");
                       //var todoList = snapshot.data;

                       //var id = snapshot.data.id;
                       //print("jo ${todoList}");

                       return ListView.builder(
                           physics: const NeverScrollableScrollPhysics(),
                           shrinkWrap: true,
                           itemCount: documents.length,
                           itemBuilder: (context, index) {
                             return Padding(
                               padding: const EdgeInsets.all(15),
                               child: Card(
                                 color: CustomColors.onboardColor,
                                 elevation: 5,
                                 margin: const EdgeInsets.all(5),
                                 child: CheckboxListTile(
                                   activeColor: CustomColors.circColor,
                                   controlAffinity: ListTileControlAffinity.leading,
                                   value: documents[index]['isDone'],
                                   onChanged:  (bool? value) async{
                                     await FirebaseFirestore.instance
                                         .collection('users')
                                         .doc(uid).collection('todo').doc(documents[index].id).update(
                                         {
                                           'isDone': value!
                                         });
                                   },
                                   contentPadding:
                                   const EdgeInsets.symmetric(
                                       horizontal: 10, vertical: 5),
                                   checkboxShape: const CircleBorder(),
                                   title: Text(
                                     documents[index]['title'],
                                     style: TextStyle(
                                         fontSize: 16,
                                         fontWeight: FontWeight.w400,
                                         color: CustomColors.primaryColor,
                                         decoration: documents[index]['isDone']
                                             ? TextDecoration.lineThrough
                                             : null),
                                   ),
                                   subtitle: documents[index]['time'].toString().isEmpty
                                       ? null
                                       : Text(
                                     documents[index]['time'].toString(),
                                     style: TextStyle(
                                         color: CustomColors
                                             .primaryColor),
                                   ),
                                 ),
                               ),
                             );
                           });
                     } else {
                       return Center(
                         child: Column(
                           children: [
                             const SizedBox(
                               height: 75,
                             ),
                             Image.asset(ConstantImages.notodoImage),
                             const SizedBox(
                               height: 10,
                             ),
                             Text(
                               ConstantStrings.noTodoTitle,
                               style: TextStyle(
                                   color: CustomColors.primaryColor,
                                   fontWeight: FontWeight.w400,
                                   fontSize: 20),
                             ),
                             const SizedBox(
                               height: 10,
                             ),
                             Text(
                               ConstantStrings.notTodoSubtitle,
                               style: TextStyle(
                                   color: CustomColors.primaryColor,
                                   fontSize: 16),
                             )
                           ],
                         ),
                       );
                     }
                   }
                   return const Center(
                     child: CircularProgressIndicator(),
                   );
                 }),
           ],
         ),
       ),
     ),
   );
 }
}