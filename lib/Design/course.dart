import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/magasinier.dart';
import '../screens/Magasinier_funct/magasinier_controller.dart';

class Course {

  final String title;
  String? description;
  final Color color;
  final Function(BuildContext)? onPressed;
  final String subtitle;
  final String iconSrc;

  Course({
    required this.title,
    this.subtitle = '',
    this.description,
    required this.color,
    this.onPressed,
    this.iconSrc = '',
  });
}
  
  
 
final List<Course> courses = [
  Course(
    color: const Color.fromARGB(150, 0, 0, 128),
    title: "Magasinier of the month",
    iconSrc: "assets/icons/congrat.svg",
    description: "",
    onPressed: (context) {},
  ),
  Course(
    title: "Article of the month",
    iconSrc: "assets/icons/congrat.svg",
    color: const Color(0xFF17203A),
    onPressed: (context) {},
  ),
];

final List<Course> recentCourses = [
  Course(
    color: const Color(0xFF17203A),
    title: "PickLists",
    onPressed: (context) {
      Navigator.pushNamed(context, '/picklist');
    },
  ),
  Course(
    title: "Details PickLists",
    color: const Color(0xFF17203A),
    // iconSrc: "assets/icons/code.svg",
    onPressed: (context) {
      Navigator.pushNamed(context, '/detailpicklist');
    },
  ),
  Course(
    color: const Color(0xFF17203A),
    title: "Magasiniers",
    onPressed: (BuildContext context) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? mail = prefs.getString('mail');

      final controller = MagasinierController();
      final Magasinier magasinier = await controller.getMagasinierBymail(mail);
      if (magasinier.adminRole == 1) {
        
        Navigator.pushNamed(context, '/magasinier');
      } else {
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Warning',
            message: 'Only admins can access this',
            contentType: ContentType.warning,
          ),
        );
        

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      }
    },
  ),
  Course(
    title: "Magasins",
    color: const Color(0xFF17203A),
    // iconSrc: "assets/icons/code.svg",
    onPressed: (context) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? mail = prefs.getString('mail');

      final controller = MagasinierController();
      final Magasinier magasinier = await controller.getMagasinierBymail(mail);
      if (magasinier.adminRole == 1) {
        Navigator.pushNamed(context, '/magasin');
      } else {
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Warning',
            message: 'Only admins can access this',
            contentType: ContentType.warning,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);

      }
    },
  ),
  Course(
    title: "Articles",
    color: const Color(0xFF17203A),
    // iconSrc: "assets/icons/code.svg",
    onPressed: (context) {
      Navigator.pushNamed(context, '/article');
    }, 
  ),
  Course(
    title: "Unité De Stocks",
    color: const Color(0xFF17203A),
    // iconSrc: "assets/icons/code.svg",
    onPressed: (context) {
      Navigator.pushNamed(context, '/us');
    },
  ),
  Course(
    title: "Lignes",
    color: const Color(0xFF17203A),
    // iconSrc: "assets/icons/code.svg",
    onPressed: (context) {
      Navigator.pushNamed(context, '/ligne');
    },
  ),
];
