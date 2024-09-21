import 'package:flutter/material.dart';

class DisableBackButtonWidget extends StatelessWidget {
  final Widget child;

  const DisableBackButtonWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: child,
    );
  }
}
