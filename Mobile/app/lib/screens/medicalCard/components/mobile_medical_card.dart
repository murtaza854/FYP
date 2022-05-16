import 'package:app/components/title_custom.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import '../../../globals.dart' as globals;

class MobileMedicalCardScreen extends StatefulWidget {
  MobileMedicalCardScreen({Key? key}) : super(key: key);

  @override
  State<MobileMedicalCardScreen> createState() =>
      _MobileMedicalCardScreenState();
}

class _MobileMedicalCardScreenState extends State<MobileMedicalCardScreen> {
  @override
  Widget build(BuildContext context) {
    DateTime dob = DateTime.parse(globals.user?.medicalCard['dateOfBirth']);
    String dobString = dob.day.toString() +
        '/' +
        dob.month.toString() +
        '/' +
        dob.year.toString();
    print(globals.user?.medicalCard);
    String height = globals.user?.medicalCard['height'] != null
        ? '${globals.user?.medicalCard['height']} cm'
        : 'N/A';
    String weight = globals.user?.medicalCard['weight'] != null
        ? '${globals.user?.medicalCard['weight']} kg'
        : 'N/A';
    String primaryMedicalConditions = 'N/A';
    if (globals.user?.medicalCard['primaryMedicalConditions'].isNotEmpty) {
      primaryMedicalConditions =
          globals.user?.medicalCard['primaryMedicalConditions'].join(', ');
    }
    String allergies = 'N/A';
    if (globals.user?.medicalCard['allergies'].isNotEmpty) {
      allergies = globals.user?.medicalCard['allergies'].join(', ');
    }
    String vaccinations = 'N/A';
    if (globals.user?.medicalCard['vaccinations'].isNotEmpty) {
      vaccinations = globals.user?.medicalCard['vaccinations'].join(', ');
    }
    String familyHistory = globals.user?.medicalCard['familyHistory'] == '' ? 'N/A' : globals.user?.medicalCard['familyHistory'];
    String notes = globals.user?.medicalCard['notes'] == '' ? 'N/A' : globals.user?.medicalCard['notes'];
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
            'Medical Card',
            style: GoogleFonts.poppins(
              fontSize: getProportionateScreenWidth(kPhoneFontSizeDefaultText),
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
          ),
          child: SingleChildScrollView(
            child: Column(children: [
              SizedBox(height: getProportionateScreenHeight(20)),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: TitleCustom(
                      text: "Basic Information", color: kPrimaryColor)),
              SizedBox(height: getProportionateScreenHeight(10)),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gender',
                          style: GoogleFonts.poppins(
                            fontSize: getProportionateScreenWidth(
                                kPhoneFontSizeDefaultText),
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: getProportionateScreenHeight(5)),
                        Text(
                          '${globals.user?.medicalCard['gender']}',
                          style: GoogleFonts.poppins(
                            fontSize: getProportionateScreenWidth(
                                kPhoneFontSizeDefaultText),
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: getProportionateScreenWidth(20)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DOB',
                          style: GoogleFonts.poppins(
                            fontSize: getProportionateScreenWidth(
                                kPhoneFontSizeDefaultText),
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: getProportionateScreenHeight(5)),
                        Text(
                          dobString,
                          style: GoogleFonts.poppins(
                            fontSize: getProportionateScreenWidth(
                                kPhoneFontSizeDefaultText),
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(10)),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Weight',
                          style: GoogleFonts.poppins(
                            fontSize: getProportionateScreenWidth(
                                kPhoneFontSizeDefaultText),
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: getProportionateScreenHeight(5)),
                        Text(
                          weight,
                          style: GoogleFonts.poppins(
                            fontSize: getProportionateScreenWidth(
                                kPhoneFontSizeDefaultText),
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: getProportionateScreenWidth(20)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Height',
                          style: GoogleFonts.poppins(
                            fontSize: getProportionateScreenWidth(
                                kPhoneFontSizeDefaultText),
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: getProportionateScreenHeight(5)),
                        Text(
                          height,
                          style: GoogleFonts.poppins(
                            fontSize: getProportionateScreenWidth(
                                kPhoneFontSizeDefaultText),
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(10)),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Blood Group',
                          style: GoogleFonts.poppins(
                            fontSize: getProportionateScreenWidth(
                                kPhoneFontSizeDefaultText),
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: getProportionateScreenHeight(5)),
                        Text(
                          globals.user?.medicalCard['bloodGroup'] != null
                              ? '${globals.user?.medicalCard['bloodGroup']}'
                              : 'N/A',
                          style: GoogleFonts.poppins(
                            fontSize: getProportionateScreenWidth(
                                kPhoneFontSizeDefaultText),
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(10)),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: TitleCustom(
                      text: "Primary Medical Conditions",
                      color: kPrimaryColor)),
              SizedBox(height: getProportionateScreenHeight(10)),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          primaryMedicalConditions,
                          style: GoogleFonts.poppins(
                            fontSize: getProportionateScreenWidth(
                                kPhoneFontSizeDefaultText),
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(10)),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: TitleCustom(
                      text: "Allergies",
                      color: kPrimaryColor)),
              SizedBox(height: getProportionateScreenHeight(10)),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          allergies,
                          style: GoogleFonts.poppins(
                            fontSize: getProportionateScreenWidth(
                                kPhoneFontSizeDefaultText),
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(10)),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: TitleCustom(
                      text: "Vaccinations",
                      color: kPrimaryColor)),
              SizedBox(height: getProportionateScreenHeight(10)),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vaccinations,
                          style: GoogleFonts.poppins(
                            fontSize: getProportionateScreenWidth(
                                kPhoneFontSizeDefaultText),
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(10)),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: TitleCustom(
                      text: "Family History",
                      color: kPrimaryColor)),
              SizedBox(height: getProportionateScreenHeight(10)),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          familyHistory,
                          style: GoogleFonts.poppins(
                            fontSize: getProportionateScreenWidth(
                                kPhoneFontSizeDefaultText),
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(10)),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: TitleCustom(
                      text: "Notes",
                      color: kPrimaryColor)),
              SizedBox(height: getProportionateScreenHeight(10)),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notes,
                          style: GoogleFonts.poppins(
                            fontSize: getProportionateScreenWidth(
                                kPhoneFontSizeDefaultText),
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
            ]),
          ),
        ),
      ),
    );
  }
}
