import 'package:app/constants.dart';
import 'package:app/size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../components/default_button.dart';

class SearchDrawer extends StatefulWidget {
  SearchDrawer({
    Key? key,
    required this.chosenOptions,
  }) : super(key: key);
  final List<String> chosenOptions;

  @override
  State<SearchDrawer> createState() => _SearchDrawerState();
}

class _SearchDrawerState extends State<SearchDrawer> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.5,
        maxChildSize: 0.5,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                )),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(140),
                    vertical: getProportionateScreenHeight(20),
                  ),
                  child: Container(
                      height: getProportionateScreenHeight(5),
                      decoration: BoxDecoration(
                        color: kTextColor,
                        borderRadius: BorderRadius.circular(50),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: getProportionateScreenWidth(10),
                    bottom: getProportionateScreenWidth(0),
                    left: getProportionateScreenWidth(20),
                    right: getProportionateScreenWidth(20),
                    // vertical: getProportionateScreenWidth(5),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: Row(
                      children: [
                        SizedBox(
                          width: getProportionateScreenWidth(10),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: getProportionateScreenWidth(0),
                    bottom: getProportionateScreenWidth(0),
                    left: getProportionateScreenWidth(20),
                    right: getProportionateScreenWidth(20),
                    // vertical: getProportionateScreenWidth(5),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: Row(
                      children: [
                        Icon(
                          Icons.local_hospital_outlined,
                          color: kErrorColor,
                          size: getProportionateScreenWidth(40),
                        ),
                        SizedBox(
                          width: getProportionateScreenWidth(10),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: getProportionateScreenWidth(0),
                    bottom: getProportionateScreenWidth(20),
                    left: getProportionateScreenWidth(20),
                    right: getProportionateScreenWidth(20),
                    // vertical: getProportionateScreenWidth(5),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: Row(
                      children: [
                        SizedBox(
                          width: getProportionateScreenWidth(10),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(50),
                    vertical: getProportionateScreenWidth(20),
                  ),
                  child: DefaultButton(
                    text: "Tezz",
                    press: () {
                      setState(() {
                        // widget.changeActiveIndex(3);
                      });
                    },
                  ),
                )
              ],
            ),
          );
        });
  }
}
