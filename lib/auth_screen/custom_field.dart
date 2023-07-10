import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  const CustomField({super.key, required this.label, required this.control, required this.obs, required this.hint});
  final String label;
  final String hint;
  final TextEditingController control;
  final bool obs;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 11, right: 11, bottom: 5),
      child: TextFormField(
        //enabled: true,
        //style: const TextStyle(color: Colors.white),
        controller: control,
        obscureText: obs,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          //labelText: label, labelStyle: const TextStyle(color: Colors.black,),
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(
              color: Colors.grey,
              style: BorderStyle.solid
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
          ),


        ),
      ),
    );
  }
}
