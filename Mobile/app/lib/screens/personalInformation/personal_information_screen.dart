import 'package:app/responsive.dart';
import 'package:app/screens/personalInformation/components/mobile_personal_information_screen.dart';
import 'package:flutter/material.dart';

class PersonalInformationScreen extends StatelessWidget {
  static String routeName = "/personalInformation";
  const PersonalInformationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: const MobilePersonalInformationScreen(),
      tablet: Container(),
    );
  }
}