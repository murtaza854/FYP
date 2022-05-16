import 'package:flutter/material.dart';

import '../constants.dart';
import '../size_config.dart';

class TitleCustom extends StatelessWidget {
  final String text;
  final Color color;

  const TitleCustom({Key? key, required this.text, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    Orientation _orientation = MediaQuery.of(context).orientation;
    return Text(
      text,
      style: TextStyle(
          fontSize: kPhoneBreakpoint > _size.width
              ? getProportionateScreenWidth(kPhoneFontSizeTitle)
              : _orientation == Orientation.portrait
                  ? getProportionateScreenWidth(kTabletPortraitFontSizeTitle)
                  : getProportionateScreenWidth(kTabletLandscapeFontSizeTitle),
          fontWeight: FontWeight.w600,
          color: color),
    );
  }
}
