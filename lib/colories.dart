import 'package:flutter/material.dart';

import 'background_draw.dart';

class Colorie extends StatelessWidget {
  const Colorie({super.key});

  @override
  Widget build(BuildContext context) {
    var heightOfScreen = MediaQuery.sizeOf(context).height;
    var widthOfScreen = MediaQuery.sizeOf(context).width;
    return Column(
      children: <Widget>[
        CustomPaint(
          painter: DrawCircle(
            offset: Offset(widthOfScreen * 0.2, heightOfScreen * 0.05),
            radius: widthOfScreen * 0.25,
            color: const Color(0xFF17203A),
            hasShadow: true,
            shadowColor: Colors.grey,
          ),
        ),
        CustomPaint(
          painter: DrawCircle(
            offset: Offset(widthOfScreen * 0.75, heightOfScreen * 0.05),
            radius: widthOfScreen * 0.4,
            color: const Color(0xFF17203A),
            hasShadow: true,
            shadowColor: Colors.grey,
          ),
        ),
        CustomPaint(
          painter: DrawCircle(
            offset: Offset(widthOfScreen * 0.1, heightOfScreen * 0.95),
            radius: widthOfScreen * 0.3,
            color: const Color(0xFF17203A),
            hasShadow: true,
            shadowColor: Colors.grey,
          ),
        ),
        // CustomPaint(
        //   painter: DrawCircle(
        //     offset: Offset(widthOfScreen * 0.35, heightOfScreen * 0.85),
        //     radius: widthOfScreen * 0.1,
        //     color: const Color.fromARGB(255, 46, 157, 94),
        //     hasShadow: true,
        //     shadowColor: Colors.grey,
        //   ),
        // ),
      ],
    );
  }
}

// Widget drawCircles(context) {
//   var heightOfScreen = MediaQuery.sizeOf(context).height;
//   var widthOfScreen = MediaQuery.sizeOf(context).width;

//   return Column(
//     children: <Widget>[
//       CustomPaint(
//         painter: DrawCircle(
//           offset: Offset(widthOfScreen * 0.2, heightOfScreen * 0.05),
//           radius: widthOfScreen * 0.25,
//           color: Color(0xFF17203A),
//           hasShadow: true,
//           shadowColor: Colors.grey,
//         ),
//       ),
//       CustomPaint(
//         painter: DrawCircle(
//           offset: Offset(widthOfScreen * 0.75, heightOfScreen * 0.05),
//           radius: widthOfScreen * 0.4,
//           color: Color.fromARGB(150, 0, 0, 128),
//           hasShadow: true,
//           shadowColor: Colors.grey,
//         ),
//       ),
//       CustomPaint(
//         painter: DrawCircle(
//           offset: Offset(widthOfScreen * 0.1, heightOfScreen * 0.95),
//           radius: widthOfScreen * 0.3,
//           color: Colors.grey,
//           hasShadow: true,
//           shadowColor: Colors.grey,
//         ),
//       ),
//       // CustomPaint(
//       //   painter: DrawCircle(
//       //     offset: Offset(widthOfScreen * 0.35, heightOfScreen * 0.85),
//       //     radius: widthOfScreen * 0.1,
//       //     color: const Color.fromARGB(255, 46, 157, 94),
//       //     hasShadow: true,
//       //     shadowColor: Colors.grey,
//       //   ),
//       // ),
//     ],
//   );
// }
