import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

class CheckboxWidget extends StatelessWidget {
  final bool isActive;
  final String text;
  final void Function(bool) onToggle;

  const CheckboxWidget({
    Key? key,
    required this.isActive,
    required this.text,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () => onToggle(!isActive),
            child: Container(
              width: 16.0,
              height: 16.0,
              decoration: BoxDecoration(
                color: const Color(0xffb4b4b4),
                borderRadius: BorderRadius.circular(3.0),
              ),
              child: isActive
                  ? SvgPicture.asset('assets/mark.svg')
                  : const SizedBox(),
            ),
          ),
          const SizedBox(width: 10.0),
          Text(
            text,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              fontSize: 12.0,
              color: Color(0xff7d7d7d),
            ),
          ),
        ],
      );
}
