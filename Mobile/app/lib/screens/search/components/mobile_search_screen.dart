import 'dart:convert';

// import 'package:another_flushbar/flushbar.dart';
import 'package:app/components/default_button.dart';
import 'package:app/constants.dart';
import 'package:app/models/user_model.dart';
import 'package:app/size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../dsa/trie.dart';
import '../../../globals.dart' as globals;

class MobileSearchScreen extends StatefulWidget {
  const MobileSearchScreen({Key? key}) : super(key: key);

  @override
  State<MobileSearchScreen> createState() => _MobileSearchScreenState();
}

class _MobileSearchScreenState extends State<MobileSearchScreen>
    with SingleTickerProviderStateMixin {
  List<String> chosenOptions = [];
  List<UserModel> chosenOptionsUsers = [];
  List<String> options = [];
  // List<UserModel> users = [];
  List<String> filteredOptions = [];
  List<dynamic> filteredOptionsUsers = [];
  String searchType = '';
  String selectedRelationship = '';
  var flag = true;
  late AnimationController _animationController;
  final Duration _duration = const Duration(milliseconds: 1000);
  final Tween<Offset> _tween =
      Tween(begin: const Offset(0, 1), end: const Offset(0, 0));
  double min = 0.4, initial = 0.4, max = 0.7;

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _relationshipController = TextEditingController();
  final trie = StringTrie();
  Map jsonObj = {};

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: _duration);
  }

  void setOptions() async {
    String apiUrl = '';
    if (searchType == 'emergencyContacts') {
      apiUrl = 'getPatientList';
    }
    if (searchType == '') {
      return;
    }
    final response = await http.get(
        Uri.parse(
            "${dotenv.env['API_URL1']}/user/$apiUrl?email=${globals.user?.email}"),
        // Uri.parse("${dotenv.env['API_URL2']}/user/getPatientList"),
        // Uri.parse("${dotenv.env['API_URL3']}/user/getPatientList"),
        // "${dotenv.env['API_URL3']}/user/getPatientList"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': "Bearer ${dotenv.env['API_KEY_BEARER']}"
        });
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      Map newJsonObj = {};
      for (var item in data['data']) {
        UserModel user = UserModel.fromJson(item);
        if (globals.sentRequests[user.email] == null) {
          newJsonObj = trie.insertUser(user, newJsonObj);
        }
      }
      setState(() {
        jsonObj = newJsonObj;
        // users =
        //     data['data'].map<UserModel>((e) => UserModel.fromJson(e)).toList();
      });
    } else {}
  }

  void setOptionsMedicalCard(options, chosenOptions) async {
    for (var item in options) {
      trie.insertString(item.toLowerCase());
    }
    for (var item in chosenOptions) {
      trie.remove(item.toLowerCase());
    }
    this.chosenOptions = chosenOptions;
    if (chosenOptions.isNotEmpty) {
      _animationController.forward();
    }
  }

  String? convertToTitleCase(String text) {
    if (text.isEmpty) {
      return null;
    }
    if (text.length <= 1) {
      return text.toUpperCase();
    }
    // Split string into multiple words
    final List<String> words = text.split(' ');
    // Capitalize first letter of each words
    final capitalizedWords = words.map((word) {
      if (word.trim().isNotEmpty) {
        final String firstLetter = word.trim().substring(0, 1).toUpperCase();
        final String remainingLetters = word.trim().substring(1);
        return '$firstLetter$remainingLetters';
      }
      return '';
    });
    return capitalizedWords.join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map;
    setState(() {
      // options = arguments['searchOptions'] as List<String>;
      // chosenOptions = arguments['chosenOptions'] as List<String>;
      searchType = arguments['searchType'] as String;
      if (flag && searchType == 'emergencyContacts') {
        setOptions();
        flag = false;
      } else if (flag && searchType == 'medicalCardSetup') {
        options = arguments['searchOptions'] as List<String>;
        chosenOptions = arguments['chosenOptions'] as List<String>;
        setOptionsMedicalCard(options, chosenOptions);
        flag = false;
      }
    });
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          titleSpacing: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: kPrimaryColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Search',
            style: GoogleFonts.poppins(
              fontSize: getProportionateScreenWidth(kPhoneFontSizeDefaultText),
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              searchTextFormField(),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Stack(
                    children: [
                      SizedBox(height: getProportionateScreenHeight(20)),
                      searchType == 'emergencyContacts'
                          ? ListView.builder(
                              // itemCount: filteredOptionsUsers.isEmpty &&
                              //         _searchController.text
                              //             .trim()
                              //             .isNotEmpty &&
                              //         !chosenOptions.contains(
                              //             _searchController.text.trim())
                              //     ? 1
                              //     : filteredOptionsUsers.length,
                              itemCount: filteredOptionsUsers.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: filteredOptionsUsers[index] == -1
                                      ? const Text("No results found")
                                      : Text(
                                          "${filteredOptionsUsers[index].getName()}\n${filteredOptionsUsers[index].email}"),
                                  onTap: () {
                                    if (filteredOptionsUsers[index] == -1) {
                                      return;
                                    }
                                    setState(() {
                                      _relationshipController.text = '';
                                    });
                                    listDialog(
                                        context, filteredOptionsUsers[index]);
                                    // setState(() {
                                    //   if (filteredOptionsUsers.isNotEmpty) {
                                    //     chosenOptions
                                    //         .add(filteredOptions[index]);
                                    //     filteredOptions.removeAt(index);
                                    //   } else {
                                    //     chosenOptions
                                    //         .add(filteredOptions[index]);
                                    //     filteredOptions.removeAt(index);
                                    //   }
                                    // });
                                  },
                                );
                              },
                            )
                          : ListView.builder(
                              itemCount: filteredOptions.isEmpty &&
                                      _searchController.text.trim().isNotEmpty
                                  ? 1
                                  : filteredOptions.length,
                              itemBuilder: (context, index) {
                                String text = "";
                                if (filteredOptions.isEmpty) {
                                  text = _searchController.text.trim();
                                } else {
                                  text = convertToTitleCase(
                                          filteredOptions[index]) ??
                                      "";
                                }
                                return ListTile(
                                  title: filteredOptions.isEmpty
                                      ? Text(
                                          "Add new '${_searchController.text.trim()}'")
                                      : Text(text),
                                  onTap: () {
                                    if (_animationController.isDismissed) {
                                      _animationController.forward();
                                    }
                                    setState(() {
                                      if (filteredOptions.isEmpty &&
                                          _searchController.text
                                              .trim()
                                              .isNotEmpty) {
                                        chosenOptions.add(text);
                                      } else {
                                        chosenOptions.add(text);
                                        trie.remove(text.toLowerCase());
                                        filteredOptions.removeAt(index);
                                      }
                                      _searchController.clear();
                                    });
                                  },
                                );
                              },
                            ),
                      SlideTransition(
                        position: _tween.animate(_animationController),
                        child: DraggableScrollableSheet(
                          initialChildSize: initial,
                          minChildSize: min,
                          maxChildSize: max,
                          builder: (BuildContext context,
                              ScrollController scrollController) {
                            return Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  topRight: Radius.circular(40),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(0, -2),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal:
                                          getProportionateScreenWidth(140),
                                      vertical:
                                          getProportionateScreenHeight(20),
                                    ),
                                    child: Container(
                                        height: getProportionateScreenHeight(5),
                                        decoration: BoxDecoration(
                                          color: kTextColor,
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        )),
                                  ),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      controller: scrollController,
                                      child: Column(
                                        children: [
                                          chosenOptionsUsers.isNotEmpty
                                              ? Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        getProportionateScreenWidth(
                                                            50),
                                                  ),
                                                  child: Text(
                                                    "Do you want to add, ${chosenOptionsUsers[0].firstName} as your ${_relationshipController.text}?",
                                                    style: GoogleFonts.poppins(
                                                      fontSize:
                                                          getProportionateScreenWidth(
                                                              kPhoneFontSizeDefaultText),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                          searchType == 'emergencyContacts'
                                              ? Wrap(
                                                  spacing: 5.0,
                                                  children: <Widget>[
                                                    for (var obj
                                                        in chosenOptionsUsers)
                                                      Theme(
                                                        data: ThemeData.dark(),
                                                        child: InputChip(
                                                          backgroundColor:
                                                              kPrimaryColor,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2.0),
                                                          label: Text(
                                                            obj.getName(),
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontSize:
                                                                  getProportionateScreenWidth(
                                                                      kPhoneFontSizeDefaultText),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          onDeleted: () {
                                                            _animationController
                                                                .reverse();
                                                            setState(() {
                                                              chosenOptionsUsers =
                                                                  [];
                                                              // if (_searchController
                                                              //     .text
                                                              //     .isNotEmpty) {
                                                              //   filteredOptionsUsers
                                                              //       .add(text);
                                                              //   filteredOptions
                                                              //       .sort();
                                                              // }
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                  ],
                                                )
                                              : Wrap(
                                                  spacing: 5.0,
                                                  children: <Widget>[
                                                    for (var text
                                                        in chosenOptions)
                                                      Theme(
                                                        data: ThemeData.dark(),
                                                        child: InputChip(
                                                          backgroundColor:
                                                              kPrimaryColor,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2.0),
                                                          label: Text(
                                                            text,
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontSize:
                                                                  getProportionateScreenWidth(
                                                                      kPhoneFontSizeDefaultText),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          onDeleted: () {
                                                            if (chosenOptions
                                                                    .length ==
                                                                1) {
                                                              _animationController
                                                                  .reverse();
                                                            }
                                                            setState(() {
                                                              chosenOptions
                                                                  .remove(text);
                                                              trie.insertString(
                                                                  text.toLowerCase());
                                                              // if (_searchController
                                                              //     .text
                                                              //     .isNotEmpty) {
                                                              //   filteredOptions
                                                              //       .add(text);
                                                              //   filteredOptions
                                                              //       .sort();
                                                              // }
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  getProportionateScreenWidth(
                                                      100),
                                              vertical:
                                                  getProportionateScreenHeight(
                                                      20),
                                            ),
                                            child: DefaultButton(
                                              text: searchType ==
                                                      'emergencyContacts'
                                                  ? 'Add'
                                                  : 'Apply',
                                              press: () {
                                                if (searchType ==
                                                    'emergencyContacts') {
                                                  Navigator.pop(context, [
                                                    chosenOptionsUsers,
                                                    _relationshipController.text
                                                  ]);
                                                } else {
                                                  Navigator.pop(context,
                                                      chosenOptions.toList());
                                                }
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  listDialog(
    BuildContext context,
    UserModel filteredOptionsUser,
  ) {
    Orientation _orientation = MediaQuery.of(context).orientation;
    Size _size = MediaQuery.of(context).size;
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: kPhoneBreakpoint > _size.width
            ? BorderRadius.circular(15)
            : _orientation == Orientation.portrait
                ? BorderRadius.circular(20)
                : BorderRadius.circular(25),
      ),
      insetPadding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(20),
          vertical: getProportionateScreenHeight(50)),
      title: Text(
        "Please specify relationship",
        style: GoogleFonts.poppins(
          fontSize: getProportionateScreenWidth(kPhoneFontSizeDefaultText),
          fontWeight: FontWeight.w500,
        ),
      ),
      content: relationshipTextFormField(),
      actions: [
        TextButton(
          child: Text(
            "Cancel",
            style: GoogleFonts.poppins(
                fontSize:
                    getProportionateScreenWidth(kPhoneFontSizeDefaultText),
                fontWeight: FontWeight.w500,
                color: Colors.black),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(
            "Apply",
            style: GoogleFonts.poppins(
                fontSize:
                    getProportionateScreenWidth(kPhoneFontSizeDefaultText),
                fontWeight: FontWeight.w500,
                color: Colors.black),
          ),
          onPressed: () {
            if (_relationshipController.text.isNotEmpty) {
              setState(() {
                chosenOptionsUsers = [filteredOptionsUser];
              });
              _animationController.forward();
              Navigator.of(context).pop();
            } else {
              // Flushbar(
              //   duration: const Duration(seconds: 3),
              //   flushbarPosition: FlushbarPosition.BOTTOM,
              //   backgroundColor: kErrorColor,
              //   message: "Please specify relationship",
              //   icon: const Icon(
              //     Icons.info_outline,
              //     color: Colors.white,
              //   ),
              // ).show(context);
            }
          },
        ),
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  TextFormField relationshipTextFormField() {
    Orientation _orientation = MediaQuery.of(context).orientation;
    Size _size = MediaQuery.of(context).size;
    return TextFormField(
      cursorColor: kTextColor,
      controller: _relationshipController,
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
        labelText: "Relationship",
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
        errorStyle: const TextStyle(color: kErrorColor),
        errorBorder: OutlineInputBorder(
            borderRadius: kPhoneBreakpoint > _size.width
                ? BorderRadius.circular(15)
                : _orientation == Orientation.portrait
                    ? BorderRadius.circular(20)
                    : BorderRadius.circular(25),
            borderSide: const BorderSide(color: kErrorColor),
            gapPadding: 10),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: kPhoneBreakpoint > _size.width
                ? BorderRadius.circular(15)
                : _orientation == Orientation.portrait
                    ? BorderRadius.circular(20)
                    : BorderRadius.circular(25),
            borderSide: const BorderSide(color: kErrorColor),
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
                      kTabletLandscapeFontSizeFieldLabel),
        ),
      ),
    );
  }

  TextFormField searchTextFormField() {
    Orientation _orientation = MediaQuery.of(context).orientation;
    Size _size = MediaQuery.of(context).size;
    return TextFormField(
      cursorColor: kTextColor,
      controller: _searchController,
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
      onChanged: (value) {
        if (searchType == 'emergencyContacts' && value.isNotEmpty) {
          final results = trie.matchPrefix(value.toLowerCase());
          var toBeDisplayed = [];
          for (var item in results) {
            toBeDisplayed.addAll(jsonObj[item]);
          }
          if (toBeDisplayed.isEmpty) {
            setState(() {
              filteredOptionsUsers = [-1];
            });
          } else {
            toBeDisplayed.sort((a, b) => a.getName().compareTo(b.getName()));
            setState(() {
              filteredOptionsUsers = toBeDisplayed;
            });
          }
        } else if (searchType == 'emergencyContacts') {
          setState(() {
            filteredOptionsUsers = [];
          });
        } else if (searchType == 'medicalCardSetup' && value.isNotEmpty) {
          final results = trie.matchPrefix(value.toLowerCase());
          setState(() {
            filteredOptions = results;
          });
        } else if (searchType == 'medicalCardSetup') {
          setState(() {
            filteredOptions = [];
          });
        }
        // setState(() {
        //   if (searchType == 'emergencyContacts') {
        //     filteredOptionsUsers = users
        //         .where((element) =>
        //             (element
        //                     .getName()
        //                     .toLowerCase()
        //                     .contains(value.toLowerCase()) ||
        //                 element.email
        //                     .toLowerCase()
        //                     .contains(value.toLowerCase())) &&
        //             value.isNotEmpty)
        //         .toList();
        //     filteredOptionsUsers
        //         .sort((a, b) => a.getName().compareTo(b.getName()));
        //   } else {
        //     filteredOptions = options
        //         .where((option) =>
        //             option.toLowerCase().contains(value.toLowerCase()) &&
        //             value.isNotEmpty)
        //         .toList();
        //     filteredOptions = filteredOptions
        //         .where((option) => !chosenOptions.contains(option))
        //         .toList();
        //     filteredOptions.sort();
        //   }
        // });
      },
      decoration: InputDecoration(
        hintText: 'Search',
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: kTextColor), gapPadding: 10),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: kTextColor), gapPadding: 10),
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
                      kTabletLandscapeFontSizeFieldLabel),
        ),
      ),
    );
  }
}
