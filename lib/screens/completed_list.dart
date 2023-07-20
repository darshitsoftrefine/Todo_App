import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/services/firestore_complete_service.dart';
import 'package:flutter/material.dart';

import '../themes_and_constants/themes.dart';

class CompletedList extends StatefulWidget {
  const CompletedList({super.key});

  @override
  State<CompletedList> createState() => _CompletedListState();
}

class _CompletedListState extends State<CompletedList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: CustomColors.backgroundColor,
        elevation: 0,
        title: const Text("Completed Tasks"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10,),


              //Completed Tasks display
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection('completed').orderBy('create', descending: true).snapshots(),
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
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      title: Text(completedTodoList[index]['title'], style: TextStyle(color: CustomColors.primaryColor),),
                      subtitle: completedTodoList[index]['time'].toString().isEmpty ? null: Text(completedTodoList[index]['time'], style: TextStyle(color: CustomColors.primaryColor),),
                    ),
                  ),
                );
              });
    } else {
      return Center(
        child: Column(
          children: [
            const SizedBox(height: 95,),
            Image.asset('assets/images/no_todo.png'),
              const SizedBox(height: 10,),
              Text("No completed tasks here!", style: TextStyle(color: CustomColors.primaryColor, fontWeight: FontWeight.w400, fontSize: 20),),
              const SizedBox(height: 10,),

            ],
          ),
      );
    }
    } return const Center(child: CircularProgressIndicator(),);
                }
                ),

              //Delete All completed Tasks


            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
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
            "Clear Completed Tasks",
            style: TextStyle(fontSize: 18, color:Colors.white),
          ),),
      ),
    );
  }
}
