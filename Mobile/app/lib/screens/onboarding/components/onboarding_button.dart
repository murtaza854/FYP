import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class OnboardingButton extends StatelessWidget {
  const OnboardingButton({
    Key? key, required this.text, required this.press,
  }) : super(key: key);
  final String text;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    Orientation _orientation = MediaQuery.of(context).orientation;
    return TextButton(
        onPressed: press,
        style: TextButton.styleFrom(
          primary: Colors.transparent,
        ),
        child: Text(
          text,
          style: TextStyle(
                fontSize: kPhoneBreakpoint > _size.width
                          ? getProportionateScreenWidth(kPhoneFontSizeOnboardingButton)
                          : _orientation == Orientation.portrait
                              ? getProportionateScreenWidth(kTabletPortraitFontSizeOnboardingButton)
                              : getProportionateScreenWidth(kTabletLandscapeFontSizeOnboardingButton),
                // fontSize: _size.width > kTabletBreakpoint
                //         ? _orientation == Orientation.portrait
                //             ? getProportionateScreenWidth(20)
                //             : getProportionateScreenWidth(15)
                //         : getProportionateScreenWidth(30),
              // fontSize: _size.width > 1100 ? getProportionateScreenWidth(18) : getProportionateScreenWidth(20),
              color: kPrimaryColor,
              backgroundColor: Colors.transparent,
              fontWeight: FontWeight.bold),
        ));
  }
}