import 'package:demo/auth_screen/custom_field.dart';
import 'package:demo/auth_screen/register_screen.dart';
import 'package:demo/themes_and_constants/custom_widgets.dart';
import 'package:demo/themes_and_constants/image_constants.dart';
import 'package:demo/themes_and_constants/themes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../themes_and_constants/string_constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //Declaring Variables

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 31.0, left: 24, right: 24),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            slivers: [
              //SliverAppBar(),
              SliverToBoxAdapter(
                child:  Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    //Login form
                    Text(ConstantStrings.loginText, style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: CustomColors.primaryColor),),
                    const SizedBox(height: 30,),
                    Text(ConstantStrings.emailText, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: CustomColors.primaryColor),),
                    const SizedBox(height: 15,),
                    CustomField(label: ConstantStrings.emailLabelText, control: emailController, obs: false, hint: ConstantStrings.emailHintText,),
                    const SizedBox(height: 25,),
                    Text(ConstantStrings.passwordText, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: CustomColors.primaryColor),),
                    const SizedBox(height: 15,),
                    CustomField(label: ConstantStrings.passwordText, control: passwordController, obs: true, hint: ConstantStrings.passwordHintText,),
                    const SizedBox(height: 25,),
                    //Expanded(child: SizedBox(), flex: 5,),
                    //Login Button
                    isLoading ? const Center(child: CircularProgressIndicator()):
                    ElevatedButton(onPressed: () async{
                      if(emailController.text == "" || passwordController.text == ""){
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(ConstantStrings.snackText), backgroundColor: Colors.red,));
                      } else {
                        await AuthService().login(emailController.text, passwordController.text, context);
                      }
                      setState(() {
                        isLoading = false;
                      });
                    },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.circleColor,
                          disabledBackgroundColor: CustomColors.circColor,
                          fixedSize: const Size(367, 48)
                      ),
                      child: const Text(ConstantStrings.loginText, style: TextStyle(color: Colors.white),),
                    ),
                    const SizedBox(height: 20,),
                    Row(
                        children: const <Widget>[
                          Expanded(
                              child: Divider(color: Colors.grey,)
                          ),
                          Text("or", style: TextStyle(color: Colors.grey),),
                          Expanded(
                              child: Divider(color: Colors.grey,)
                          ),
                        ]
                    ),

                    const SizedBox(height: 20,),

                    //Google Sign in Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        isLoading ? const CircularProgressIndicator():
                        ElevatedButton(
                          onPressed: () async{
                            await AuthService().signInWithGoogle();
                            setState(() {
                              isLoading = false;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: CustomColors.backgroundColor, padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(color: CustomColors.circColor)
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(ConstantImages.googleImage, width: 30, height: 30,),
                              const SizedBox(width: 10),
                              const Text(ConstantStrings.googleLoginText),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30,),
                    //SliverToBoxAdapter(child: Expanded(child: SizedBox())),
                    Center(
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
                    ),
                  ],
                ),
              ),

            ],
          ),
        )

        ),
    );
  }
}
