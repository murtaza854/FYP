import 'dart:convert';

import 'package:app/components/default_button.dart';
import 'package:app/components/title_custom.dart';
import 'package:app/constants.dart';
import 'package:app/models/user_model.dart';
import 'package:app/screens/requestsScreen/requests_screen.dart';
import 'package:app/screens/search/search_screen.dart';
import 'package:app/size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../globals.dart' as globals;

class MobileEmergencyContactsScreen extends StatefulWidget {
  static const String routeName = '/emergencyContacts';
  const MobileEmergencyContactsScreen({Key? key}) : super(key: key);

  @override
  State<MobileEmergencyContactsScreen> createState() =>
      _MobileEmergencyContactsScreenState();
}

class _MobileEmergencyContactsScreenState
    extends State<MobileEmergencyContactsScreen> {
  List<dynamic> emergencyContacts = [];
  int selectedIndex = -1;
  int requestsLength = 0;
  CollectionReference requests =
      FirebaseFirestore.instance.collection('requests');

  @override
  void initState() {
    super.initState();
    setState(() {
      print(globals.user?.emergencyContacts);
      emergencyContacts = globals.user?.emergencyContacts ?? [];
      requestsLength = globals.requests.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SizedBox(
        child: Padding(
          padding: EdgeInsets.only(
            top: getProportionateScreenHeight(50),
            left: getProportionateScreenWidth(20),
            right: getProportionateScreenWidth(20),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: Row(
                  children: [
                    const TitleCustom(
                      text: 'Emergency\nContacts',
                      color: kPrimaryColor,
                    ),
                    const Spacer(),
                    DefaultButton(
                      text: "Add",
                      press: () async {
                        final lst = await Navigator.pushNamed(
                            context, SearchScreen.routeName,
                            arguments: {
                              'searchOptions': [],
                              'chosenOptions': [],
                              'searchType': 'emergencyContacts',
                            }) as List<dynamic>;
                        try {
                          final chosenUsers = lst[0] as List<UserModel>;
                          final selectedRelationship = lst[1] as String;
                          if (chosenUsers.isNotEmpty) {
                            await requests.add({
                              'sender': globals.user?.email,
                              'senderFirstName': globals.user?.firstName,
                              'senderName': globals.user?.getName(),
                              'receiver': chosenUsers[0].email,
                              'receiverFirstName': chosenUsers[0].firstName,
                              'receiverName': chosenUsers[0].getName(),
                              'relationship': selectedRelationship,
                              'status': false,
                              'seenAfterAcceptanceFrom': false,
                              'createdAt': FieldValue.serverTimestamp(),
                            });
                            final response = await http.post(
                                Uri.parse(
                                    "${dotenv.env['API_URL1']}/user/getID"),
                                // Uri.parse("${dotenv.env['API_URL2']}/user/getPatientList"),
                                // Uri.parse("${dotenv.env['API_URL3']}/user/getID"),
                                // "${dotenv.env['API_URL3']}/user/getPatientList"),
                                headers: {
                                  'Content-Type': 'application/json',
                                  'Authorization':
                                      "Bearer ${dotenv.env['API_KEY_BEARER']}",
                                },
                                body: jsonEncode(
                                    {"email": chosenUsers[0].email}));
                            if (response.statusCode == 200) {
                              var data = json.decode(response.body);
                              var _id = data['_id'];
                              sendNotification([
                                _id
                              ], "${globals.user?.firstName} wants to add you as a $selectedRelationship",
                                  "New Emergency Contact Request");
                            } else {
                              print(response.statusCode);
                            }
                            // if (newRequest.id != null) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  Orientation _orientation =
                                      MediaQuery.of(context).orientation;
                                  Size _size = MediaQuery.of(context).size;
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: kPhoneBreakpoint >
                                              _size.width
                                          ? BorderRadius.circular(15)
                                          : _orientation == Orientation.portrait
                                              ? BorderRadius.circular(20)
                                              : BorderRadius.circular(25),
                                    ),
                                    title: const TitleCustom(
                                      text: 'Success',
                                      color: kPrimaryColor,
                                    ),
                                    content: Text(
                                        'Your request has been sent to, ${chosenUsers[0].firstName} to be added as your $selectedRelationship.',
                                        style: TextStyle(
                                          fontSize: getProportionateScreenWidth(
                                              kPhoneFontSizeDefaultText),
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                        )),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('OK',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize:
                                                  getProportionateScreenWidth(
                                                      kPhoneFontSizeDefaultText),
                                              fontFamily: GoogleFonts.poppins()
                                                  .fontFamily,
                                            )),
                                      ),
                                    ],
                                  );
                                });
                            // } else {}
                          }
                          // ignore: empty_catches
                        } catch (e) {}
                      },
                      mobileWidth: 70,
                      tabletPortraitWidth: 50,
                      tabletLandscapeWidth: 50,
                      icon: Icons.add,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: getProportionateScreenHeight(20),
              ),
              requestsLength != 0
                  ? Container(
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
                      child: GestureDetector(
                        onTap: () async {
                          try {
                            await Navigator.pushNamed(
                                context, RequestsScreen.routeName) as int;
                            setState(() {
                              requestsLength = globals.requests.length;
                            });
                          } catch (e) {
                            setState(() {
                              requestsLength = globals.requests.length;
                            });
                          }
                        },
                        child: Row(children: [
                          Expanded(
                            flex: 3,
                            child: ListTile(
                              title: Text(
                                "$requestsLength new request${requestsLength > 1 ? 's' : ''}",
                                style: TextStyle(
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const Expanded(
                              child: Icon(
                            Icons.arrow_forward_ios,
                            color: kPrimaryColor,
                          ))
                        ]),
                      ),
                    )
                  : Container(),
              Expanded(
                child: emergencyContacts.isNotEmpty
                    ? ListView.builder(
                        itemCount: emergencyContacts.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              if (selectedIndex == index) {
                                setState(() {
                                  selectedIndex = -1;
                                });
                              } else {
                                setState(() {
                                  selectedIndex = index;
                                });
                              }
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
                                  color: selectedIndex == index
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
                                      emergencyContacts[index]['user1']
                                                  ['email'] ==
                                              globals.user?.email
                                          ? "${emergencyContacts[index]['user2']['firstName']} ${emergencyContacts[index]['user2']['lastName']}"
                                          : "${emergencyContacts[index]['user1']['firstName']} ${emergencyContacts[index]['user1']['lastName']}",
                                      style: TextStyle(
                                        fontFamily:
                                            GoogleFonts.poppins().fontFamily,
                                        color: kPrimaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    subtitle: Text(
                                      emergencyContacts[index]['user1']
                                                  ['email'] ==
                                              globals.user?.email
                                          ? "${emergencyContacts[index]['user2']['email']}\n${emergencyContacts[index]['user1RelationToUser2']}\n${emergencyContacts[index]['user2']['contactNumber']}"
                                          : "${emergencyContacts[index]['user1']['email']}\n${emergencyContacts[index]['user2RelationToUser1']}\n${emergencyContacts[index]['user1']['contactNumber']}",
                                      style: TextStyle(
                                        fontFamily:
                                            GoogleFonts.poppins().fontFamily,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                    child: selectedIndex == index
                                        ? IconButton(
                                            onPressed: () {
                                              Orientation _orientation =
                                                  MediaQuery.of(context)
                                                      .orientation;
                                              Size _size =
                                                  MediaQuery.of(context).size;
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        kPhoneBreakpoint >
                                                                _size.width
                                                            ? BorderRadius
                                                                .circular(15)
                                                            : _orientation ==
                                                                    Orientation
                                                                        .portrait
                                                                ? BorderRadius
                                                                    .circular(
                                                                        20)
                                                                : BorderRadius
                                                                    .circular(
                                                                        25),
                                                  ),
                                                  title: Text(
                                                    "Delete Contact",
                                                    style: TextStyle(
                                                      fontFamily:
                                                          GoogleFonts.poppins()
                                                              .fontFamily,
                                                      color: kPrimaryColor,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  content: Text(
                                                    "Are you sure you want to remove your ${emergencyContacts[index]['relation']?.toLowerCase()}, ${emergencyContacts[index]['name']}?",
                                                    style: TextStyle(
                                                      fontFamily:
                                                          GoogleFonts.poppins()
                                                              .fontFamily,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text(
                                                        "Cancel",
                                                        style: TextStyle(
                                                          fontFamily:
                                                              GoogleFonts
                                                                      .poppins()
                                                                  .fontFamily,
                                                          color: kPrimaryColor,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        deleteContact(
                                                            emergencyContacts[
                                                                index]);
                                                        setState(() {
                                                          emergencyContacts
                                                              .removeAt(index);
                                                          selectedIndex = -1;
                                                        });
                                                      },
                                                      child: Text(
                                                        "Delete",
                                                        style: TextStyle(
                                                          fontFamily:
                                                              GoogleFonts
                                                                      .poppins()
                                                                  .fontFamily,
                                                          color: kPrimaryColor,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.black,
                                            ))
                                        : Container()),
                                // Expanded(child: child),
                              ]),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          'No Emergency Contacts',
                          style: TextStyle(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontSize: getProportionateScreenWidth(
                                kPhoneFontSizeTitle),
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Future<http.Response?> sendNotification(
      List<String> tokenIdList, String contents, String heading) async {
    try {
      http.Response response = await http.post(
        Uri.parse(
          'https://onesignal.com/api/v1/notifications',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Basic ${dotenv.env['ONESIGNAL_REST_API_KEY']}"
        },
        body: jsonEncode(<String, dynamic>{
          "app_id": "${dotenv.env['ONESIGNAL_APP_ID']}",

          "include_external_user_ids": tokenIdList,

          // android_accent_color reprsent the color of the heading text in the notifiction
          // "android_accent_color": "FF9976D2",

          "small_icon": "ic_stat_onesignal_default",

          "headings": {"en": heading},

          "contents": {"en": contents},
          'channel_for_external_user_ids': "push"
        }),
      );
      return response;
    } catch (e) {
      return null;
    }
  }

  deleteContact(emergencyContact) async {
    print(emergencyContact);
    final response = await http.post(
        Uri.parse("${dotenv.env['API_URL1']}/user/delete-emergency-contact"),
        // Uri.parse("${dotenv.env['API_URL2']}/user/signup"),
        // Uri.parse("${dotenv.env['API_URL3']}/user/signup"),
        // "${dotenv.env['API_URL3']}/user/get-logged-in-user"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': "Bearer ${dotenv.env['API_KEY_BEARER']}"
        },
        body: jsonEncode({'_id': emergencyContact['_id']}));
  }
}
