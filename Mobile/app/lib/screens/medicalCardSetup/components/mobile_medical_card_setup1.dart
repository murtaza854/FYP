import 'dart:convert';

import 'package:app/components/title_custom.dart';
import 'package:app/models/user_model.dart';
import 'package:app/screens/home/home_screen.dart';
import 'package:app/screens/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../globals.dart' as globals;

class MobileMedicalCardSetup1 extends StatefulWidget {
  const MobileMedicalCardSetup1({Key? key}) : super(key: key);

  @override
  State<MobileMedicalCardSetup1> createState() =>
      _MobileMedicalCardSetup1State();
}

class _MobileMedicalCardSetup1State extends State<MobileMedicalCardSetup1> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [kLightColor, kLightColor, kLightColor, Colors.white],
            ),
          ),
          child: SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // const Spacer(),
                    SizedBox(height: getProportionateScreenHeight(60)),
                    Image.asset(
                      "assets/images/Medical-Card.png",
                      width: getProportionateScreenWidth(100),
                    ),
                    SizedBox(height: getProportionateScreenHeight(30)),
                    const BasicDetailsForm(),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}

class BasicDetailsForm extends StatefulWidget {
  const BasicDetailsForm({Key? key}) : super(key: key);

  @override
  State<BasicDetailsForm> createState() => _BasicDetailsFormState();
}

class _BasicDetailsFormState extends State<BasicDetailsForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _bloodgroupController = TextEditingController();
  final TextEditingController _familyHistoryController =
      TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  DateTime selectedDate = DateTime(DateTime.now().year - 25);
  late int selectedValue;

  List<String> medicalConditons = [
    "Asthma",
    "Cancer",
    "Diabetes",
    "Heart Disease",
    "High Blood Pressure",
    "Hypertension",
    "Kidney Disease",
    "Liver Disease",
    "Lung Disease",
    "Obesity",
    "Rheumatic Fever",
    "Stroke",
    "Thyroid Disease",
    "Tuberculosis",
    "Ulcer",
    "Viral Infection"
  ];
  List<String> allergies = [];
  List<String> vaccinations = [];

  List<String> chosenMedicalConditons = [];
  List<String> chosenAllergies = [];
  List<String> chosenVaccinations = [];

  @override
  Widget build(BuildContext context) {
    Orientation _orientation = MediaQuery.of(context).orientation;
    Size _size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: kPhoneBreakpoint > _size.width
              ? const Radius.circular(60)
              : _orientation == Orientation.portrait
                  ? const Radius.circular(90)
                  : const Radius.circular(70),
          topRight: kPhoneBreakpoint > _size.width
              ? const Radius.circular(60)
              : _orientation == Orientation.portrait
                  ? const Radius.circular(90)
                  : const Radius.circular(70),
        ),
        color: Colors.white,
      ),
      padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(30),
          vertical: getProportionateScreenHeight(40)),
      child: Form(
        key: _formKey,
        child: Column(children: [
          const TitleCustom(text: "Medical Card", color: Colors.black),
          SizedBox(height: getProportionateScreenHeight(5)),
          Text(
            "Enter your Medical Record",
            style: GoogleFonts.poppins(
              fontSize: getProportionateScreenWidth(kPhoneFontSizeDefaultText),
              fontWeight: FontWeight.w400,
              color: kTextColor,
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(15)),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Basic Information",
              style: GoogleFonts.poppins(
                fontSize:
                    getProportionateScreenWidth(kPhoneFontSizeDefaultText),
                fontWeight: FontWeight.w500,
                color: kPrimaryColor,
              ),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(5)),
          genderTextFormField(),
          SizedBox(height: getProportionateScreenHeight(15)),
          dobTextFormField(),
          SizedBox(height: getProportionateScreenHeight(15)),
          heightTextFormField(),
          SizedBox(height: getProportionateScreenHeight(15)),
          weightTextFormField(),
          SizedBox(height: getProportionateScreenHeight(15)),
          bloodgroupTextFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Primary Medical Conditions",
              style: GoogleFonts.poppins(
                fontSize:
                    getProportionateScreenWidth(kPhoneFontSizeDefaultText),
                fontWeight: FontWeight.w500,
                color: kPrimaryColor,
              ),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(5)),
          searchTextFormField(medicalConditons, chosenMedicalConditons),
          Wrap(
            spacing: 5.0,
            children: <Widget>[
              for (var text in chosenMedicalConditons)
                Theme(
                  data: ThemeData.dark(),
                  child: InputChip(
                    backgroundColor: kPrimaryColor,
                    padding: const EdgeInsets.all(2.0),
                    label: Text(
                      text,
                      style: GoogleFonts.poppins(
                        fontSize: getProportionateScreenWidth(
                            kPhoneFontSizeDefaultText),
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                    onDeleted: () {
                      setState(() {
                        chosenMedicalConditons.remove(text);
                      });
                    },
                  ),
                )
            ],
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Allergies",
              style: GoogleFonts.poppins(
                fontSize:
                    getProportionateScreenWidth(kPhoneFontSizeDefaultText),
                fontWeight: FontWeight.w500,
                color: kPrimaryColor,
              ),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(5)),
          searchTextFormField(allergies, chosenAllergies),
          Wrap(
            spacing: 5.0,
            children: <Widget>[
              for (var text in chosenAllergies)
                Theme(
                  data: ThemeData.dark(),
                  child: InputChip(
                    backgroundColor: kPrimaryColor,
                    padding: const EdgeInsets.all(2.0),
                    label: Text(
                      text,
                      style: GoogleFonts.poppins(
                        fontSize: getProportionateScreenWidth(
                            kPhoneFontSizeDefaultText),
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                    onDeleted: () {
                      setState(() {
                        chosenAllergies.remove(text);
                      });
                    },
                  ),
                )
            ],
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Vaccinations",
              style: GoogleFonts.poppins(
                fontSize:
                    getProportionateScreenWidth(kPhoneFontSizeDefaultText),
                fontWeight: FontWeight.w500,
                color: kPrimaryColor,
              ),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(5)),
          searchTextFormField(vaccinations, chosenVaccinations),
          Wrap(
            spacing: 5.0,
            children: <Widget>[
              for (var text in chosenVaccinations)
                Theme(
                  data: ThemeData.dark(),
                  child: InputChip(
                    backgroundColor: kPrimaryColor,
                    padding: const EdgeInsets.all(2.0),
                    label: Text(
                      text,
                      style: GoogleFonts.poppins(
                        fontSize: getProportionateScreenWidth(
                            kPhoneFontSizeDefaultText),
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                    onDeleted: () {
                      setState(() {
                        chosenVaccinations.remove(text);
                      });
                    },
                  ),
                )
            ],
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Family History",
              style: GoogleFonts.poppins(
                fontSize:
                    getProportionateScreenWidth(kPhoneFontSizeDefaultText),
                fontWeight: FontWeight.w500,
                color: kPrimaryColor,
              ),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(5)),
          familyHistoryTextFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Notes",
              style: GoogleFonts.poppins(
                fontSize:
                    getProportionateScreenWidth(kPhoneFontSizeDefaultText),
                fontWeight: FontWeight.w500,
                color: kPrimaryColor,
              ),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(5)),
          notesTextFormField(),
          SizedBox(height: getProportionateScreenHeight(10)),
          DefaultButton(
            text: "Confirm",
            press: () async {
              if (_formKey.currentState!.validate()) {
                // If the form is valid, display a snackbar. In the real world,
                // you'd often call a server or save the information in a database.
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Processing Data'),
                  ),
                );
                try {
                  //   UserCredential userCredential = await FirebaseAuth.instance
                  //       .createUserWithEmailAndPassword(
                  //           email: _emailController.text,
                  //           password: _passwordController.text);
                  final response = await http.post(
                      Uri.parse(
                          "${dotenv.env['API_URL1']}/user/set-medicalCard"),
                      // Uri.parse("${dotenv.env['API_URL2']}/user/signup"),
                      // Uri.parse("${dotenv.env['API_URL3']}/user/signup"),
                      headers: {
                        'Content-Type': 'application/json',
                        'Authorization':
                            "Bearer ${dotenv.env['API_KEY_BEARER']}"
                      },
                      body: jsonEncode({
                        'email': globals.user?.email,
                        'gender': _genderController.text,
                        'dateOfBirth': selectedDate.toString(),
                        'height': _heightController.text == ""
                            ? null
                            : _heightController.text,
                        'weight': _weightController.text == ""
                            ? null
                            : _weightController.text,
                        'bloodGroup': _bloodgroupController.text,
                        'primaryMedicalConditions': chosenMedicalConditons,
                        'allergies': chosenAllergies,
                        'vaccinations': chosenVaccinations,
                        'familyHistory': _familyHistoryController.text,
                        'notes': _notesController.text
                      }));
                  if (response.statusCode == 200) {
                    var data = json.decode(response.body);
                    globals.user = UserModel.fromJson(data);
                    Navigator.pushNamed(context, HomeScreen.routeName);
                  }
                } catch (e) {
                    print(e);
                  AlertDialog(
                    title: const Text("Error"),
                    content: Text(e.toString()),
                  );
                  //   if (e.code == 'weak-password') {
                  //     ScaffoldMessenger.of(context).showSnackBar(
                  //       const SnackBar(
                  //         content: Text('The password provided is too weak.'),
                  //       ),
                  //     );
                  //     _firstNameController.clear();
                  //     _lastNameController.clear();
                  //     _emailController.clear();
                  //     _passwordController.clear();
                  //     _confirmPasswordController.clear();
                  //   } else if (e.code == 'email-already-in-use') {
                  //     ScaffoldMessenger.of(context).showSnackBar(
                  //       const SnackBar(
                  //         content:
                  //             Text('The account already exists for that email.'),
                  //       ),
                  //     );
                  //     _firstNameController.clear();
                  //     _lastNameController.clear();
                  //     _emailController.clear();
                  //     _passwordController.clear();
                  //     _confirmPasswordController.clear();
                  //   }
                  // } catch (e) {
                  //   print(e);
                }
              }
              // Navigator.pushNamed(context, SigninScreen.routeName);
            },
          ),
        ]),
      ),
    );
  }

  // passwordDialog(BuildContext context) {
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
  //     title: Text("Password Instructons",
  //         style: TextStyle(
  //           fontFamily: GoogleFonts.poppins().fontFamily,
  //           color: Colors.black,
  //           fontSize:
  //               kPhoneBreakpoint > MediaQuery.of(context).size.width * 0.035
  //                   ? MediaQuery.of(context).size.width * 0.035
  //                   : MediaQuery.of(context).orientation == Orientation.portrait
  //                       ? MediaQuery.of(context).size.width * 0.035
  //                       : MediaQuery.of(context).size.width * 0.025,
  //         )),
  //     content: Text(
  //         "Must be between 8 and 16 characters.\nMust contain at least one uppercase letter.\nMust contain at least one lowercase letter.\nMust contain at least one number.",
  //         style: TextStyle(
  //           fontFamily: GoogleFonts.poppins().fontFamily,
  //           // color: Colors.black,
  //         )),
  //   );

  //   // show the dialog
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }

  listDialog(BuildContext context) {
    // set up the AlertDialog
    Orientation _orientation = MediaQuery.of(context).orientation;
    Size _size = MediaQuery.of(context).size;
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
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: const Text("Male"),
            onTap: () {
              _genderController.text = "Male";
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text("Female"),
            onTap: () {
              _genderController.text = "Female";
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text("Other"),
            onTap: () {
              _genderController.text = "Other";
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(1950),
      lastDate: DateTime(DateTime.now().year - 18),
      builder: (BuildContext context, child) {
        Orientation _orientation = MediaQuery.of(context).orientation;
        Size _size = MediaQuery.of(context).size;
        return Theme(
          data: ThemeData.light().copyWith(
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: kPhoneBreakpoint > _size.width
                    ? BorderRadius.circular(15)
                    : _orientation == Orientation.portrait
                        ? BorderRadius.circular(20)
                        : BorderRadius.circular(25),
              ),
              backgroundColor: Colors.white,
              titleTextStyle: TextStyle(
                fontFamily: GoogleFonts.poppins().fontFamily,
                color: Colors.black,
                fontSize: kPhoneBreakpoint >
                        MediaQuery.of(context).size.width * 0.035
                    ? MediaQuery.of(context).size.width * 0.035
                    : MediaQuery.of(context).orientation == Orientation.portrait
                        ? MediaQuery.of(context).size.width * 0.035
                        : MediaQuery.of(context).size.width * 0.025,
              ),
              contentTextStyle: TextStyle(
                fontFamily: GoogleFonts.poppins().fontFamily,
                color: Colors.black,
                fontSize: kPhoneBreakpoint >
                        MediaQuery.of(context).size.width * 0.035
                    ? MediaQuery.of(context).size.width * 0.035
                    : MediaQuery.of(context).orientation == Orientation.portrait
                        ? MediaQuery.of(context).size.width * 0.035
                        : MediaQuery.of(context).size.width * 0.025,
              ),
            ),
            primaryColor: kPrimaryColor,
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
            colorScheme: const ColorScheme.light(primary: kPrimaryColor)
                .copyWith(secondary: kLightColor),
          ),
          child: child ?? const Text("No date selected"),
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      var parsedDate = DateFormat('d MMMM y').format(selectedDate);
      _dobController.text = parsedDate;
    }
  }

  TextFormField genderTextFormField() {
    Orientation _orientation = MediaQuery.of(context).orientation;
    Size _size = MediaQuery.of(context).size;
    return TextFormField(
      onTap: () {
        listDialog(context);
      },
      cursorColor: kTextColor,
      textCapitalization: TextCapitalization.words,
      controller: _genderController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Gender is required!';
        }
        return null;
      },
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
        labelText: "Gender",
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
                        kTabletLandscapeFontSizeFieldLabel)),
      ),
    );
  }

  TextFormField dobTextFormField() {
    Orientation _orientation = MediaQuery.of(context).orientation;
    Size _size = MediaQuery.of(context).size;
    return TextFormField(
      cursorColor: kTextColor,
      readOnly: true,
      onTap: () {
        _selectDate(context);
      },
      textCapitalization: TextCapitalization.words,
      controller: _dobController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Date of birth is required!';
        }
        return null;
      },
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
        labelText: "Date of Birth",
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
                        kTabletLandscapeFontSizeFieldLabel)),
      ),
    );
  }

  TextFormField heightTextFormField() {
    Orientation _orientation = MediaQuery.of(context).orientation;
    Size _size = MediaQuery.of(context).size;
    return TextFormField(
      cursorColor: kTextColor,
      keyboardType: TextInputType.number,
      controller: _heightController,
      validator: (value) {
        return null;
      },
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
        labelText: "Height (cm) (optional)",
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
                        kTabletLandscapeFontSizeFieldLabel)),
      ),
    );
  }

  TextFormField weightTextFormField() {
    Orientation _orientation = MediaQuery.of(context).orientation;
    Size _size = MediaQuery.of(context).size;
    return TextFormField(
      cursorColor: kTextColor,
      keyboardType: TextInputType.number,
      controller: _weightController,
      validator: (value) {
        return null;
      },
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
        labelText: "Weight (kg) (optional)",
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
                        kTabletLandscapeFontSizeFieldLabel)),
      ),
    );
  }

  TextFormField bloodgroupTextFormField() {
    Orientation _orientation = MediaQuery.of(context).orientation;
    Size _size = MediaQuery.of(context).size;
    return TextFormField(
      cursorColor: kTextColor,
      controller: _bloodgroupController,
      validator: (value) {
        return null;
      },
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
        labelText: "Blood Group",
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
                        kTabletLandscapeFontSizeFieldLabel)),
      ),
    );
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
              'chosenOptions': chosenOptions,
              'searchType': 'medicalCardSetup',
            });
        setState(() {
          if (chosenOptionsNew != null) {
            chosenMedicalConditons = chosenOptionsNew as List<String>;
          }
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
        hintText: "Search (Optional)",
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

  TextFormField familyHistoryTextFormField() {
    Orientation _orientation = MediaQuery.of(context).orientation;
    Size _size = MediaQuery.of(context).size;
    return TextFormField(
      cursorColor: kTextColor,
      controller: _familyHistoryController,
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
      maxLines: 6,
      decoration: InputDecoration(
        hintText: "Optional",
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

  TextFormField notesTextFormField() {
    Orientation _orientation = MediaQuery.of(context).orientation;
    Size _size = MediaQuery.of(context).size;
    return TextFormField(
      cursorColor: kTextColor,
      controller: _notesController,
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
      maxLines: 6,
      decoration: InputDecoration(
        hintText: "Optional",
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
