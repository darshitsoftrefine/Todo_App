import 'package:demo/themes_and_constants/custom_widgets.dart';
import 'package:demo/themes_and_constants/themes.dart';
import 'package:flutter/material.dart';

import '../themes_and_constants/string_constants.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: CustomColors.backgroundColor,
        elevation: 0,
        title: const Text(ConstantStrings.settingsText),
        centerTitle: true,
      ),
      body: CustomWidgets().settingsBody(context)
    );
  }
}
