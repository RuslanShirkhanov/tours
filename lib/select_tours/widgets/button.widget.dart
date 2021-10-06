import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final bool isActive;
  final VoidCallback onTap;

  final Color textColor;
  final Color borderColor;
  final Color backgroundColor;

  final bool isFlexible;
  final double width;
  final double height;

  const ButtonWidget({
    Key? key,
    required this.text,
    required this.isActive,
    required this.onTap,
    this.isFlexible = false,
    this.width = 110.0,
    this.height = 40.0,
    this.textColor = Colors.white,
    this.borderColor = const Color(0xff2eaeee),
    this.backgroundColor = const Color(0xff2eaeee),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: isActive ? onTap : () {},
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 350),
          opacity: isActive ? 1 : 0.5,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            width: isFlexible ? null : width,
            height: height,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: backgroundColor,
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Text(
              text,
              textAlign: TextAlign.center,
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
