import 'package:demo/auth_screen/auth_service.dart';
import 'package:demo/to_do_crud/add_to_do_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddToDoScreen()));
        },
        backgroundColor: Colors.white,
        child: Icon(Icons.add, color: Colors.blue,),
      ),
    );
  }
}
