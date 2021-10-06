import 'package:flutter/material.dart';

class FormSubmitWidget extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  final Color textColor;
  final Color backgroundColor;

  const FormSubmitWidget({
    Key? key,
    required this.text,
    required this.onTap,
    this.textColor = Colors.white,
    this.backgroundColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 170.0,
        height: 45.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: backgroundColor,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.normal,
              fontSize: 20.0,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
