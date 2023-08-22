import 'package:demo/themes_and_constants/string_constants.dart';
import 'package:demo/themes_and_constants/themes.dart';
import 'package:flutter/material.dart';


class CustomWidgets {


 Widget textFieldBottomSheet(TextEditingController controller){
   return SizedBox(
     width: 330,
     height: 50,
     child: TextField(
       autofocus: true,
       style: const TextStyle(color: Colors.white),
       textCapitalization:
       TextCapitalization.sentences,
       controller: controller,
       decoration: InputDecoration(
         enabledBorder: OutlineInputBorder(
           borderRadius: BorderRadius.circular(10.0),
           borderSide: const BorderSide(
               color: Colors.grey,
               style: BorderStyle.solid),
         ),
         focusedBorder: OutlineInputBorder(
           borderSide: BorderSide(
             color: CustomColors.circle1Color,
             width: 1.0,
           ),
         ),
         hintText: ConstantStrings.titleHintText,
         hintStyle: TextStyle(
             color: CustomColors.primaryColor),
         border: OutlineInputBorder(
           borderRadius: BorderRadius.circular(10.0),
           borderSide: const BorderSide(
               color: Colors.grey,
               style: BorderStyle.solid),
         ),
       ),
     ),
   );
 }
}