import 'package:app/screens/formPage/form_page_screen.dart';
import 'package:flutter/material.dart';

import '../../../components/arrow_button.dart';
import '../../../size_config.dart';

class MobilePersonalInformationScreen extends StatelessWidget {
  const MobilePersonalInformationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Orientation _orientation = MediaQuery.of(context).orientation;
    Size _size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Personal Information',
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
        body: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(30),
                      vertical: getProportionateScreenHeight(20),
                    ),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: getProportionateScreenHeight(40)),
                        ArrowButton(
                            press: () {
                              Navigator.pushNamed(
                                  context, FormPageScreen.routeName,
                                  arguments: {
                                    'formType': 'name',
                                  });
                            },
                            text: 'Name',
                            icon: Icons.keyboard_arrow_right),
                        SizedBox(height: getProportionateScreenHeight(10)),
                        ArrowButton(
                            press: () {
                              Navigator.pushNamed(
                                  context, FormPageScreen.routeName,
                                  arguments: {
                                    'formType': 'email',
                                  });
                            },
                            text: 'Email',
                            icon: Icons.keyboard_arrow_right),
                        SizedBox(height: getProportionateScreenHeight(10)),
                        ArrowButton(
                            press: () {
                              Navigator.pushNamed(
                                  context, FormPageScreen.routeName,
                                  arguments: {
                                    'formType': 'password',
                                  });},
                            text: 'Password',
                            icon: Icons.keyboard_arrow_right),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(40)),
            ],
          ),
        ),
      ),
    );
  }
}
