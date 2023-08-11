import 'package:demo/themes_and_constants/custom_widgets.dart';
import 'package:demo/themes_and_constants/string_constants.dart';
import 'package:flutter/material.dart';
import '../themes_and_constants/themes.dart';

class CompletedList extends StatefulWidget {
  const CompletedList({super.key});

  @override
  State<CompletedList> createState() => _CompletedListState();
}

class _CompletedListState extends State<CompletedList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: CustomColors.backgroundColor,
        elevation: 0,
        title: const Text(ConstantStrings.completedTasksTitle),
        centerTitle: true,
      ),
      body: CustomWidgets().completedList(),

      bottomNavigationBar: CustomWidgets().bottomCompletedButton(),
    );
  }
}
