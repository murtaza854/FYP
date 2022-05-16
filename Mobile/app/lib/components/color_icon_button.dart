import 'package:flutter/material.dart';
import '../size_config.dart';

class ColorIconButton extends StatefulWidget {
  final bool iconFirst;
  final IconData setIcon;
  final Color color;
  final String topText;
  final String bottomText;
  final Function onPressed;
  const ColorIconButton({
    Key? key,
    required this.iconFirst,
    required this.color,
    required this.topText,
    required this.bottomText,
    required this.setIcon,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<ColorIconButton> createState() => _ColorIconButtonState();
}

class _ColorIconButtonState extends State<ColorIconButton> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          widget.onPressed();
        },
        style: TextButton.styleFrom(
            backgroundColor: widget.color,
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(15),
              vertical: getProportionateScreenWidth(15),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            )),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  widget.topText,
                  textAlign: widget.iconFirst ? TextAlign.end : TextAlign.start,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: getProportionateScreenWidth(20),
                  ),
                ),
                Icon(
                  widget.setIcon,
                  color: Colors.white,
                  size: widget.iconFirst ? 0 : getProportionateScreenWidth(40),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  widget.setIcon,
                  color: Colors.white,
                  size: widget.iconFirst ? getProportionateScreenWidth(40) : 0,
                ),
                Text(
                  widget.bottomText,
                  textAlign: widget.iconFirst ? TextAlign.end : TextAlign.start,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: getProportionateScreenWidth(20),
                  ),
                ),
              ],
            )
          ],
        ));
  }
}

class PushNotification {
  PushNotification({
    this.title,
    this.body,
  });
  String? title;
  String? body;
}
