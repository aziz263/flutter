import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rive/rive.dart';
import 'package:sagem/screens/authentification/custom_reset_password.dart';
import 'package:sagem/screens/authentification/reset_controller.dart';

import '../../firebase_service.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool isShowLoading = false;
  bool isShowConfetti = false;

  late SMITrigger check;
  late SMITrigger error;
  late SMITrigger confetti;
  late StateMachineController controller;
  Notif notif = Notif();

  @override
  void initState() {
    super.initState();
  }
  

  String? validateEmail(String? value) {
    if (value!.isEmpty) {
      return "Please enter your email";
    }
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value.trim())) {
    return "Please enter a valid email address";
  }
    return null;
  }

  void sendVerificationCode(String email) async {
    final cntrl = ResetController();
    final response = await cntrl.sendVereficationCode(email);
    if (response.statusCode >= 200 && response.statusCode <= 399) {
      
      customResetDialog(context, onClosed: (_) {});
      final snackBar = SnackBar(
        duration: const Duration(seconds: 2),
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Success',
          message: "Verfication Code sent successfully",
          contentType: ContentType.success,
        ),
      );
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    } else {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Fail',
          message: "An error has occured ${response.statusCode}",
          contentType: ContentType.failure,
        ),
      );
      Navigator.popUntil(context, (route) => route.isFirst);
     
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                      padding: const EdgeInsets.only(top: 2.0,left: 2.0,right: 2.0),
                      child: Image.asset(
                        "assets/icons/verif.png",
                        width:900.0,
                        height:200.0,
                      ),
                    ),
                const Text(
                  "Email",
                  style: TextStyle(color: Colors.black54),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3.0, bottom: 6),
                  child: TextFormField(
                    controller: _emailController,
                    validator: validateEmail,
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: SvgPicture.asset("assets/icons/email.svg"),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0, bottom: 20.0),
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        sendVerificationCode(_emailController.text);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 69, 152, 197),
                      minimumSize: const Size(double.infinity, 56),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                          bottomLeft: Radius.circular(25),
                        ),
                      ),
                    ),
                    icon: const Icon(
                      CupertinoIcons.arrow_right,
                      color: Color.fromARGB(255, 239, 239, 239),
                    ),
                    label: const Text("Send verification code",
                        style: TextStyle(
                            color: Color.fromARGB(255, 239, 239, 239))),
                  ),
                ),
              ],
            ),
          ),
          isShowLoading
              ? CustomPositioned(
                  child: RiveAnimation.asset(
                    "assets/RiveAssets/check.riv",
                    onInit: (artboard) {
                      controller = StateMachineController.fromArtboard(
                          artboard, "State Machine 1")!;
                      artboard.addController(controller);
                      check = controller.findSMI("Check") as SMITrigger;
                      error = controller.findSMI("Error") as SMITrigger;
                    },
                  ),
                )
              : const SizedBox(),
          isShowConfetti
              ? CustomPositioned(
                  child: Transform.scale(
                    scale: 6,
                    child: RiveAnimation.asset(
                      "assets/RiveAssets/confetti.riv",
                      onInit: (artboard) {
                        confetti = controller.findSMI("Trigger explosion")
                            as SMITrigger;
                      },
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    
    
  }
}

class CustomPositioned extends StatelessWidget {
  const CustomPositioned({super.key, required this.child, this.size = 100});
  final Widget child;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Column(
        children: [
          const Spacer(),
          SizedBox(
            height: size,
            width: size,
            child: child,
          ),
          const Spacer(flex: 4),
        ],
      ),
    );
  }
}
