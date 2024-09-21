// entrypoint.dart

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:sagem/screens/entryPoint/disable_back.dart';

import '../../Design/menu.dart';
import '../../constants.dart';
import 'components/menu_btn.dart';
import 'components/side_bar.dart';

class EntryPoint extends StatefulWidget {
  final Widget content;
  final int selected;

  const EntryPoint({super.key, required this.content, required this.selected});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint>
    with SingleTickerProviderStateMixin {
  bool isSideBarOpen = false;
  late SMIBool isMenuOpenInput;
  late AnimationController _animationController;
  late Animation<double> scalAnimation;
  late Animation<double> animation;
  Menu selectedMenu = sidebarMenus.first;

  void updateSelectedMenuItem(Menu menu) {
    setState(() {
      selectedMenu = menu;
    });
  }

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addListener(() {
        setState(() {});
      });

    scalAnimation = Tween<double>(begin: 1, end: 0.8).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastOutSlowIn,
      ),
    );

    animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastOutSlowIn,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void toggleSideBar() {
    isMenuOpenInput.value = !isMenuOpenInput.value;
    if (_animationController.value == 0) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    setState(() {
      isSideBarOpen = !isSideBarOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //key:,
      extendBody: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor2,
      body: DisableBackButtonWidget(
        child: Stack(
          children: [
            AnimatedPositioned(
              width: 288,
              height: MediaQuery.of(context).size.height,
              duration: const Duration(milliseconds: 200),
              curve: Curves.fastOutSlowIn,
              left: isSideBarOpen ? 0 : -288,
              top: 0,
              child: SideBar(
                selectedIndex: widget.selected,
                updateSelectedMenuItem: updateSelectedMenuItem,
                selectedMenu: selectedMenu,
              ),
            ),
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(
                  1 * animation.value - 30 * (animation.value) * pi / 180,
                ),
              child: Transform.translate(
                offset: Offset(animation.value * 265, 0),
                child: Transform.scale(
                  scale: scalAnimation.value,
                  child: widget.content,
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.fastOutSlowIn,
              left: isSideBarOpen ? 220 : 0,
              top: 16,
              child: MenuBtn(
                press: toggleSideBar,
                riveOnInit: (artboard) {
                  final controller = StateMachineController.fromArtboard(
                    artboard,
                    "State Machine",
                  );
                  artboard.addController(controller!);
                  isMenuOpenInput =
                      controller.findInput<bool>("isOpen") as SMIBool;
                  isMenuOpenInput.value = true;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
