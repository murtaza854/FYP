import 'package:app/responsive.dart';
import 'package:flutter/material.dart';

import 'components/mobile_addressess_screen.dart';

class AddressessScreen extends StatelessWidget {
  static const routeName = '/addressess';
  const AddressessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: MobileAddressessScreen(),
      tablet: Container(),
    );
  }
}