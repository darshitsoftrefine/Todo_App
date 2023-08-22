import 'package:demo/auth_screen/custom_field.dart';
import 'package:demo/auth_screen/register_screen.dart';
import 'package:demo/themes_and_constants/image_constants.dart';
import 'package:demo/themes_and_constants/themes.dart';
import 'package:flutter/material.dart';
import '../screens/bottom_bar.dart';
import '../services/auth_service.dart';
import '../themes_and_constants/string_constants.dart';
class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  //Declaring Variables
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isLoadingGoogle = ValueNotifier<bool>(false);

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

                      ValueListenableBuilder(valueListenable: isLoading, builder: (context, loading, child){
                        return loading? const Center(child: CircularProgressIndicator()): Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(onPressed: () async{
                                if(emailController.text.isEmpty || passwordController.text.isEmpty){
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(ConstantStrings.snackText), backgroundColor: Colors.red,));
                                } else {
                                  isLoading.value = !isLoading.value;
                                    Future.delayed(const Duration(seconds: 2), () {
                                    isLoading.value = !isLoading.value;
                                    });
                                  await AuthService().login(emailController.text, passwordController.text, context);
                                  if(context.mounted) return;
                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const BottomBar()), (route) => false);
                                }
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
                            Padding(
                              padding: EdgeInsets.only(left: 4, right: 4),
                              child: Text(ConstantStrings.orText, style: TextStyle(color: Colors.grey),),
                            ),
                            Expanded(
                                child: Divider(color: Colors.grey,)
                            ),
                          ]
                      ),

                      const SizedBox(height: 20,),

                      //Google Sign in Button
                      ValueListenableBuilder(valueListenable: isLoadingGoogle, builder: (context, loading, child){
                        return loading ? const Center(child: CircularProgressIndicator(),):Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () async{
                                isLoadingGoogle.value = !isLoadingGoogle.value;
                                Future.delayed(const Duration(seconds: 2), () {
                                  isLoadingGoogle.value = !isLoadingGoogle.value;
                                });
                                await AuthService().signInWithGoogle();
                                  if(context.mounted) return;
                                  Navigator.pushAndRemoveUntil(context,
                                      MaterialPageRoute(builder: (context) => const BottomBar()), (
                                          route) => false);

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
                            MaterialPageRoute(builder: (context) => RegisterScreen()),
                          );
                        }, child:Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(ConstantStrings.dontAccountText, style: TextStyle(color: Colors.grey, fontSize: 12),),
                            Padding(
                              padding: EdgeInsets.only(left: 4),
                              child: Text(ConstantStrings.registerText, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12, ),),
                            ),
                          ],
                        )
                      ),
                      )
                    ],
                  )
              ),
            ],
          ),
        )

        ),
    );
  }
}
