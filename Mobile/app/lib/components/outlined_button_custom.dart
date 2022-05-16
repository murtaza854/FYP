import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class OutlinedButtonCustom extends StatelessWidget {
  const OutlinedButtonCustom({
    Key? key,
    required this.text,
    required this.press,
    this.mobileWidth,
    this.tabletLandscapeWidth,
    this.tabletPortraitWidth,
    this.icon,
  }) : super(key: key);
  final String text;
  final VoidCallback press;
  final double? mobileWidth;
  final double? tabletLandscapeWidth;
  final double? tabletPortraitWidth;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    Orientation _orientation = MediaQuery.of(context).orientation;
    Size _size = MediaQuery.of(context).size;
    return OutlinedButton(
        onPressed: press,
        style: OutlinedButton.styleFrom(
            primary: Colors.black,
            side: const BorderSide(
              color: kPrimaryColor,
              width: 2,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            )),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
          ),
          child: Container(
            width: kPhoneBreakpoint > _size.width
                ? getProportionateScreenWidth(mobileWidth ?? 280)
                : _orientation == Orientation.portrait
                    ? getProportionateScreenWidth(tabletPortraitWidth ?? 130)
                    : getProportionateScreenWidth(tabletLandscapeWidth ?? 100),
            // width: _orientation == Orientation.portrait
            //     ? getProportionateScreenWidth(200)
            //     : getProportionateScreenWidth(100),
            alignment: Alignment.center,
            child: icon != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        text,
                        // textAlign: TextAlign.center,
                        style: TextStyle(
                          // fontSize: getProportionateScreenWidth(26),
                          fontSize: kPhoneBreakpoint > _size.width
                              ? getProportionateScreenWidth(
                                  kPhoneFontSizeDefaultButton)
                              : _orientation == Orientation.portrait
                                  ? getProportionateScreenWidth(
                                      kTabletPortraitFontSizeDefaultButton)
                                  : getProportionateScreenWidth(
                                      kTabletLandscapeFontSizeDefaultButton),
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          color: kPrimaryColor,
                          // height: getProportionateScreenHeight(1.4),
                        ),
                      ),
                      SizedBox(
                        width: getProportionateScreenWidth(3),
                      ),
                      Icon(
                        icon!,
                        size: kPhoneBreakpoint > _size.width
                            ? getProportionateScreenWidth(kPhoneIconWidthSize)
                            : _orientation == Orientation.portrait
                                ? getProportionateScreenWidth(
                                    kTabletPortraitIconWidthSize)
                                : getProportionateScreenWidth(
                                    kTabletLandscapeIconWidthSize),
                        color: kPrimaryColor,
                      ),
                    ],
                  )
                : Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      // fontSize: getProportionateScreenWidth(26),
                      fontSize: kPhoneBreakpoint > _size.width
                          ? getProportionateScreenWidth(
                              kPhoneFontSizeDefaultButton)
                          : _orientation == Orientation.portrait
                              ? getProportionateScreenWidth(
                                  kTabletPortraitFontSizeDefaultButton)
                              : getProportionateScreenWidth(
                                  kTabletLandscapeFontSizeDefaultButton),
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      color: kPrimaryColor,
                      // height: getProportionateScreenHeight(1.4),
                    ),
                  ),
          ),
        ));
  }
}
