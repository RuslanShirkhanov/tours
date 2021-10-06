import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:hot_tours/models/unsigned.dart';

class HeaderWidget extends StatelessWidget {
  final U<int> sectionsCount;
  final U<int> sectionIndex;
  final bool hasSectionIndicator;

  final String title;
  final String subtitle;
  final bool hasSubtitle;

  final Color textColor;
  final Color backgroundColor;
  final bool hasBackButton;

  final bool isLoading;
  final bool hasLoadingIndicator;
  final Color loadingIndicatorColor;

  const HeaderWidget({
    Key? key,
    this.sectionsCount = const U<int>(1),
    this.sectionIndex = const U<int>(0),
    required this.hasSectionIndicator,
    required this.title,
    this.subtitle = '',
    required this.hasSubtitle,
    this.textColor = Colors.white,
    this.backgroundColor = Colors.black,
    required this.hasBackButton,
    this.isLoading = false,
    required this.hasLoadingIndicator,
    this.loadingIndicatorColor = Colors.white,
  })  : assert(sectionsCount > const U<int>(0)),
        assert(sectionIndex + const U<int>(1) <= sectionsCount),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 48.0,
          color: backgroundColor,
          child: Stack(
            children: <Widget>[
              if (hasBackButton)
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 14.0),
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: SvgPicture.asset(
                      'assets/arrow_back.svg',
                      color: textColor,
                    ),
                  ),
                ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 24.0,
                    color: textColor,
                  ),
                ),
              ),
              if (hasLoadingIndicator)
                Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 14.0),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 350),
                    opacity: isLoading ? 1.0 : 0.0,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: SizedBox(
                        width: 24.0,
                        height: 24.0,
                        child: CircularProgressIndicator(
                          color: loadingIndicatorColor,
                          strokeWidth: 2.5,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (hasSectionIndicator)
          Container(
            width: double.infinity,
            height: 5.0,
            color: const Color(0xffc9f1c8),
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor:
                  ((sectionIndex + const U<int>(1)) / sectionsCount).toDouble(),
              child: Container(color: const Color(0xff04ce00)),
            ),
          ),
        if (hasSubtitle)
          Container(
            width: double.infinity,
            height: 30.0,
            color: const Color(0xff93d0f4),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                subtitle,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 18.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
