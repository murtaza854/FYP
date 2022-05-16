import 'package:app/screens/mapsTracking/components/body.dart';
import 'package:flutter/material.dart';

class MapsTracking extends StatelessWidget {
  static const routeName = '/map-tracking';
  const MapsTracking({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Body(),
    );
  }
}