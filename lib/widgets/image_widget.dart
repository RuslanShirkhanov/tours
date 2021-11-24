import 'package:flutter/material.dart';

Widget blackPlug({
  double? width = double.infinity,
  double? height,
  Color color = Colors.black,
}) =>
    Container(
      width: width,
      height: height,
      color: color,
    );

class NetworkImageWidget extends StatelessWidget {
  final String url;
  final BoxFit fit;
  final Color indicatorColor;
  final Color backgroundColor;

  const NetworkImageWidget({
    Key? key,
    required this.url,
    this.fit = BoxFit.cover,
    this.indicatorColor = Colors.black,
    this.backgroundColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        color: backgroundColor,
        child: Image.network(
          url,
          fit: fit,
          errorBuilder: (_, __, trace) => blackPlug(),
          loadingBuilder: (_, child, event) => event == null
              ? child
              : Center(
                  child: SizedBox(
                    width: 30.0,
                    height: 30.0,
                    child: CircularProgressIndicator(
                      color: indicatorColor,
                      strokeWidth: 2.0,
                    ),
                  ),
                ),
        ),
      );
}
