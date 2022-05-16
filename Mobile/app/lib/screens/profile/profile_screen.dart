import 'package:app/responsive.dart';
import 'package:app/screens/profile/components/mobile_profile_screen.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: const MobileProfileScreen(),
      tablet: Container(),
    );
  }
}