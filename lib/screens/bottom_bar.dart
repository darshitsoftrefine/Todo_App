import 'package:demo/screens/home.dart';
import 'package:demo/screens/settings_screen.dart';
import 'package:demo/themes_and_constants/themes.dart';
import 'package:flutter/material.dart';
import '../themes_and_constants/string_constants.dart';
import 'completed_list.dart';
class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;
  ValueNotifier<int> selIndex =  ValueNotifier<int>(0);

  final List<Widget> _widgetOptions = <Widget>[
    Home(),
    CompletedList(),
    SettingsScreen(),
  ];

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
            child: _widgetOptions.elementAt(_selectedIndex),),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: CustomColors.circColor,
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
        currentIndex: _selectedIndex,
        onTap: _onItemTap,
        selectedFontSize: 13.0,
        unselectedFontSize: 13.0,
      ),
    );
  }
}
