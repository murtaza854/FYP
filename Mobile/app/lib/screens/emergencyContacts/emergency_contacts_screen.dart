import 'package:app/responsive.dart';
import 'package:flutter/material.dart';

import 'components/mobile_emergency_contacts.dart';

class EmergencyContactsScreen extends StatefulWidget {
  const EmergencyContactsScreen({Key? key}) : super(key: key);

  @override
  State<EmergencyContactsScreen> createState() => _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: const MobileEmergencyContactsScreen(),
      tablet: Container(),
    );
  }
}