// import 'package:flutter/material.dart';
// import 'package:rive/rive.dart';

// import '../../../Design/menu.dart';
// import 'animated_bar.dart';

// class BtmNavItem extends StatelessWidget {
//   const BtmNavItem({
//     super.key,
//     required this.navBar,
//     required this.press,
//     required this.riveOnInit,
//     required this.selectedNav,
//   });

//   final Menu navBar;
//   final VoidCallback press;
//   final ValueChanged<Artboard> riveOnInit;
//   final Menu selectedNav;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         // Navigate to the corresponding screen when the bottom navigation item is tapped
//         switch (navBar.title) {
//           case 'Timer':
//             Navigator.pushNamed(context, '/timer');
//             break;
//           case 'Notification':
//             Navigator.pushNamed(context, '/notification');
//             break;
//           case 'Profile':
//             Navigator.pushNamed(context, '/profile');
//             break;
//           default:
//             // Do nothing if no specific screen is associated with the navigation item
//             break;
//         }
//       },
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           AnimatedBar(isActive: selectedNav == navBar),
//           SizedBox(
//             height: 36,
//             width: 36,
//             child: Opacity(
//               opacity: selectedNav == navBar ? 1 : 0.5,
//               child: RiveAnimation.asset(
//                 navBar.rive.src,
//                 artboard: navBar.rive.artboard,
//                 onInit: riveOnInit,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
