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

 Widget completedList(){
   FirebaseAuth auth = FirebaseAuth.instance;
   var uid = auth.currentUser!.uid;
   return SingleChildScrollView(
     child: Padding(
       padding: const EdgeInsets.all(15.0),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           const SizedBox(height: 10,),


           //Completed Tasks display
           StreamBuilder(
               stream: FirebaseFirestore.instance.collection('users').doc(uid).collection('completed').snapshots(),
               builder: (context, AsyncSnapshot snapshot) {
                 if(snapshot.hasData){

                   if(snapshot.data.docs.length > 0){
                     List<DocumentSnapshot> completedTodoList = snapshot.data.docs;
                     return ListView.builder(
                         physics: const NeverScrollableScrollPhysics(),
                         shrinkWrap: true,
                         itemCount: completedTodoList.length,
                         itemBuilder: (context, index){
                           return Padding(
                             padding: const EdgeInsets.all(10.0),
                             child: Card(
                               color: CustomColors.onboardColor,
                               elevation: 5,
                               margin: const EdgeInsets.all(5),
                               child: ListTile(
                                 contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 1),
                                 title: Text(completedTodoList[index]['title'], style: TextStyle(color: CustomColors.primaryColor),),
                                 subtitle: completedTodoList[index]['time'].toString().isEmpty? null : Text(completedTodoList[index]['time'], style: TextStyle(color: CustomColors.primaryColor),),
                               ),
                             ),
                           );
                         });
                   } else {
                     return Center(
                       child: Column(
                         children: [
                           const SizedBox(height: 95,),
                           Image.asset(ConstantImages.notodoImage),
                           const SizedBox(height: 10,),
                           Text(ConstantStrings.noTasksText, style: TextStyle(color: CustomColors.primaryColor, fontWeight: FontWeight.w400, fontSize: 20),),
                           const SizedBox(height: 10,),

                         ],
                       ),
                     );
                   }
                 }                return const Center(child: CircularProgressIndicator(),);
               }
           ),

           //Delete All completed Tasks


         ],
       ),
     ),
   );
 }
 Widget settingsBody(BuildContext context){
   return SafeArea(
     child: Padding(
       padding: const EdgeInsets.only(top: 10, left: 34, right: 34, bottom: 10),
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [

           GestureDetector(
             onTap: () async{
                 await AuthService().deleteUser(context);
                 },
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 ElevatedButton.icon(
                   onPressed: (){},
                   icon: const Icon(
                     Icons.delete,
                     size: 24.0,
                   ),
                   label: const Text('Delete your account'),
                   style: ElevatedButton.styleFrom(
                     backgroundColor: CustomColors.backgroundColor
                   ),
                 ),
                 const Icon(Icons.arrow_forward_ios, color: Colors.white,)
               ],
             ),
           ),
           const SizedBox(height: 90,),
           ElevatedButton.icon(onPressed: () async{
             await AuthService().signOut();
           }, icon: const Icon(Icons.logout, color: Colors.red,), label: const Text("Log out", style: TextStyle(color: Colors.red),),
             style: ElevatedButton.styleFrom(
               backgroundColor: Colors.black
             ),)
           //Text("(If You Delete your account your Tasks Will be gone)", style: TextStyle(color: CustomColors.primaryColor, fontSize: 13),)
         ],
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

 Widget bottomCompletedButton(){
   return Padding(
     padding: const EdgeInsets.only(left: 32, right: 32, top: 12, bottom: 28),
     child: ElevatedButton(onPressed: () async {
       await FirestoreCompleteService().deleteTodo();
     },
       style: ElevatedButton.styleFrom(
         minimumSize: const Size(160, 40),
         backgroundColor: CustomColors.circleColor,
         shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(32)),
       ),
       child: const Text(
         ConstantStrings.clearText,
         style: TextStyle(fontSize: 18, color:Colors.white),
       ),),
   );
 }
}