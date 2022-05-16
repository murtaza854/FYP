import 'package:app/screens/mapScreen/components/body.dart';
import 'package:flutter/material.dart';

class MapScreen extends StatelessWidget {
  static const routeName = '/map-screen';
  const MapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Body(),
    );
  }
}