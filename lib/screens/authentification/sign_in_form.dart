  import 'dart:convert';
  import 'dart:developer';

  import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
  import 'package:firebase_messaging/firebase_messaging.dart';
  import 'package:flutter/cupertino.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter_svg/svg.dart';
  import 'package:http/http.dart' as http;
  import 'package:rive/rive.dart';
  import 'package:shared_preferences/shared_preferences.dart';

  import '../../constants.dart';
  import '../../firebase_service.dart';
  import '../../models/magasinier.dart';
  import '../Magasinier_funct/magasinier_controller.dart';
  import '../entryPoint/entry_point.dart';
  import '../home/home_screen.dart';
  import 'custom_forget_password.dart';

  class SignInForm extends StatefulWidget {
    const SignInForm({super.key});

    @override
    State<SignInForm> createState() => _SignInFormState();
  }

  class _SignInFormState extends State<SignInForm> {
    late SharedPreferences prefs;
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
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
      initializeSharedPreferences();
    }

    Future<void> initializeSharedPreferences() async {
      prefs = await SharedPreferences.getInstance();
    }

    Future<Magasinier> fetchMagasinierBymail() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? mail = prefs.getString('mail');
      if (mail != null && mail.isNotEmpty) {
        try {
          final controller = MagasinierController();
          final fetchedMagasinier = await controller.getMagasinierBymail(mail);
          return fetchedMagasinier;
        } catch (e) {
          log('Error fetching magasins: $e');
          return const Magasinier(
            nom: '',
            prenom: '',
            mail: '',
            idmagasinier: 0,
            age: 0,
            password: '',
            adminRole: 0,
          );
        }
      } else {
        return const Magasinier(
          nom: '',
          prenom: '',
          mail: '',
          idmagasinier: 0,
          age: 0,
          password: '',
          adminRole: 0,
        );
      }
    }

    Future<void> signIn(
        BuildContext context, String mail, String password) async {
      setState(() {
        isShowLoading = true;
        isShowConfetti = false;
      });

      try {
        final response = await http.post(
          Uri.parse('$url/api/Magasinier/login'),
          headers: <String, String>{
            'Content-type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(<String, String>{
            'mail': mail,
            'password': password,
          }),
        );

        if (response.statusCode >= 200 && response.statusCode <= 299) {
          check.fire();
          await prefs.setString('mail', mail);
          final magasinier = await fetchMagasinierBymail();
          Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              isShowLoading = false;
              isShowConfetti = true;
            });
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EntryPoint(
                  content: HomePage(),
                  selected: 0,
                ),
              ),
            );
            final snackBar = SnackBar(
              elevation: 0,
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              content: AwesomeSnackbarContent(
                title: 'Success',
                message: 'Hello ${magasinier.nom} ${magasinier.prenom} ',
                contentType: ContentType.success,
              ),
            );

            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(snackBar);

            confetti.fire();
          });
        } else {
          error.fire();
          Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              isShowLoading = false;
            });
          });
        }
      } catch (e) {
        error.fire();

        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            isShowLoading = false;
          });
        });
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Fail',
            message: 'Failed to Sign in: $e ',
            contentType: ContentType.failure,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
        rethrow;
      }
    }

    @override
    Widget build(BuildContext context) {
      return Material(
        child: Stack(
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Email",
                    style: TextStyle(color: Colors.black54),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6, bottom: 7),
                    child: TextFormField(
                      controller: _emailController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter your email";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: SvgPicture.asset("assets/icons/email.svg"),
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    "Password",
                    style: TextStyle(color: Colors.black54),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                    child: TextFormField(
                      controller: _passwordController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter your password";
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: SvgPicture.asset("assets/icons/password.svg"),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 7),
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          signIn(context, _emailController.text,
                              _passwordController.text);
                          String? fcmToken =
                              await FirebaseMessaging.instance.getToken();
                          
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
                      label: const Text("Sign In",
                          style: TextStyle(
                              color: Color.fromARGB(255, 239, 239, 239))),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      customPasswordnDialog(context, onClosed: (_) {});
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(color: Color.fromARGB(255, 74, 157, 225)),
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
      controller.dispose();
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
