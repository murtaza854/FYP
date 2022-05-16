import 'package:app/constants.dart';
import 'package:app/size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../components/default_button.dart';
import '../../../globals.dart' as globals;

class PickupLocationDrawer extends StatefulWidget {
  const PickupLocationDrawer({
    Key? key,
    required this.idleLocation,
    required this.currentLocationString,
    required this.changeCameraPositionIndex,
    required this.changeActiveIndex,
    required this.chosenAddress,
    required this.checkIfAddressIsChosen,
  }) : super(key: key);

  final LatLng idleLocation;
  final String currentLocationString;
  final void Function(dynamic newPos) changeCameraPositionIndex;
  final Function changeActiveIndex;
  final Function chosenAddress;
  final Function checkIfAddressIsChosen;

  @override
  State<PickupLocationDrawer> createState() => _PickupLocationDrawerState();
}

class _PickupLocationDrawerState extends State<PickupLocationDrawer> {
  @override
  Widget build(BuildContext context) {
    var addresses = globals.user?.addresses ?? [];
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
                addresses.isEmpty
                    ? Column(
                        children: [
                          Text(
                            'No addresses added yet',
                            style: TextStyle(
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                fontSize: getProportionateScreenWidth(18),
                                color: kPrimaryColor),
                          ),
                          Text(
                            'Add an address to get started',
                            style: TextStyle(
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                fontSize: getProportionateScreenWidth(18),
                                color: Colors.black),
                          ),
                        ],
                      )
                    : Container(),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(20),
                    ),
                    child: ListView.builder(
                        controller: scrollController,
                        itemCount: addresses.length,
                        itemBuilder: (_, i) => GestureDetector(
                              onTap: () {
                                widget.chosenAddress(i);
                                // if (globals.selectedIndexAddresses == i) {
                                //   setState(() {
                                //     globals.selectedIndexAddresses = -1;
                                //   });
                                // } else {
                                //   setState(() {
                                //     globals.selectedIndexAddresses = i;
                                //   });
                                widget.changeCameraPositionIndex(i);
                                // }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: getProportionateScreenHeight(10),
                                  horizontal: getProportionateScreenWidth(10),
                                ),
                                margin: EdgeInsets.symmetric(
                                  vertical: getProportionateScreenHeight(4),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: kLightColor,
                                  border: Border.all(
                                    color: widget.checkIfAddressIsChosen(i)
                                        ? kPrimaryColor
                                        : Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: ListTile(
                                  title: Text(
                                    addresses[i]['label'],
                                    style: TextStyle(
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Text(
                                    addresses[i]['addressLine1'] +
                                        '\n' +
                                        addresses[i]['addressLine2'] +
                                        '\n' +
                                        // addresses[i]['city'] +
                                        '\n',
                                        // addresses[i]['state'],
                                    style: TextStyle(
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            )),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(50),
                    vertical: getProportionateScreenWidth(20),
                  ),
                  child: DefaultButton(
                    text: "Confirm Pick-Up",
                    press: () {
                      setState(() {
                        globals.scrollGesturesEnabled = false;
                        globals.zoomGesturesEnabled = false;
                        widget.changeActiveIndex(1);
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
