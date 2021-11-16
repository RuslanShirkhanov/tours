import 'package:flutter/material.dart';

import 'package:hot_tours/models/hotel_comment.model.dart';

class HotelCommentWidget extends StatelessWidget {
  final HotelCommentModel model;

  const HotelCommentWidget({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              '${model.userName}, ${model.date}, оценка: ${model.rate}',
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
            ),
            if (model.positive.isNotEmpty) const SizedBox(height: 15.0),
            if (model.positive.isNotEmpty)
              const Text(
                'Достоинства:',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                  color: Color(0xff2eaeee),
                ),
              ),
            if (model.positive.isNotEmpty)
              Text(
                model.positive,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.normal,
                  fontSize: 14.0,
                ),
              ),
            if (model.negative.isNotEmpty) const SizedBox(height: 15.0),
            if (model.negative.isNotEmpty)
              const Text(
                'Недостатки:',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                  color: Color(0xff2eaeee),
                ),
              ),
            if (model.negative.isNotEmpty)
              Text(
                model.negative,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.normal,
                  fontSize: 14.0,
                ),
              ),
          ],
        ),
      );
}
