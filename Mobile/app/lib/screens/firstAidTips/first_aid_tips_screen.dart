import 'dart:convert';

import 'package:app/screens/formPage/form_page_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../components/arrow_button.dart';
import '../../../constants.dart';
import '../../../globals.dart' as globals;
import '../../../size_config.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FirstAidTipsScreen extends StatefulWidget {
  static const routeName = '/firstAidTips';
  const FirstAidTipsScreen({Key? key}) : super(key: key);

  @override
  State<FirstAidTipsScreen> createState() => _FirstAidTipsScreenState();
}

class _FirstAidTipsScreenState extends State<FirstAidTipsScreen> {
  List<Map> tips = [];
  @override
  void initState() {
    super.initState();
    getTips();
  }

  getTips() async {
    final response = await http.get(
      Uri.parse("${dotenv.env['API_URL1']}/user/get-first-aid-tips"),
      // Uri.parse("${dotenv.env['API_URL2']}/user/signup"),
      // Uri.parse("${dotenv.env['API_URL3']}/user/signup"),
      // "${dotenv.env['API_URL3']}/user/get-logged-in-user"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': "Bearer ${dotenv.env['API_KEY_BEARER']}"
      },
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        tips = data;
      });
    } else {
      print('Failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'First Aid Tips',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(30),
              vertical: getProportionateScreenHeight(20),
            ),
            child: Column(
              children: [
                SizedBox(height: getProportionateScreenHeight(10)),
                for (var tip in tips)
                  GestureDetector(
                    onTap: () {},
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
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      child: ListTile(
                        title: Text(
                          tip['title'],
                          style: TextStyle(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                // }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
