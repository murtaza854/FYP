import 'package:app/size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants.dart';

class OnboardingContent extends StatelessWidget {
  const OnboardingContent({
    Key? key,
    required this.text,
    required this.image,
    required this.red,
    required this.bold,
    required this.text2,
    required this.bold2,
  }) : super(key: key);
  final String red, bold, text, bold2, text2, image;

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    Orientation _orientation = MediaQuery.of(context).orientation;
    return Column(
      children: <Widget>[
        Expanded(
            // flex: 2,
            child: Align(
          alignment: Alignment.bottomCenter,
          child: Image.asset(
                  image,
                  width: _size.width > kTabletBreakpoint
                      ? _orientation == Orientation.portrait
                          ? _size.width * 0.35
                          : _size.width * 0.25
                      : _size.width * 0.45,
                ),
          // child: _size.width > kDesktopBreakpoint
          //     ? Image.asset(
          //         image,
          //         width: _size.width * 0.2,
          //       )
          //     : _size.width > kTabletBreakpoint
          //         ? Image.asset(
          //             image,
          //             width: _orientation == Orientation.portrait
          //                 ? _size.width * 0
          //                 : _size.width * 0,
          //           )
          //         : Image.asset(
          //             image,
          //             width: _size.width * 0.45,
          //           ),
          // child: Image.asset(
          //   image,
          //    width: _size.width > kDesktopBreakpoint ? _size.width * 0.15 : _size.width > kTabletBreakpoint ? _size.width * 0.4 : _size.width * 0.45,
          //   // width: MediaQuery.of(context).size.width * 0.45,
          //   // height: MediaQuery.of(context).size.height * 0.5,
          // ),
        )),
        Expanded(
            // flex: 3,
            child: Column(
          children: <Widget>[
            SizedBox(height: getProportionateScreenHeight(30)),
            SizedBox(
              width: getProportionateScreenWidth(250),
              child: RichText(
                text: TextSpan(
                  // Note: Styles for TextSpans must be explicitly defined.
                  // Child text spans will inherit styles from parent
                  style: TextStyle(
                    // fontSize: _size.width > kDesktopBreakpoint
                    //     ? getProportionateScreenWidth(20)
                    //     : _size.width > kTabletBreakpoint
                    //         ? getProportionateScreenWidth(24)
                    //         : getProportionateScreenWidth(30),
                    fontSize: _size.width > kTabletBreakpoint
                            ? _orientation == Orientation.portrait
                                ? getProportionateScreenWidth(24)
                                : getProportionateScreenWidth(20)
                            : getProportionateScreenWidth(30),
                    // fontSize: _size.width > kTabletBreakpoint
                    //     ? _orientation == Orientation.portrait
                    //         ? _size.width * 0.35
                    //         : _size.width * 0.2
                    //     : _size.width * 0.45,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: red,
                        style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF840000))),
                    TextSpan(
                        text: bold,
                        style: const TextStyle(fontWeight: FontWeight.w900)),
                    TextSpan(text: text),
                    TextSpan(
                        text: bold2,
                        style: const TextStyle(fontWeight: FontWeight.w900)),
                    TextSpan(text: text2),
                  ],
                ),
              ),
              // child: Text(text,
              //     style: TextStyle(
              //         fontSize: MediaQuery.of(context).size.width * 0.1,
              //         fontFamily: GoogleFonts.poppins().fontFamily,
              //         fontWeight: FontWeight.bold,
              //         height: 1.2,
              //         color: Colors.black),
              //     textAlign: TextAlign.left),
            ),
          ],
        )),
      ],
    );
  }
}
