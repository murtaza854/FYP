import 'package:app/responsive.dart';
import 'package:flutter/material.dart';

import 'components/mobile_medical_card.dart';

class MedicalCardScreen extends StatefulWidget {
  static String routeName = "/medicalCard";
  MedicalCardScreen({Key? key}) : super(key: key);

  @override
  State<MedicalCardScreen> createState() => _MedicalCardScreenState();
}

class _MedicalCardScreenState extends State<MedicalCardScreen> {
  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: MobileMedicalCardScreen(),
      tablet: Container(),
    );
  }
}