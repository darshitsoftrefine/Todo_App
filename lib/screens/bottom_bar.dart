import 'package:demo/screens/home.dart';
import 'package:demo/screens/settings_screen.dart';
import 'package:demo/themes_and_constants/themes.dart';
import 'package:flutter/material.dart';
import '../themes_and_constants/string_constants.dart';
import 'completed_list.dart';
class BottomBar extends StatelessWidget {
  BottomBar({super.key});


  final ValueNotifier<int> selIndex =  ValueNotifier<int>(0);

  final List<Widget> _widgetOptions = <Widget>[
    Home(),
    CompletedList(),
    SettingsScreen(),
  ];

  void _onItemTap(int index) {
      selIndex.value = index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ValueListenableBuilder(
          valueListenable: selIndex,
            builder: (BuildContext context, int value, Widget? child) {
      return _widgetOptions.elementAt(value);
    },),),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: selIndex,
        builder: (BuildContext context, int value, Widget? child) {
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: CustomColors.circle1Color,
            backgroundColor: Colors.black,
            unselectedItemColor: Colors.grey,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.insert_chart_outlined,
                ),
                label: ConstantStrings.bottomLabelTodoText,
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.check,
                ),
                label: ConstantStrings.bottomLabelCompletedText,
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings,
                ),
                label: "Settings",
              ),
            ],
            currentIndex: selIndex.value,
            onTap: _onItemTap,
            selectedFontSize: 13.0,
            unselectedFontSize: 13.0,
          );
        },
      ),
    );
  }
}
