import 'package:app/responsive.dart';
import 'package:flutter/material.dart';

import 'components/mobile_requests_screen.dart';

class RequestsScreen extends StatelessWidget {
  static String routeName = '/requests';
  const RequestsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Responsive(
            mobile: const MobileRequestsScreen(), tablet: Container()));
  }
}
