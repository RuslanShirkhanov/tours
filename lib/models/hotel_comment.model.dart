import 'package:xml/xml.dart';

import 'unsigned.dart';

class HotelCommentModel {
  final String userName;
  final String date;
  final U<int> rate;

  final String positive;
  final String negative;

  const HotelCommentModel({
    required this.userName,
    required this.date,
    required this.rate,
    required this.positive,
    required this.negative,
  });

  static HotelCommentModel serialize(XmlElement data) => HotelCommentModel(
        userName: data.getElement('b:UserName')!.innerText.trim(),
        date: data.getElement('b:CreateDateFormatted')!.innerText.trim(),
        rate: U(int.parse(data.getElement('b:Rate')!.innerText.trim())),
        positive: () {
          final text = data.getElement('b:Positive')!.innerText.trim();
          return text.isEmpty ? text : text.substring(9, text.length - 1 - 9);
        }(),
        negative: () {
          final text = data.getElement('b:Negative')!.innerText.trim();
          return text.isEmpty ? text : text.substring(9, text.length - 1 - 9);
        }(),
      );
}
