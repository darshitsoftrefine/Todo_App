import 'package:demo/auth_screen/custom_field.dart';
import 'package:demo/auth_screen/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';
import '../to_do_crud/home_screen.dart';
import 'auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.only(top: 100.0, left: 10, right: 10),
        child: SingleChildScrollView(
          //physics: NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Login to Your Account", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
              const SizedBox(height: 10,),
              Text("Please enter your details to access your account", style: TextStyle(color: Colors.grey.shade500, fontSize: 12),),
              const SizedBox(height: 20,),
              const Text("Email", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
              const SizedBox(height: 15,),
              CustomField(label: 'Email Id', control: emailController, obs: false, hint: 'name@company.com',),
              const SizedBox(height: 10,),
              const Text("Password", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18 ),),
              const SizedBox(height: 15,),
              CustomField(label: 'Password', control: passwordController, obs: true, hint: 'Password',),
              const SizedBox(height: 20,),
              isLoading ? Center(child: const CircularProgressIndicator()):
              Container(
                alignment: Alignment.center,
                //width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(onPressed: () async{
                setState(() {
                  isLoading = true;
                });
                if(emailController.text == "" || passwordController.text == ""){
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("All Fields are required"), backgroundColor: Colors.red,));
                } else {
                 User? result = await AuthService().login(emailController.text, passwordController.text, context);
                 if(result != null){
                   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const HomeScreen()), (route) => false);
                 }
                      }
                setState(() {
                  isLoading = false;
                });
              },
                      child: const Text("Login"),
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(350, 50)
                    ),
                  )),
              Container(
                alignment: Alignment.center,
                child: TextButton(onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterScreen()),
                  );
                }, child: const Text("Not a Member? Register now")),
              ),
              SizedBox(height: 30,),
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
              SizedBox(height: 10,),
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
