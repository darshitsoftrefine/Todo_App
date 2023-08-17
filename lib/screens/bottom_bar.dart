import 'package:demo/screens/home.dart';
import 'package:demo/screens/settings_screen.dart';
import 'package:demo/themes_and_constants/themes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../themes_and_constants/string_constants.dart';
import 'completed_list.dart';
//ignore: must_be_immutable
class BottomBar extends StatefulWidget {
  User user;
  BottomBar(this.user, {super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;
  ValueNotifier<int> selIndex =  ValueNotifier<int>(0);

  final List<Widget> _widgetOptions = <Widget>[
    Home(),
    const CompletedList(),
    const Settings(),
  ];

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      // ValueListenableBuilder(
      //   valueListenable: selIndex,
      //   builder: (context, index, child){
      //     return
        Center(
            child: _widgetOptions.elementAt(_selectedIndex),),
      //     );
      //   },
      // ),
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
