import 'package:app/responsive.dart';
import 'package:flutter/material.dart';

import 'components/mobile_medical_card_setup1.dart';
import 'components/tablet_medical_card_setup1.dart';

class MedicalCardSetup extends StatelessWidget {
  static String routeName = "/medicalCardSetup";
  const MedicalCardSetup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Responsive(
      mobile: MobileMedicalCardSetup1(),
      tablet: TabletMedicalCardSetup1(),
    );
  }
}