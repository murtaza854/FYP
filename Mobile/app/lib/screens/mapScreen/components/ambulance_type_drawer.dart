import 'package:app/constants.dart';
import 'package:app/size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../components/default_button.dart';
import '../../../globals.dart' as globals;

class AmbulanceTypeDrawer extends StatefulWidget {
  AmbulanceTypeDrawer({
    Key? key,
    required this.currentLocationString,
    required this.changeActiveIndex,
    required this.chosenAmbulanceType,
    required this.checkIfAmbulanceTypeChosen,
    required this.ambulances,
  }) : super(key: key);

  final String currentLocationString;
  final Function changeActiveIndex;
  final Function chosenAmbulanceType;
  final Function checkIfAmbulanceTypeChosen;
  var ambulances = [];

  @override
  State<AmbulanceTypeDrawer> createState() => _AmbulanceTypeDrawerState();
}

class _AmbulanceTypeDrawerState extends State<AmbulanceTypeDrawer> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        initialChildSize: 0.4,
        minChildSize: 0.4,
        maxChildSize: 0.7,
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
                        Icon(
                          Icons.near_me_outlined,
                          color: kPrimaryColor,
                          size: getProportionateScreenWidth(40),
                        ),
                        SizedBox(
                          width: getProportionateScreenWidth(10),
                        ),
                        Flexible(
                          child: Text(
                            widget.currentLocationString,
                            style: TextStyle(
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                fontSize: getProportionateScreenWidth(18),
                                color: kPrimaryColor),
                          ),
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
                    child: Text(
                      "Nearby Ambulances",
                      style: TextStyle(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontSize: getProportionateScreenWidth(
                              kPhoneFontSizeDefaultText),
                          color: Colors.black),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(20)
                    ),
                    child: GridView.count(
                      crossAxisCount: 2,
                      // crossAxisSpacing: 2.0,
                      mainAxisSpacing: 2.0,
                      shrinkWrap: true,
                      controller: scrollController,
                      scrollDirection: Axis.vertical,
                      // physics: const NeverScrollableScrollPhysics(),
                      children: List.generate(widget.ambulances.length, (i) {
                        return GestureDetector(
                        onTap: () {
                          widget.chosenAmbulanceType(i);
                          // if (globals.selectedIndexAddresses == i) {
                          //   setState(() {
                          //     globals.selectedIndexAddresses = -1;
                          //   });
                          // } else {
                          //   setState(() {
                          //     globals.selectedIndexAddresses = i;
                          //   });
                          //   // widget.changeCameraPositionIndex(i);
                          // }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: getProportionateScreenHeight(10),
                            horizontal: getProportionateScreenWidth(10),
                          ),
                          margin: EdgeInsets.symmetric(
                            vertical: getProportionateScreenHeight(4),
                            horizontal: getProportionateScreenWidth(4),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: kLightColor,
                            border: Border.all(
                              color: widget.checkIfAmbulanceTypeChosen(i)
                                  ? kPrimaryColor
                                  : Colors.white,
                              width: 2,
                            ),
                          ),
                          child: ListTile(
                            title: Text(
                              widget.ambulances[i]['name'] as String,
                              style: TextStyle(
                                fontFamily:
                                    GoogleFonts.poppins().fontFamily,
                                color: kPrimaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            // subtitle: Text(
                            //   addresses[i]['addressLine1'] +
                            //       '\n' +
                            //       addresses[i]['addressLine2'] +
                            //       '\n' +
                            //       addresses[i]['city'] +
                            //       '\n' +
                            //       addresses[i]['state'],
                            //   style: TextStyle(
                            //     fontFamily:
                            //         GoogleFonts.poppins().fontFamily,
                            //     color: Colors.black,
                            //   ),
                            // ),
                          ),
                        ),
                          );
                      }),
                    ),
                    // child: ListView.builder(
                    //     controller: scrollController,
                    //     itemCount: addresses!.length,
                    //     scrollDirection: Axis.vertical,
                    //     itemBuilder: (_, i) => GestureDetector(
                    //           onTap: () {
                    //             if (globals.selectedIndexAddresses == i) {
                    //               setState(() {
                    //                 globals.selectedIndexAddresses = -1;
                    //               });
                    //             } else {
                    //               setState(() {
                    //                 globals.selectedIndexAddresses = i;
                    //               });
                    //               // widget.changeCameraPositionIndex(i);
                    //             }
                    //           },
                    //           child: Container(
                    //             padding: EdgeInsets.symmetric(
                    //               vertical: getProportionateScreenHeight(10),
                    //               horizontal: getProportionateScreenWidth(10),
                    //             ),
                    //             margin: EdgeInsets.symmetric(
                    //               vertical: getProportionateScreenHeight(4),
                    //             ),
                    //             decoration: BoxDecoration(
                    //               borderRadius: BorderRadius.circular(20),
                    //               color: kLightColor,
                    //               border: Border.all(
                    //                 color: i == globals.selectedIndexAddresses
                    //                     ? kPrimaryColor
                    //                     : Colors.white,
                    //                 width: 2,
                    //               ),
                    //             ),
                    //             child: ListTile(
                    //               title: Text(
                    //                 addresses[i]['label'],
                    //                 style: TextStyle(
                    //                   fontFamily:
                    //                       GoogleFonts.poppins().fontFamily,
                    //                   color: kPrimaryColor,
                    //                   fontWeight: FontWeight.w600,
                    //                 ),
                    //               ),
                    //               subtitle: Text(
                    //                 addresses[i]['addressLine1'] +
                    //                     '\n' +
                    //                     addresses[i]['addressLine2'] +
                    //                     '\n' +
                    //                     addresses[i]['city'] +
                    //                     '\n' +
                    //                     addresses[i]['state'],
                    //                 style: TextStyle(
                    //                   fontFamily:
                    //                       GoogleFonts.poppins().fontFamily,
                    //                   color: Colors.black,
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //         )),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(50),
                    vertical: getProportionateScreenWidth(20),
                  ),
                  child: DefaultButton(
                    text: "Confirm",
                    press: () {
                      setState(() {
                        widget.changeActiveIndex(2);
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
