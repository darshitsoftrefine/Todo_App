import 'package:demo/auth_screen/custom_field.dart';
import 'package:demo/screens/bottom_bar.dart';
import 'package:demo/themes_and_constants/image_constants.dart';
import 'package:demo/themes_and_constants/string_constants.dart';
import 'package:demo/themes_and_constants/themes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  //Declaring Variables

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 24, right: 24),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    //Register Form
                    Text(ConstantStrings.registerText, style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: CustomColors.primaryColor),),
                    const SizedBox(height: 20,),
                    Text(ConstantStrings.registerNameText, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: CustomColors.primaryColor),),
                    const SizedBox(height: 15,),
                    CustomField(label: ConstantStrings.registerLabelText, control: nameController, obs: false, hint: ConstantStrings.registerEmailHintText),
                    const SizedBox(height: 25,),
                    Text(ConstantStrings.emailText, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: CustomColors.primaryColor),),
                    const SizedBox(height: 15,),
                    CustomField(label: ConstantStrings.emailLabelText, control: emailController, obs: false, hint: ConstantStrings.registerEmailHintText,),
                    const SizedBox(height: 25,),
                    Text(ConstantStrings.passwordText, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: CustomColors.primaryColor),),
                    const SizedBox(height: 15,),
                    CustomField(label: ConstantStrings.passwordText, control: passwordController, obs: true, hint: ConstantStrings.passwordHintText,),
                    const SizedBox(height: 25,),
                    Text(ConstantStrings.registerCityText, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: CustomColors.primaryColor),),
                    const SizedBox(height: 15,),
                    CustomField(label: ConstantStrings.registerCityText, control: cityController, obs: false, hint: ConstantStrings.registerCityHintText),
                    const SizedBox(height: 25,),

                    // Register Button
                    isLoading ? const Center(child: CircularProgressIndicator()): Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: CustomColors.circleColor,
                                  fixedSize: const Size(360, 50)
                              ),
                              onPressed: () async{
                                if(emailController.text.isEmpty || passwordController.text.isEmpty){
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(ConstantStrings.snackText), backgroundColor: Colors.red,));
                                } else if(passwordController.text.length <= 7){
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter a password with more than 6 characters"), backgroundColor: Colors.red,));
                                }
                                else {
                                  User? result = await AuthService().register(emailController.text, passwordController.text, context);
                                    // ignore: use_build_context_synchronously
                                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> BottomBar(result!)), (route) => false);

                                }
                                setState(() {
                                  isLoading = false;
                                });
                              }, child: const Text(ConstantStrings.registerText)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18,),
                    Row(
                        children: const <Widget>[
                          Expanded(
                              child: Divider(color: Colors.grey,)
                          ),

                          Text(ConstantStrings.orText, style: TextStyle(color: Colors.grey),),
                          Expanded(
                              child: Divider(color: Colors.grey,)
                          ),
                        ]
                    ),
                    const SizedBox(height: 10,),

                    //Google Sign In Button
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
                              const Text(ConstantStrings.registerGoogleText),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20,),

                    //Back to Login Screen
                    Center(
                      child: TextButton(onPressed: (){
                        Navigator.pop(context);
                      }, child: RichText(
                        text: const TextSpan(
                          text: ConstantStrings.alreadyAccountText,
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                          children: [
                            TextSpan(
                              text: " ${ConstantStrings.loginText}",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12),
                            ),
                          ],
                        ),
                      )),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
