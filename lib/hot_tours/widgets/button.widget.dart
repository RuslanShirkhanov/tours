import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const ButtonWidget({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        height: 40.0,
        decoration: BoxDecoration(
          color: const Color(0xffdc2323),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset('assets/flame.svg'),
            const SizedBox(width: 6.0),
            Text(
              text,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w400,
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
