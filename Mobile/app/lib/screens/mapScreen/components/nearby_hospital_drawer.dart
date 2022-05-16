import 'dart:convert';
import 'package:app/constants.dart';
import 'package:app/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../components/default_button.dart';
import 'package:http/http.dart' as http;

import '../../search/search_screen.dart';

class NearbyHospitalDrawer extends StatefulWidget {
  const NearbyHospitalDrawer({
    Key? key,
    required this.idleLocation,
    required this.currentLocationString,
    required this.ambulanceType,
    required this.ambulances,
    required this.changeActiveIndex,
    required this.chosenNearbyHospital,
    required this.checkIfNearbyHospitalIsChosen,
    required this.checkIfActiveIndex,
  }) : super(key: key);

  final LatLng idleLocation;
  final String currentLocationString;
  final int ambulanceType;
  final List<dynamic> ambulances;
  final Function changeActiveIndex;
  final Function chosenNearbyHospital;
  final Function checkIfNearbyHospitalIsChosen;
  final Function checkIfActiveIndex;

  @override
  State<NearbyHospitalDrawer> createState() => _NearbyHospitalDrawerState();
}

class _NearbyHospitalDrawerState extends State<NearbyHospitalDrawer> {
  bool flag = false;

  var nearbyHospitals = [];
  List<Map> options = [];

  void setNearbyHospitals() async {
    try {
      String url =
          'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${widget.idleLocation.latitude},${widget.idleLocation.longitude}&radius=10000&type=hospital&key=${dotenv.env['GOOGLE_CLOUD_API_KEY'] as String}';
      var response = await http.get(Uri.parse(url));
      var jsonResponse = json.decode(response.body);
      var nearbyHospitalsList = jsonResponse['results'];
      var newNearbyHospitals = [];
      String latlng = "";
      // print(nearbyHospitalsList);
      for (var i = 0; i < nearbyHospitalsList.length; i++) {
        var hospital = nearbyHospitalsList[i];
        if (hospital['business_status'] == 'OPERATIONAL') {
          double lat = hospital['geometry']['location']['lat'];
          double lng = hospital['geometry']['location']['lng'];
          if (i == nearbyHospitalsList.length - 1) {
            latlng += '$lat,$lng';
          } else {
            latlng += '$lat,$lng|';
          }
          // String urlDistance =
          //     'https://maps.googleapis.com/maps/api/distancematrix/json?destinations=$latlng&mode=driving&origins=${widget.idleLocation.latitude},${widget.idleLocation.longitude}&key=${dotenv.env['GOOGLE_CLOUD_API_KEY'] as String}';
          // var response = await http.get(Uri.parse(urlDistance));
          // var jsonResponse = json.decode(response.body);
          // var distance =
          //     jsonResponse['rows'][0]['elements'][0]['distance']['text'];
          // int distanceInMeters =
          //     jsonResponse['rows'][0]['elements'][0]['distance']['value'];
          // var duration =
          //     jsonResponse['rows'][0]['elements'][0]['duration']['text'];
          // int durationInSeconds =
          //     jsonResponse['rows'][0]['elements'][0]['duration']['value'];
          // double distanceInKm = distanceInMeters / 1000;
          // double durationInMinutes = durationInSeconds / 60;
          // distanceInKm = double.parse(distanceInKm.toStringAsFixed(2));
          // durationInMinutes = double.parse(durationInMinutes.toStringAsFixed(1));
          var newHospital = {
            'name': hospital['name'],
            'vicinity': hospital['vicinity'],
            'geometry': hospital['geometry'],
            'place_id': hospital['place_id'],
            'types': hospital['types'],
            // 'distance': distance,
            // 'distanceInKM': distanceInKm,
            // 'duration': duration,
            // 'durationInMinutes': durationInMinutes,
          };
          print(newHospital);
          newNearbyHospitals.add(newHospital);
        }
      }
      String urlDistance =
          'https://maps.googleapis.com/maps/api/distancematrix/json?destinations=$latlng&mode=driving&origins=${widget.idleLocation.latitude},${widget.idleLocation.longitude}&key=${dotenv.env['GOOGLE_CLOUD_API_KEY'] as String}';
      var distanceMatrixResponse = await http.get(Uri.parse(urlDistance));
      var distanceMatrixJsonResponse = json.decode(distanceMatrixResponse.body);
      var distanceMatrixRows = distanceMatrixJsonResponse['rows'];
      for (var i = 0; i < distanceMatrixRows[0]['elements'].length; i++) {
        var row = distanceMatrixRows[0]['elements'][i];
        var distance = row['distance']['text'];
        int distanceInMeters = row['distance']['value'];
        var duration = row['duration']['text'];
        int durationInSeconds = row['duration']['value'];
        double distanceInKm = distanceInMeters / 1000;
        double durationInMinutes = durationInSeconds / 60;
        distanceInKm = double.parse(distanceInKm.toStringAsFixed(2));
        durationInMinutes = double.parse(durationInMinutes.toStringAsFixed(1));
        newNearbyHospitals[i]['distance'] = distance;
        newNearbyHospitals[i]['distanceInKM'] = distanceInKm;
        newNearbyHospitals[i]['duration'] = duration;
        newNearbyHospitals[i]['durationInMinutes'] = durationInMinutes;
        // print(newNearbyHospitals[i]);
      }
      newNearbyHospitals
          .sort((a, b) => a['distanceInKM'].compareTo(b['distanceInKM']));
      widget.chosenNearbyHospital(0, newNearbyHospitals[0]);
      setState(() {
        nearbyHospitals = newNearbyHospitals;
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    if (widget.checkIfActiveIndex() && flag == false) {
      setState(() {
        flag = true;
      });
      setNearbyHospitals();
    }
    return DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.6,
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
                        Flexible(
                          child: Text(
                            widget.ambulances[widget.ambulanceType]['name'],
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
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20),
                  ),
                  child: searchTextFormField([], []),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(20),
                    ),
                    child: nearbyHospitals.isEmpty ? const Center(
                      child: CircularProgressIndicator(),
                    ): ListView.builder(
                        controller: scrollController,
                        itemCount: nearbyHospitals.length,
                        itemBuilder: (_, i) => GestureDetector(
                              onTap: () {
                                widget.chosenNearbyHospital(
                                    i, nearbyHospitals[i]);
                                // if (globals.selectedIndexAddresses == i) {
                                //   setState(() {
                                //     globals.selectedIndexAddresses = -1;
                                //   });
                                // } else {
                                //   setState(() {
                                //     globals.selectedIndexAddresses = i;
                                //   });
                                // widget.changeCameraPositionIndex(i);
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
                                    color:
                                        widget.checkIfNearbyHospitalIsChosen(i)
                                            ? kPrimaryColor
                                            : Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: Row(children: [
                                  Expanded(
                                      flex: 3,
                                      child: ListTile(
                                        title: Text(
                                          nearbyHospitals[i]['name'],
                                          style: TextStyle(
                                            fontFamily: GoogleFonts.poppins()
                                                .fontFamily,
                                            color: kPrimaryColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        subtitle: Text(
                                          nearbyHospitals[i]['vicinity'],
                                          style: TextStyle(
                                            fontFamily: GoogleFonts.poppins()
                                                .fontFamily,
                                            color: Colors.black,
                                          ),
                                        ),
                                      )),
                                  Expanded(
                                      child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical:
                                                getProportionateScreenHeight(5),
                                            horizontal:
                                                getProportionateScreenWidth(
                                                    10)),
                                        decoration: BoxDecoration(
                                          color: kSecondaryColor,
                                          borderRadius: BorderRadius.circular(
                                              getProportionateScreenWidth(10)),
                                        ),
                                        child: Text(
                                            '${nearbyHospitals[i]['distanceInKM']} KM',
                                            style: TextStyle(
                                              fontFamily: GoogleFonts.poppins()
                                                  .fontFamily,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            )),
                                      ),
                                      SizedBox(
                                        height: getProportionateScreenHeight(5),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical:
                                                getProportionateScreenHeight(5),
                                            horizontal:
                                                getProportionateScreenWidth(
                                                    10)),
                                        decoration: BoxDecoration(
                                          color: kSecondaryColor,
                                          borderRadius: BorderRadius.circular(
                                              getProportionateScreenWidth(10)),
                                        ),
                                        child: Text(
                                            '${nearbyHospitals[i]['durationInMinutes']} MIN',
                                            style: TextStyle(
                                              fontFamily: GoogleFonts.poppins()
                                                  .fontFamily,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            )),
                                      ),
                                    ],
                                  ))
                                  // Expanded(child: child),
                                ]),
                                // child: ListTile(
                                //   title: Text(
                                //     nearbyHospitals[i]['name'],
                                //     style: TextStyle(
                                //       fontFamily:
                                //           GoogleFonts.poppins().fontFamily,
                                //       color: kPrimaryColor,
                                //       fontWeight: FontWeight.w600,
                                //     ),
                                //   ),
                                //   subtitle: Text(
                                //     nearbyHospitals[i]['vicinity'],
                                //     style: TextStyle(
                                //       fontFamily:
                                //           GoogleFonts.poppins().fontFamily,
                                //       color: Colors.black,
                                //     ),
                                //   ),
                                // ),
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
                    text: "Confirm",
                    press: () {
                      setState(() {
                        widget.changeActiveIndex(3);
                      });
                    },
                  ),
                )
              ],
            ),
          );
        });
  }

  TextFormField searchTextFormField(
      List<String> options, List<String> chosenOptions) {
    Orientation _orientation = MediaQuery.of(context).orientation;
    Size _size = MediaQuery.of(context).size;
    return TextFormField(
      onTap: () async {
        final chosenOptionsNew = await Navigator.pushNamed(
            context, SearchScreen.routeName,
            arguments: {
              'searchOptions': options,
              'chosenOptions': [],
              'searchType': 'nearbyHospitals',
            });
        setState(() {
          // if (chosenOptionsNew != null) {
          //   chosenMedicalConditons = chosenOptionsNew as List<String>;
          // }
        });
      },
      cursorColor: kTextColor,
      textCapitalization: TextCapitalization.words,
      readOnly: true,
      style: TextStyle(
        fontFamily: GoogleFonts.poppins().fontFamily,
        fontWeight: FontWeight.w300,
        color: Colors.black,
        fontSize: kPhoneBreakpoint > _size.width
            ? getProportionateScreenWidth(kPhoneFontSizeFieldValue)
            : _orientation == Orientation.portrait
                ? getProportionateScreenWidth(kTabletPortraitFontSizeFieldValue)
                : getProportionateScreenWidth(
                    kTabletLandscapeFontSizeFieldValue),
      ),
      decoration: InputDecoration(
        hintText: "Search",
        hintStyle: TextStyle(
          fontFamily: GoogleFonts.poppins().fontFamily,
          fontWeight: FontWeight.w300,
          color: kTextColor,
          fontSize: kPhoneBreakpoint > _size.width
              ? getProportionateScreenWidth(kPhoneFontSizeFieldLabel)
              : _orientation == Orientation.portrait
                  ? getProportionateScreenWidth(
                      kTabletPortraitFontSizeFieldLabel)
                  : getProportionateScreenWidth(
                      kTabletLandscapeFontSizeFieldLabel),
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: kPhoneBreakpoint > _size.width
                ? BorderRadius.circular(15)
                : _orientation == Orientation.portrait
                    ? BorderRadius.circular(20)
                    : BorderRadius.circular(25),
            borderSide: const BorderSide(color: kLightColor),
            gapPadding: 10),
        focusedBorder: OutlineInputBorder(
            borderRadius: kPhoneBreakpoint > _size.width
                ? BorderRadius.circular(15)
                : _orientation == Orientation.portrait
                    ? BorderRadius.circular(20)
                    : BorderRadius.circular(25),
            borderSide: const BorderSide(color: kTextColor),
            gapPadding: 10),
        contentPadding: EdgeInsets.symmetric(
          horizontal: kPhoneBreakpoint > _size.width
              ? getProportionateScreenWidth(20)
              : _orientation == Orientation.portrait
                  ? getProportionateScreenWidth(20)
                  : getProportionateScreenWidth(15),
          vertical: kPhoneBreakpoint > _size.width
              ? getProportionateScreenHeight(20)
              : _orientation == Orientation.portrait
                  ? getProportionateScreenHeight(20)
                  : getProportionateScreenHeight(20),
        ),
        labelStyle: TextStyle(
            color: kTextColor,
            fontWeight: FontWeight.w400,
            fontSize: kPhoneBreakpoint > _size.width
                ? getProportionateScreenWidth(kPhoneFontSizeFieldLabel)
                : _orientation == Orientation.portrait
                    ? getProportionateScreenWidth(
                        kTabletPortraitFontSizeFieldLabel)
                    : getProportionateScreenWidth(
                        kTabletLandscapeFontSizeFieldLabel)),
      ),
    );
  }
}
