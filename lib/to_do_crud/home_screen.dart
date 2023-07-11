import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/services/auth_service.dart';
import 'package:demo/to_do_crud/add_to_do_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/todo.dart';
import 'edit_to_do_screen.dart';

class HomeScreen extends StatelessWidget {
  User user;
  HomeScreen(this.user);

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF063A64),
      appBar: AppBar(
        leading: Image.network('https://icon-library.com/images/todo-icon/todo-icon-5.jpg'),
        backgroundColor: Color(0xFF1A71B6),
        title: Text("All Lists of Todo"),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.search)),
          IconButton(onPressed: ()async{
           await AuthService().signOut();
          }, icon: Icon(Icons.logout, color: Colors.white,),)
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('todo').where('userId', isEqualTo: user.uid).snapshots(),
        builder: (context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            if(snapshot.data.docs.length > 0){
              return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index){
                    TodoModel todo = TodoModel.fromJson(snapshot.data.docs[index]);
                    return Padding(
                      padding: const EdgeInsets.all(15),
                      child: Card(
                        color: Color(0xFF1A71B6),
                        elevation: 5,
                        margin: EdgeInsets.all(5),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          title: Text(todo.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.lightBlueAccent),),
                          subtitle: Text(todo.time),
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=> EditTodoScreen(todo)));
                          },
                        ),
                      ),
                    );
                  });
            }else{
              return Center(
                child: Text("No Todos Added", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),),
              );
            }
          } return Center(child: CircularProgressIndicator(),);
        }
      ),

      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddToDoScreen(user)));
        },
        backgroundColor: Colors.white,
        child: Icon(Icons.add, color: Colors.blue,),
      ),
    );
  }
}
