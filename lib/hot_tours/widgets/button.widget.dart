import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

class ButtonWidget extends StatelessWidget {
  final bool isActive;
  final String text;
  final VoidCallback onTap;

  const ButtonWidget({
    Key? key,
    required this.isActive,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => AnimatedOpacity(
        duration: const Duration(milliseconds: 350),
        opacity: isActive ? 1.0 : 0.5,
        child: GestureDetector(
          onTap: isActive ? onTap : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            height: 40.0,
            decoration: BoxDecoration(
              color: const Color(0xffdc2323),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SvgPicture.asset('assets/flame.svg'),
                const SizedBox(width: 10.0),
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
        ),
      );
}
