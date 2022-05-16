import 'package:app/responsive.dart';
import 'package:flutter/material.dart';

import 'components/mobile_rides_screen.dart';

class RidesScreen extends StatelessWidget {
  static String routeName = '/rides';
  const RidesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Responsive(
            mobile: const MobileRidesScreen(), tablet: Container()));
  }
}
