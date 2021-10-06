import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:hot_tours/api.dart';

import 'package:hot_tours/models/unsigned.dart';
import 'package:hot_tours/models/tour.model.dart';
import 'package:hot_tours/widgets/image_widget.dart';

class SliderWidget extends HookWidget {
  final TourModel data;

  const SliderWidget({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentIndex = useState(0);
    final photosCount = data.photosCount.value;

    void prev() {
      if (currentIndex.value == 0) {
        currentIndex.value = photosCount - 1;
      } else {
        currentIndex.value = currentIndex.value - 1;
      }
    }

    void next() {
      if (currentIndex.value == photosCount - 1) {
        currentIndex.value = 0;
      } else {
        currentIndex.value = currentIndex.value + 1;
      }
    }

    return SizedBox(
      height: 200.0,
      child: Stack(
        children: <Widget>[
          Align(
            child: SizedBox(
              width: double.infinity,
              child: data.photosCount.value == 0
                  ? blackPlug()
                  : NetworkImageWidget(
                      url: Api.makeImageUri(
                        hotelId: data.hotelId,
                        imageNumber: U<int>(currentIndex.value),
                      ),
                    ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: 35.0,
              height: 30.0,
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Text(
                  '${photosCount == 0 ? 0 : currentIndex.value + 1}/$photosCount',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.normal,
                    fontSize: 11.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: GestureDetector(
                onTap: prev,
                child: Container(
                  width: 26.0,
                  height: 26.0,
                  decoration: const BoxDecoration(
                    color: Color(0xffd6d6d6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.chevron_left),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: GestureDetector(
                onTap: next,
                child: Container(
                  width: 26.0,
                  height: 26.0,
                  decoration: const BoxDecoration(
                    color: Color(0xffd6d6d6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.chevron_right),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
