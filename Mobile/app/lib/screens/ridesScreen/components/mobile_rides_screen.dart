import 'dart:convert';

// import 'package:another_flushbar/flushbar.dart';
import 'package:app/models/user_model.dart';
import 'package:app/screens/home/home_screen.dart';
import 'package:app/screens/mapsTracking/maps_tracking.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import '../../../globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MobileRidesScreen extends StatefulWidget {
  const MobileRidesScreen({Key? key}) : super(key: key);

  @override
  State<MobileRidesScreen> createState() => _MobileRidesScreenState();
}

class _MobileRidesScreenState extends State<MobileRidesScreen> {
  List<dynamic> rides = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  // final TextEditingController _relationshipController = TextEditingController();
  CollectionReference ridesCollection =
      FirebaseFirestore.instance.collection('rides');
  CollectionReference inProgressRidesCollection =
      FirebaseFirestore.instance.collection('inProgressRides');
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      rides = globals.rides;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              'New Rides',
              style: GoogleFonts.poppins(
                  fontSize:
                      getProportionateScreenWidth(kPhoneFontSizeDefaultText),
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
            // leading: IconButton(
            //   icon: const Icon(
            //     Icons.arrow_back_ios,
            //     color: kPrimaryColor,
            //   ),
            //   onPressed: () {
            //     Navigator.pop(context, globals.requests);
            //   },
            // ),
          ),
          body: SizedBox(
            width: double.infinity,
            child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: rides.isNotEmpty
                    ? ListView.builder(
                        itemCount: rides.length,
                        itemBuilder: (context, index) {
                          return Container(
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
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            child: Row(children: [
                              Expanded(
                                flex: 4,
                                child: ListTile(
                                  title: Text(
                                    "Patient Name\n${rides[index]['patientName']}",
                                    style: TextStyle(
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "${rides[index]['chosenHospital']['name']}"
                                    '\n'
                                    "${rides[index]['chosenHospital']['vicinity']}"
                                    '\n'
                                    'Alert! An ambulance is needed! Please respond.',
                                    style: TextStyle(
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      // listDialog(context, rides[index]);
                                      acceptRequest(rides[index]);
                                    },
                                    child: const Icon(
                                      Icons.check,
                                      color: kPrimaryColor,
                                    ),
                                  ),
                                  SizedBox(
                                    width: getProportionateScreenWidth(10),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      deleteRequest(rides[index]);
                                    },
                                    child: const Icon(
                                      Icons.close,
                                      color: kErrorColor,
                                    ),
                                  )
                                ],
                              )),
                            ]),
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          'No new rides',
                          style: TextStyle(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontSize: getProportionateScreenWidth(
                                kPhoneFontSizeTitle),
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )),
          ),
        ),
        isLoading
            ? Container(
                color: Colors.grey.withOpacity(0.5),
                child: Center(
                  child: SizedBox(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.grey,
                      strokeWidth: getProportionateScreenWidth(15),
                    ),
                    height: getProportionateScreenHeight(150),
                    width: getProportionateScreenWidth(150),
                  ),
                ),
              )
            : Container()
      ],
    );
  }

  // listDialog(
  //   BuildContext context,
  //   request,
  // ) {
  //   // set up the AlertDialog
  //   AlertDialog alert = AlertDialog(
  //     insetPadding: EdgeInsets.symmetric(
  //         horizontal: getProportionateScreenWidth(20),
  //         vertical: getProportionateScreenHeight(50)),
  //     title: Text(
  //       "Please select a relationship",
  //       style: GoogleFonts.poppins(
  //         fontSize: getProportionateScreenWidth(kPhoneFontSizeDefaultText),
  //         fontWeight: FontWeight.w500,
  //       ),
  //     ),
  //     content: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: <Widget>[
  //         ListTile(
  //           title: const Text("Father"),
  //           onTap: () {
  //             acceptRequest(request, 'Father');
  //             Navigator.pop(context);
  //           },
  //         ),
  //         ListTile(
  //           title: const Text("Mother"),
  //           onTap: () {
  //             acceptRequest(request, 'Mother');
  //             Navigator.pop(context);
  //           },
  //         ),
  //         ListTile(
  //           title: const Text("Son"),
  //           onTap: () {
  //             acceptRequest(request, 'Son');
  //             Navigator.pop(context);
  //           },
  //         ),
  //         ListTile(
  //           title: const Text("Brother"),
  //           onTap: () {
  //             acceptRequest(request, 'Brother');
  //             Navigator.pop(context);
  //           },
  //         ),
  //         ListTile(
  //           title: const Text("Sister"),
  //           onTap: () {
  //             acceptRequest(request, 'Sister');
  //             Navigator.pop(context);
  //           },
  //         ),
  //         ListTile(
  //           title: const Text("Other"),
  //           onTap: () {
  //             acceptRequest(request, 'Other');
  //             Navigator.pop(context);
  //           },
  //         )
  //       ],
  //     ),
  //   );

  //   // show the dialog
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }

  // listDialog(
  //   BuildContext context,
  //   request,
  // ) {
  //   Orientation _orientation = MediaQuery.of(context).orientation;
  //   Size _size = MediaQuery.of(context).size;
  //   // set up the AlertDialog
  //   AlertDialog alert = AlertDialog(
  //     shape: RoundedRectangleBorder(
  //       borderRadius: kPhoneBreakpoint > _size.width
  //           ? BorderRadius.circular(15)
  //           : _orientation == Orientation.portrait
  //               ? BorderRadius.circular(20)
  //               : BorderRadius.circular(25),
  //     ),
  //     insetPadding: EdgeInsets.symmetric(
  //         horizontal: getProportionateScreenWidth(20),
  //         vertical: getProportionateScreenHeight(50)),
  //     title: Text(
  //       "Please specify relationship",
  //       style: GoogleFonts.poppins(
  //         fontSize: getProportionateScreenWidth(kPhoneFontSizeDefaultText),
  //         fontWeight: FontWeight.w500,
  //       ),
  //     ),
  //     content: relationshipTextFormField(),
  //     actions: [
  //       TextButton(
  //         child: Text(
  //           "Cancel",
  //           style: GoogleFonts.poppins(
  //               fontSize:
  //                   getProportionateScreenWidth(kPhoneFontSizeDefaultText),
  //               fontWeight: FontWeight.w500,
  //               color: Colors.black),
  //         ),
  //         onPressed: () {
  //           Navigator.of(context).pop();
  //         },
  //       ),
  //       TextButton(
  //         child: Text(
  //           "Apply",
  //           style: GoogleFonts.poppins(
  //               fontSize:
  //                   getProportionateScreenWidth(kPhoneFontSizeDefaultText),
  //               fontWeight: FontWeight.w500,
  //               color: Colors.black),
  //         ),
  //         onPressed: () {
  //           if (_relationshipController.text.isNotEmpty) {
  //             // acceptRequest(request, _relationshipController.text);
  //             Navigator.of(context).pop();
  //           } else {
  //             Flushbar(
  //               duration: const Duration(seconds: 3),
  //               flushbarPosition: FlushbarPosition.BOTTOM,
  //               backgroundColor: kErrorColor,
  //               message: "Please specify relationship",
  //               icon: const Icon(
  //                 Icons.info_outline,
  //                 color: Colors.white,
  //               ),
  //             ).show(context);
  //           }
  //         },
  //       ),
  //     ],
  //   );

  //   // show the dialog
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }

  // TextFormField relationshipTextFormField() {
  //   Orientation _orientation = MediaQuery.of(context).orientation;
  //   Size _size = MediaQuery.of(context).size;
  //   return TextFormField(
  //     cursorColor: kTextColor,
  //     controller: _relationshipController,
  //     style: TextStyle(
  //       fontFamily: GoogleFonts.poppins().fontFamily,
  //       fontWeight: FontWeight.w300,
  //       color: Colors.black,
  //       fontSize: kPhoneBreakpoint > _size.width
  //           ? getProportionateScreenWidth(kPhoneFontSizeFieldValue)
  //           : _orientation == Orientation.portrait
  //               ? getProportionateScreenWidth(kTabletPortraitFontSizeFieldValue)
  //               : getProportionateScreenWidth(
  //                   kTabletLandscapeFontSizeFieldValue),
  //     ),
  //     decoration: InputDecoration(
  //       labelText: "Relationship",
  //       enabledBorder: OutlineInputBorder(
  //           borderRadius: kPhoneBreakpoint > _size.width
  //               ? BorderRadius.circular(15)
  //               : _orientation == Orientation.portrait
  //                   ? BorderRadius.circular(20)
  //                   : BorderRadius.circular(25),
  //           borderSide: const BorderSide(color: kLightColor),
  //           gapPadding: 10),
  //       focusedBorder: OutlineInputBorder(
  //           borderRadius: kPhoneBreakpoint > _size.width
  //               ? BorderRadius.circular(15)
  //               : _orientation == Orientation.portrait
  //                   ? BorderRadius.circular(20)
  //                   : BorderRadius.circular(25),
  //           borderSide: const BorderSide(color: kTextColor),
  //           gapPadding: 10),
  //       errorStyle: const TextStyle(color: kErrorColor),
  //       errorBorder: OutlineInputBorder(
  //           borderRadius: kPhoneBreakpoint > _size.width
  //               ? BorderRadius.circular(15)
  //               : _orientation == Orientation.portrait
  //                   ? BorderRadius.circular(20)
  //                   : BorderRadius.circular(25),
  //           borderSide: const BorderSide(color: kErrorColor),
  //           gapPadding: 10),
  //       focusedErrorBorder: OutlineInputBorder(
  //           borderRadius: kPhoneBreakpoint > _size.width
  //               ? BorderRadius.circular(15)
  //               : _orientation == Orientation.portrait
  //                   ? BorderRadius.circular(20)
  //                   : BorderRadius.circular(25),
  //           borderSide: const BorderSide(color: kErrorColor),
  //           gapPadding: 10),
  //       contentPadding: EdgeInsets.symmetric(
  //         horizontal: kPhoneBreakpoint > _size.width
  //             ? getProportionateScreenWidth(20)
  //             : _orientation == Orientation.portrait
  //                 ? getProportionateScreenWidth(20)
  //                 : getProportionateScreenWidth(15),
  //         vertical: kPhoneBreakpoint > _size.width
  //             ? getProportionateScreenHeight(20)
  //             : _orientation == Orientation.portrait
  //                 ? getProportionateScreenHeight(20)
  //                 : getProportionateScreenHeight(20),
  //       ),
  //       labelStyle: TextStyle(
  //         color: kTextColor,
  //         fontWeight: FontWeight.w400,
  //         fontSize: kPhoneBreakpoint > _size.width
  //             ? getProportionateScreenWidth(kPhoneFontSizeFieldLabel)
  //             : _orientation == Orientation.portrait
  //                 ? getProportionateScreenWidth(
  //                     kTabletPortraitFontSizeFieldLabel)
  //                 : getProportionateScreenWidth(
  //                     kTabletLandscapeFontSizeFieldLabel),
  //       ),
  //     ),
  //   );
  // }

  // Future<void> updateRequestsCollection() {
  //   // return requestsCollection
  //   //   .doc('ABC123')
  //   //   .update({'company': 'Stokes and Sons'})
  //   //   .then((value) => print("User Updated"))
  //   //   .catchError((error) => print("Failed to update user: $error"));
  // }

  acceptRequest(ride) async {
    try {
      var data = await ridesCollection
          .where('patientEmail', isEqualTo: ride['patientEmail'])
          .where('driverEmail', isEqualTo: ride['driverEmail'])
          .get();
      if (data.docs.isEmpty) {
        AlertDialog alert = AlertDialog(
          title: Text(
            "Request Deleted",
            style: GoogleFonts.poppins(
                fontSize:
                    getProportionateScreenWidth(kPhoneFontSizeDefaultText),
                fontWeight: FontWeight.w500,
                color: Colors.black),
          ),
          content: Text(
            "Patient has deleted this request",
            style: GoogleFonts.poppins(
                fontSize:
                    getProportionateScreenWidth(kPhoneFontSizeDefaultText),
                fontWeight: FontWeight.w300,
                color: Colors.black),
          ),
        );
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        );
        var rides_ = [...rides];
        // print(rides_);
        rides_.removeWhere((element) =>
            element['patientEmail'] == ride['patientEmail'] &&
            element['driverEmail'] == ride['driverEmail']);
        setState(() {
          globals.rides = rides_;
          rides = rides_;
        });
      } else {
        await inProgressRidesCollection.add({
          'status': 'inProgress',
          'part': 'part1',
          'chosenHospital': ride['chosenHospital'],
          'driverEmail': ride['driverEmail'],
          'driverLocation': ride['driverLocation'],
          'driverName': ride['driverName'],
          'driverPhone': ride['driverPhone'],
          'medicalCard': ride['medicalCard'],
          'patientName': ride['patientName'],
          'patientPhone': ride['patientPhone'],
          'patientLocation': ride['patientLocation'],
          'patientEmail': ride['patientEmail'],
          'users': [ride['driverEmail'], ride['patientEmail']],
        });
        for (var doc in data.docs) {
          doc.reference.delete();
        }
        // ridesCollection
        //     .where('patientEmail', isEqualTo: ride['patientEmail'])
        //     .where('driverEmail', isEqualTo: ride['driverEmail'])
        //     .get()
        //     .then((value) {
        //   for (var element in value.docs) {
        //     element.reference.delete();
        //   }
        // });
        var rides_ = [...rides];
        // print(rides_);
        rides_.removeWhere((element) =>
            element['patientEmail'] == ride['patientEmail'] &&
            element['driverEmail'] == ride['driverEmail']);
        setState(() {
          globals.rides = rides_;
          rides = rides_;
        });
        // var newRides = rides.where((element) => element != ride).toList();
        // setState(() {
        //   rides = newRides;
        //   globals.rides = newRides;
        // });
        // Flushbar(
        //   duration: const Duration(seconds: 3),
        //   flushbarPosition: FlushbarPosition.BOTTOM,
        //   backgroundColor: kPrimaryColor,
        //   message: "Request accepted",
        //   icon: const Icon(
        //     Icons.info_outline,
        //     color: Colors.white,
        //   ),
        // ).show(context);
        final response = await http.post(
          Uri.parse("${dotenv.env['API_URL1']}/user/set-ride-status"),
          // Uri.parse("${dotenv.env['API_URL2']}/user/getPatientList"),
          // Uri.parse("${dotenv.env['API_URL3']}/user/getPatientList"),
          // "${dotenv.env['API_URL3']}/user/getPatientList"),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': "Bearer ${dotenv.env['API_KEY_BEARER']}"
          },
          body: jsonEncode({
            'driverEmail': ride['driverEmail'],
          }),
        );
        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          globals.user = UserModel.fromJson(responseData);
          Navigator.pushNamed(context, MapsTracking.routeName);
        }
      }
    } catch (e) {}
    // try {
    //   setState(() {
    //     isLoading = true;
    //   });
    //   // .where("sender", isEqualTo: "${request['sender']}")
    //   // .where("receiver", isEqualTo: "${request['receiver']}");
    //   requestsCollection
    //       .where("sender", isEqualTo: "${request['sender']}")
    //       .where("receiver", isEqualTo: "${request['receiver']}")
    //       .get()
    //       .then((snapshot) {
    //     var requestIds = snapshot.docs.map((doc) {
    //       return doc.reference.id;
    //     }).toList();
    //     for (var id in requestIds) {
    //       requestsCollection
    //           .doc(id)
    //           .update({'status': true}).then(((value) async {
    //         List<dynamic> requestsNew = [...requests];
    //         requestsNew.remove(request);
    //         await Future.delayed(const Duration(seconds: 1));
    //         setState(() {
    //           requests = requestsNew;
    //           globals.requests = requestsNew;
    //           isLoading = false;
    //         });
    //       }));
    //     }
    //   }).catchError((error) {
    //     print(error.toString());
    //   });
    //   //   final response = await http.post(
    //   //       Uri.parse("${dotenv.env['API_URL1']}/user/acceptRequest"),
    //   //       // Uri.parse("${dotenv.env['API_URL2']}/user/getPatientList"),
    //   //       // Uri.parse("${dotenv.env['API_URL3']}/user/getPatientList"),
    //   //       // "${dotenv.env['API_URL3']}/user/getPatientList"),
    //   //       headers: {
    //   //         'Content-Type': 'application/json',
    //   //         'Authorization': "Bearer ${dotenv.env['API_KEY_BEARER']}"
    //   //       },
    //   //       body: jsonEncode({
    //   //         'id': request['_id'],
    //   //         'relationship': relationship,
    //   //       }));
    //   //   if (response.statusCode == 200) {
    //   //     var data = json.decode(response.body);
    //   //     var newRequests = data['requests'];
    //   //     var emergencyContact = data['emergencyContact'];
    //   //     setState(() {
    //   //       globals.requests = newRequests;
    //   //       globals.user?.addEmergencyContact(emergencyContact);
    //   //       requests = newRequests ?? [];
    //   //     });
    //   //   } else {}
    //   //   // ignore: empty_catches
    // } catch (e) {}
  }

  deleteRequest(ride) async {
    try {
      var rides_ = [...rides];
      // print(rides_);
      rides_.removeWhere((element) =>
          element['patientEmail'] == ride['patientEmail'] &&
          element['driverEmail'] == ride['driverEmail']);
      setState(() {
        globals.rides = rides_;
        rides = rides_;
      });
      ridesCollection
          .where("patientEmail", isEqualTo: ride['patientEmail'])
          .where("driverEmail", isEqualTo: ride['driverEmail'])
          .get()
          .then((value) {
        for (var element in value.docs) {
          element.reference.delete();
        }
        // ridesCollection
        //     .where("driverEmail", isEqualTo: globals.user?.email)
        //     .get()
        //     .then((value) {
        //       setState(() {
        //         rides = value.docs.map((doc) {
        //           return doc.data();
        //         }).toList();
        //       });
        // });
      });
    } catch (e) {
      print(e);
    }
    // try {
    //   print(request);
    //   // delete request from cloud firestore
    //   var requestsData = await FirebaseFirestore.instance
    //       .collection('requests')
    //       .where('sender', isEqualTo: request['sender'])
    //       .where('senderName', isEqualTo: request['senderName'])
    //       .where('receiver', isEqualTo: request['receiver'])
    //       .where('receiverName', isEqualTo: request['receiverName'])
    //       .get();
    //   var requests = requestsData.docs;
    //   for (var request in requests) {
    //     await request.reference.delete();
    //   }
    //   requestsData = await FirebaseFirestore.instance
    //       .collection('requests')
    //       .where('receiver', isEqualTo: request['sender'])
    //       .where('status', isEqualTo: false)
    //       .get();
    //   requests = requestsData.docs;
    //   var requests1 = requests.map((doc) {
    //     return doc.data();
    //   }).toList();
    //   setState(() {
    //     globals.requests = requests1;
    //     requests =
    //         requests1.cast<QueryDocumentSnapshot<Map<String, dynamic>>>();
    //   });
    //   //   final response = await http.post(
    //   //       Uri.parse("${dotenv.env['API_URL1']}/user/deleteRequest"),
    //   //       // Uri.parse("${dotenv.env['API_URL2']}/user/getPatientList"),
    //   //       // Uri.parse("${dotenv.env['API_URL3']}/user/getPatientList"),
    //   //       // "${dotenv.env['API_URL3']}/user/getPatientList"),
    //   //       headers: {
    //   //         'Content-Type': 'application/json',
    //   //         'Authorization': "Bearer ${dotenv.env['API_KEY_BEARER']}"
    //   //       },
    //   //       body: jsonEncode({
    //   //         'id': request['_id'],
    //   //         'email': request['receiver'],
    //   //       }));
    //   //   if (response.statusCode == 200) {
    //   //     var data = json.decode(response.body);
    //   //     var newRequests = data['requests'];
    //   //     setState(() {
    //   //       globals.user?.requests = newRequests;
    //   //       requests = newRequests ?? [];
    //   //     });
    //   //   } else {}
    //   // ignore: empty_catches
    // } catch (e) {
    //   print(e);
    // }
  }
}
