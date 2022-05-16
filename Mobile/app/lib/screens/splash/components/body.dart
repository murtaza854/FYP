import 'package:flutter/material.dart';

import '../../../constants.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: kPrimaryGradientColor),
      child: Scaffold(
          // By defaut, Scaffold background is white
          // Set its value to transparent
          backgroundColor: Colors.transparent,
          body: Center(
            child: Image.asset(
              'assets/images/tezz_logo-white.png',
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.5,
            ),
          )),
    );
  }
}

// Container(
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topRight,
//           end: Alignment.bottomLeft,
//           colors: <Color>[
//             Color(0xFF39B54A),
//             Color(0xFF00A99D),
//           ],
//         ),
//       ),
//     );

// SafeArea(
//         child: Column(
//       children: <Widget>[
//         Expanded(
//             child: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topRight,
//               end: Alignment.bottomLeft,
//               colors: [
//                 Color(0xFF39B54A),
//                 Color(0xFF00A99D),
//               ],
//             ),
//           ),
//         )
//         ),
//       ],
//     ));
