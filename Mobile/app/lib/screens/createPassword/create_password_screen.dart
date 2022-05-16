import 'package:app/responsive.dart';
import 'package:flutter/material.dart';

import '../../size_config.dart';
import 'components/mobile_create_new_password.dart';

class CreatePasswordScreen extends StatefulWidget {
  static String routeName = "/create-password";
  const CreatePasswordScreen({Key? key}) : super(key: key);

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Responsive(
      mobile: const MobileCreateNewPassword(),
      tablet: Container(),
    );
  }
}