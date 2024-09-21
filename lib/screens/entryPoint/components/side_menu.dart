import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import '../../../Design/menu.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    super.key,
    required this.menu,
    required this.index,
    required this.press,
    required this.riveOnInit,
    required this.selectedMenu,
  });

  final Menu menu;
  final int index;
  final VoidCallback press;
  final ValueChanged<Artboard> riveOnInit;
  final Menu selectedMenu;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 24),
          child: Divider(color: Colors.white24, height: 1),
        ),
        Stack(
          children: [
            if (index == selectedMenu.index)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.fastOutSlowIn,
                width: 288,
                height: 56,
                left: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF6792FF),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
            ListTile(
              onTap: press,
              leading: SizedBox(
                height: 36,
                width: 36,
                child: RiveAnimation.asset(
                  menu.rive.src,
                  artboard: menu.rive.artboard,
                  onInit: riveOnInit,
                ),
              ),
              title: Text(
                menu.title,
                style: TextStyle(
                  color: index == selectedMenu.index
                      ? Colors.white
                      : Colors.white70, // Update color based on index
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
