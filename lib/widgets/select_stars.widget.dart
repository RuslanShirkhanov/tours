import 'package:flutter/material.dart';

import 'package:hot_tours/utils/map_to_list.dart';

import 'package:hot_tours/models/star.model.dart';

import 'package:hot_tours/widgets/star.widget.dart';

class SelectStarsWidget extends StatelessWidget {
  final List<StarModel> stars;
  final void Function(List<StarModel>) onSelect;

  const SelectStarsWidget({
    Key? key,
    required this.stars,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final all = StarModel.getStars.toList();
    return SizedBox(
      width: 200.0,
      height: 45.0,
      child: Row(
        children: all.mapToList(
          (value, index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: StarWidget(
              radius: 30.0,
              isActive:
                  stars.where((star) => value.name == star.name).isNotEmpty,
              onSelect: () => onSelect(
                all.getRange(0, index + 1).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
