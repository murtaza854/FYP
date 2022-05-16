import 'package:app/screens/comingSoon/coming_soon.dart';
import 'package:app/screens/formPage/components/address_add.dart';
import 'package:app/screens/formPage/components/name_change.dart';
import 'package:flutter/material.dart';

class FormPageScreen extends StatelessWidget {
  static String routeName = "/formPage";
  const FormPageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map;
    final formType = arguments['formType'] as String;
    String title = '';
    Widget screen = Container();
    if (formType == 'name') {
      screen = NameChange();
      title = 'Name Change';
    } else if (formType == 'address') {
      screen = const AddressAdd();
      title = 'Address Add';
    } else if (formType == 'email') {
      screen = const ComingSoonScreen();
      title = 'Email Change';
    } else if (formType == 'password') {
      screen = const ComingSoonScreen();
      title = 'Password Change';
    }
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(title, style: const TextStyle(color: Colors.black)),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
      body: screen,
    ));
  }
}
