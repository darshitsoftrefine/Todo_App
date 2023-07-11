import 'package:demo/auth_screen/custom_field.dart';
import 'package:demo/to_do_crud/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';

import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.only(top: 100.0, left: 10, right: 10),
        child: SingleChildScrollView(
          // physics: const ClampingScrollPhysics(),
          // primary: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Create Your Account", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
              const SizedBox(height: 20,),
              const Text("Name", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              SizedBox(height: 15,),
              CustomField(label: 'Name', control: nameController, obs: false, hint: 'John'),
              SizedBox(height: 10,),
              const Text("Email", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
              const SizedBox(height: 15,),
              CustomField(label: 'Email Id', control: emailController, obs: false, hint: 'name@company.com',),
              SizedBox(height: 10,),
              const Text("Password", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18 ),),
              const SizedBox(height: 15,),
              CustomField(label: 'Password', control: passwordController, obs: true, hint: 'Password',),
              SizedBox(height: 10,),
              const Text("City", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
              SizedBox(height: 15,),
              CustomField(label: 'City', control: cityController, obs: false, hint: 'Kolkata'),
              SizedBox(height: 30,),
              isLoading ? Center(child: const CircularProgressIndicator()): Container(
                alignment: Alignment.center,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(350, 50)
                  ),
                    onPressed: () async{
                  setState(() {
                    isLoading = true;
                  });
                  if(emailController.text == "" || passwordController.text == ""){
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("All Fields are required"), backgroundColor: Colors.red,));
                  } else {
                    User? result = await AuthService().register(emailController.text, passwordController.text, context);
                    if(result != null){
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> HomeScreen(result)), (route) => false);

                    }
                  }
                  setState(() {
                    isLoading = false;
                  });
                }, child: const Text("Register")),
              ),
              Container(
                alignment: Alignment.center,
                child: TextButton(onPressed: (){
                  Navigator.pop(context);
                }, child: const Text("Already a Member? Please Login")),
              ),
              const SizedBox(height: 20,),
              Row(
                  children: const <Widget>[
                    Expanded(
                        child: Divider(color: Colors.grey,)
                    ),

                    Text("  OR  "),

                    Expanded(
                        child: Divider(color: Colors.grey,)
                    ),
                  ]
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isLoading ? const CircularProgressIndicator(): SignInButton(
                    Buttons.google, onPressed: () async{
                    setState(() {
                      isLoading = true;
                    });
                    await AuthService().signInWithGoogle();
                    setState(() {
                      isLoading = false;
                    });
                  }, text: 'Sign In With Google',),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
