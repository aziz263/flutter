import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import '../../models/magasinier.dart';
import '../authentification/custom_sign_in.dart';
import '../authentification/sign_up_form.dart';
import 'animated_btn.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required SignUpForm child});

  @override
  State<OnboardingScreen> createState() => OnboardingScreenState();
}

class OnboardingScreenWrapper extends StatefulWidget {
  const OnboardingScreenWrapper({super.key});

  @override
  OnboardingScreenWrapperState createState() =>
      OnboardingScreenWrapperState();
}

class OnboardingScreenWrapperState extends State<OnboardingScreenWrapper> {
  late Magasinier magasinier;

  @override
  void initState() {
    super.initState();
    magasinier = const Magasinier(
      idmagasinier: 0,
      nom: '',
      prenom: '',
      mail: '',
      password: '',
      age: 0,
      adminRole: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const OnboardingScreen(
      child: SignUpForm(),
    );
  }
}

class OnboardingScreenState extends State<OnboardingScreen> {
  bool isSignInDialogShown = false;
  late RiveAnimationController _btnAnimationController;

  @override
  void initState() {
    _btnAnimationController = OneShotAnimation("active", autoplay: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            width: MediaQuery.of(context).size.width * 1.7,
            bottom: 270,
            right: -70,
            child: Image.asset('assets/Backgrounds/Spline.png'),
          ),
          // Positioned.fill(
          //   child: BackdropFilter(
          //     filter: ImageFilter.blur(sigmaX: 20, sigmaY: 10),
          //   ),
          // ),
          // const RiveAnimation.asset('assets/Backgrounds/Spline.png'),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 10),
              child: const SizedBox(),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 240),
            top: isSignInDialogShown ? -50 : 0,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    const SizedBox(
                      width: 260,
                      child: Column(
                        children: [
                          Text(
                            "Welcome to Sagemcom",
                            style: TextStyle(
                              fontSize: 36,
                              fontFamily: "Poppins",
                              height: 1.2,
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(
                      flex: 2,
                    ),
                    AnimatedBtn(
                      btnAnimationController: _btnAnimationController,
                      press: () {
                        _btnAnimationController.isActive = true;
                        Future.delayed(const Duration(milliseconds: 50), () {
                          setState(() {
                            isSignInDialogShown = true;
                          });
                          customSigninDialog(context, onClosed: (_) {
                            setState(() {
                              isSignInDialogShown = false;
                            });
                          });
                        });
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.0),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
