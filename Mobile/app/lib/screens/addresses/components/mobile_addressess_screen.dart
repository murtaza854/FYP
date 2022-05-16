import 'package:app/screens/formPage/form_page_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../components/arrow_button.dart';
import '../../../constants.dart';
import '../../../globals.dart' as globals;
import '../../../size_config.dart';

class MobileAddressessScreen extends StatefulWidget {
  const MobileAddressessScreen({Key? key}) : super(key: key);

  @override
  State<MobileAddressessScreen> createState() => _MobileAddressessScreenState();
}

class _MobileAddressessScreenState extends State<MobileAddressessScreen> {
  @override
  Widget build(BuildContext context) {
    var addresses = globals.user?.addresses ?? [];
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Addressess'),
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
                SizedBox(height: getProportionateScreenHeight(40)),
                ArrowButton(
                  press: () {
                    Navigator.pushNamed(
                      context,
                      FormPageScreen.routeName,
                      arguments: {
                        'formType': 'address',
                      },
                    );
                  },
                  text: 'Add new address',
                  icon: Icons.keyboard_arrow_right,
                ),
                SizedBox(height: getProportionateScreenHeight(10)),
                for (var address in addresses)
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
                          address['label'] as String,
                          style: TextStyle(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          "${address['addressLine1']}\n${address['addressLine2']}",
                          style: TextStyle(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            color: Colors.black,
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
