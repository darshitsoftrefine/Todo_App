import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/themes_and_constants/string_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/firestore_complete_service.dart';
import '../themes_and_constants/image_constants.dart';
import '../themes_and_constants/themes.dart';

class CompletedList extends StatefulWidget {
  const CompletedList({super.key});

  @override
  State<CompletedList> createState() => _CompletedListState();
}

class _CompletedListState extends State<CompletedList> {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    var uid = auth.currentUser!.uid;
    return Scaffold(
      backgroundColor: CustomColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: CustomColors.backgroundColor,
        elevation: 0,
        title: const Text(ConstantStrings.completedTasksTitle),
        centerTitle: true,
      ),
      body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          slivers: [
          SliverFillRemaining(
            fillOverscroll: true,
            hasScrollBody: true,
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0, right: 15.0, left: 15.0, bottom: 15),
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
                              Image.asset(ConstantImages.noTodoImage),
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
                  const Expanded(child: SizedBox()),
                  Center(
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
              ),
            ],
          ),
        ),
      ),
        ]
      ),
    );
  }
}
