// ignore_for_file: use_build_context_synchronously

import 'package:demo/auth_screen/custom_field.dart';
import 'package:demo/auth_screen/register_screen.dart';
import 'package:demo/themes_and_constants/image_constants.dart';
import 'package:demo/themes_and_constants/themes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/bottom_bar.dart';
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
  //bool isLoading = false;
  ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  ValueNotifier<bool> isLoadingGoog = ValueNotifier<bool>(false);

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 31.0, left: 24, right: 24, bottom: 12),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            slivers: [
              SliverFillRemaining(
                fillOverscroll: true,
                hasScrollBody: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
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
                      //Expanded(child: SizedBox()),
                      //Login Button
                      //isLoading ? const Center(child: CircularProgressIndicator()):
                      ValueListenableBuilder(valueListenable: isLoading, builder: (context, loading, child){
                        return loading? const Center(child: CircularProgressIndicator()): Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(onPressed: () async{
                                if(emailController.text.isEmpty || passwordController.text.isEmpty){
                                  // setState(() {
                                  //   isLoading = true;
                                  // });
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(ConstantStrings.snackText), backgroundColor: Colors.red,));
                                } else {
                                  isLoading.value = !isLoading.value;
                                    Future.delayed(const Duration(seconds: 2), () {
                                    isLoading.value = !isLoading.value;
                                    });
                                  User? result = await AuthService().login(emailController.text, passwordController.text, context);
                                  if(result != null){
                                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> BottomBar(result)), (route) => false);
                                  }
                                  // isLoading ? const CircularProgressIndicator():
                                  //prefs.setString('email', emailController.text);
                                  //await AuthService().login(emailController.text, passwordController.text, context);

                                }
                                // setState(() {
                                //   isLoading = false;
                                // });
                              },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: CustomColors.circleColor,
                                    fixedSize: const Size(367, 48)
                                ),
                                child: const Text(ConstantStrings.loginText, style: TextStyle(color: Colors.white),),
                              ),
                            ),
                          ],
                        );
                      }),

                      const SizedBox(height: 20,),
                      Row(
                          children: const <Widget>[
                            Expanded(
                                child: Divider(color: Colors.grey,)
                            ),
                            Text(" ${ConstantStrings.orText}", style: TextStyle(color: Colors.grey),),
                            Expanded(
                                child: Divider(color: Colors.grey,)
                            ),
                          ]
                      ),

                      const SizedBox(height: 20,),

                      //Google Sign in Button
                      ValueListenableBuilder(valueListenable: isLoadingGoog, builder: (context, loading, child){
                        return loading ? const Center(child: CircularProgressIndicator(),):Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () async{
                                //await AuthService().signInWithGoogle();
                                isLoadingGoog.value = !isLoadingGoog.value;
                                Future.delayed(const Duration(seconds: 2), () {
                                  isLoadingGoog.value = !isLoadingGoog.value;
                                });
                                User? result = await AuthService().signInWithGoogle();
                                if(result != null) {
                                  Navigator.pushAndRemoveUntil(context,
                                      MaterialPageRoute(builder: (context) => BottomBar(result)), (
                                          route) => false);
                                }
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
                        );
                      }),

                      const SizedBox(height: 30,),
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
                                text: " ${ConstantStrings.registerText}",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12),
                              ),
                            ],
                          ),
                        )),
                      ),
                    ],
                  )
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 10,),)
            ],
          ),
        )

        ),
    );
  }
}
