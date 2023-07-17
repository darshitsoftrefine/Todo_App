import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  const CustomField({super.key, required this.label, required this.control, required this.obs, required this.hint});
  final String label;
  final String hint;
  final TextEditingController control;
  final bool obs;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      //enabled: true,
      style: const TextStyle(color: Colors.white),
      controller: control,
      obscureText: obs,
      decoration: InputDecoration(
        //labelText: label, labelStyle: const TextStyle(color: Colors.black,),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          //borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(
            color: Color(0xFF979797),
            style: BorderStyle.solid
          ),
        ),
        enabledBorder: OutlineInputBorder(
          //borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(
            color: Color(0xFF979797),
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          //borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(
            color: Color(0xFF979797),
            width: 1.0,
          ),
        ),


      ),
    );
  }
}
