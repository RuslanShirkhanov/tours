import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

class StarWidget extends StatelessWidget {
  final double radius;
  final bool isActive;
  final void Function()? onSelect;

  const StarWidget({
    Key? key,
    required this.radius,
    required this.isActive,
    this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SizedBox(
        width: radius,
        height: radius,
        child: GestureDetector(
          onTap: onSelect == null ? null : () => onSelect!(),
          child: SvgPicture.asset(
            isActive ? 'assets/star_active.svg' : 'assets/star.svg',
          ),
        ),
      );
}
