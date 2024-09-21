import 'package:flutter/material.dart';

import 'rive_model.dart';

class Menu {
  final String title;
  final int index;
  final RiveModel rive;
  final Function(BuildContext)? onPressed;
  Menu(
      {required this.title,
      required this.rive,
      required this.onPressed,
      required this.index});
}

List<Menu> sidebarMenus = [
  Menu(
    title: "Home",
    index: 0,
    rive: RiveModel(
        src: "assets/RiveAssets/icons.riv",
        artboard: "HOME",
        stateMachineName: "HOME_interactivity"),
    onPressed: (context) {
      Navigator.pushNamed(context, '/home');
    },
  ),
  Menu(
    title: "Profile",
    index: 1,
    rive: RiveModel(
        src: "assets/RiveAssets/animated-icons.riv",
        artboard: "USER",
        stateMachineName: "USER_Interactivity"),
    onPressed: (context) {
      Navigator.pushNamed(context, '/profile');
    },
  ),
  // Menu(
  //   title: "Settings",
  //   index: 2,
  //   rive: RiveModel(
  //       src: "assets/RiveAssets/animated-icons.riv",
  //       artboard: "SETTINGS",
  //       stateMachineName: "SETTINGS_Interactivity"),
  //   onPressed: (context) {
  //     Navigator.pushNamed(context, '/settings');
  //   },
  // ),
];
List<Menu> sidebarMenus2 = [
  Menu(
    title: "History",
    index: 2,
    rive: RiveModel(
        src: "assets/RiveAssets/icons.riv",
        artboard: "TIMER",
        stateMachineName: "TIMER_Interactivity"),
    onPressed: (context) {
      Navigator.pushNamed(context, '/history');
    },
  ),
  Menu(
    title: "Notifications",
    index: 3,
    rive: RiveModel(
        src: "assets/RiveAssets/icons.riv",
        artboard: "BELL",
        stateMachineName: "BELL_Interactivity"),
    onPressed: (context) {},
  ),
];

// List<Menu> bottomNavItems = [
//   Menu(
//     title: "Timer",
//     rive: RiveModel(
//         src: "assets/RiveAssets/icons.riv",
//         artboard: "TIMER",
//         stateMachineName: "TIMER_Interactivity"),
//     onPressed: (context) {},
//   ),
//   Menu(
//     title: "Notification",
//     rive: RiveModel(
//         src: "assets/RiveAssets/icons.riv",
//         artboard: "BELL",
//         stateMachineName: "BELL_Interactivity"),
//     onPressed: (context) {},
//   ),
//   Menu(
//     title: "Profile",
//     rive: RiveModel(
//         src: "assets/RiveAssets/icons.riv",
//         artboard: "USER",
//         stateMachineName: "USER_Interactivity"),
//     onPressed: (context) {
//       Navigator.pushNamed(context, '/profile');
//     },
//   ),
// ];
