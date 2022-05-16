import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';
import '../size_config.dart';

class SocialButton extends StatelessWidget {
  const SocialButton(
      {Key? key, required this.text, required this.press, required this.svg})
      : super(key: key);
  final String svg;
  final String text;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    Orientation _orientation = MediaQuery.of(context).orientation;
    Size _size = MediaQuery.of(context).size;
    return TextButton(
      style: TextButton.styleFrom(
          primary: Colors.black,
          backgroundColor: kLightColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          )),
      onPressed: press,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
            vertical: getProportionateScreenHeight(4)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              svg,
              height: kPhoneBreakpoint > _size.width
                    ? getProportionateScreenHeight(25)
                    : _orientation == Orientation.portrait
                        ? getProportionateScreenHeight(30)
                        : getProportionateScreenHeight(40),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(10),
                  vertical: getProportionateScreenHeight(6)),
              child: Text(
                text,
                style: TextStyle(
                fontSize: kPhoneBreakpoint > _size.width
                    ? getProportionateScreenWidth(kPhoneFontSizeSocialButton)
                    : _orientation == Orientation.portrait
                        ? getProportionateScreenWidth(kTabletPortraitFontSizeSocialButton)
                        : getProportionateScreenWidth(kTabletLandscapeFontSizeSocialButton),
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: kTextColor,
                  // height: getProportionateScreenHeight(1.4),
                  // fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
