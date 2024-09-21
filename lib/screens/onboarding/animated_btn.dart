import 'package:flutter/cupertino.dart';
import 'package:rive/rive.dart';

class AnimatedBtn extends StatelessWidget {
  const AnimatedBtn({
    super.key,
    required RiveAnimationController btnAnimationController,
    required this.press,
    this.animationDuration = const Duration(milliseconds:5),
  })  : _btnAnimationController = btnAnimationController,
        super();

  final RiveAnimationController _btnAnimationController;
  final VoidCallback press;
  final Duration animationDuration;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _btnAnimationController.isActive = true;
        Future.delayed(animationDuration, press);
      },
      child: SizedBox(
        height: 64,
        width: 260,
        child: Stack(
          children: [
            RiveAnimation.asset(
              "assets/RiveAssets/button.riv",
              controllers: [_btnAnimationController],
            ),
            const Positioned.fill(
              top: 8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.arrow_right),
                  SizedBox(width: 8),
                  Text("Start now",style: TextStyle(fontWeight: FontWeight.w600))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
