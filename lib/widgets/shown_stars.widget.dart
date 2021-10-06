import 'package:flutter/material.dart';

import 'package:hot_tours/utils/map_to_list.dart';

import 'package:hot_tours/models/star.model.dart';

import 'package:hot_tours/widgets/star.widget.dart';

class ShownStarsWidget extends StatelessWidget {
  final StarModel data;

  const ShownStarsWidget({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stars = StarModel.getStars();
    final currentIndex = stars
        .indexWhere((star) => star.id == data.id || star.name == data.name);

    return Row(
      children: stars.mapToList(
        (star, index) => Padding(
          padding: EdgeInsets.only(left: index == 0 ? 0.0 : 3.0),
          child: StarWidget(
            radius: 15.0,
            isActive: index <= currentIndex,
          ),
        ),
      ),
    );
  }
}
