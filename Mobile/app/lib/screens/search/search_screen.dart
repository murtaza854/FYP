import 'package:app/responsive.dart';
import 'package:flutter/material.dart';

import 'components/mobile_search_screen.dart';

class SearchScreen extends StatefulWidget {
  static String routeName = "/search";
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: const MobileSearchScreen(),
      tablet: Container(),
    );
  }
}