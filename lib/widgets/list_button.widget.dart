import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

class ListButtonWidget extends StatelessWidget {
  final bool isFlag;
  final bool isActive;
  final TextAlign textAlign;

  final bool hasCheckbox;
  final bool checkboxStatus;

  final String text;
  final VoidCallback onTap;

  final String path;
  final double width;
  final double height;

  final Color textColor;
  final Color backgroundColor;

  final double? fontSize;

  const ListButtonWidget({
    Key? key,
    this.isFlag = false,
    this.isActive = true,
    this.hasCheckbox = false,
    this.checkboxStatus = false,
    this.text = '',
    this.textAlign = TextAlign.start,
    required this.onTap,
    this.path = '',
    this.width = double.infinity,
    this.height = 45.0,
    this.textColor = const Color(0xff4d4948),
    this.backgroundColor = Colors.white,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Tooltip(
        showDuration: const Duration(milliseconds: 350),
        message: text,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 350),
          opacity: isActive ? 1.0 : 0.5,
          child: SizedBox(
            width: width,
            height: height,
            child: GestureDetector(
              onTap: isActive ? onTap : () {},
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      offset: const Offset(1.0, 1.0),
                      blurRadius: 10.0,
                      color: Colors.black.withAlpha(50),
                    ),
                  ],
                ),
                child: Row(
                  children: <Widget>[
                    if (hasCheckbox)
                      AnimatedContainer(
                        width: 16.0,
                        height: 16.0,
                        alignment: Alignment.center,
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: checkboxStatus
                              ? const Color(0xff2eaeee)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(3.0),
                          border: Border.all(
                            color: const Color(0xffd6d6d6),
                            width: checkboxStatus ? 0.0 : 1.0,
                          ),
                        ),
                        child: checkboxStatus
                            ? SvgPicture.asset('assets/mark.svg')
                            : const SizedBox(),
                      ),
                    if (hasCheckbox) const SizedBox(width: 12.0),
                    if (path.isNotEmpty)
                      SizedBox(
                        width: 26.0,
                        height: 26.0,
                        child: isFlag
                            ? Image.asset(
                                path,
                                package: isFlag ? 'country_icons' : null,
                                errorBuilder: (_, __, ___) {
                                  if (isFlag) {
                                    if (path == 'icons/flags/png/ab.png') {
                                      return Image.asset(
                                        'assets/abkhazia.png',
                                      );
                                    }
                                    return Image.asset(
                                      'assets/international.png',
                                    );
                                  }
                                  return Container(color: Colors.grey);
                                },
                              )
                            : SvgPicture.asset(path),
                      ),
                    if (path.isNotEmpty) const SizedBox(width: 15.0),
                    if (text.isNotEmpty)
                      Flexible(
                        child: Text(
                          text,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.normal,
                            fontSize: fontSize ?? 18.0,
                            color: textColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
