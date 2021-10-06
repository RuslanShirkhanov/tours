import 'package:flutter/material.dart';

import 'package:hot_tours/select_tours/widgets/button.widget.dart';

enum FooterButtonKind { ok, cancel, reset }

extension on FooterButtonKind {
  String toKey() {
    switch (this) {
      case FooterButtonKind.ok:
        return 'ok';
      case FooterButtonKind.cancel:
        return 'cancel';
      case FooterButtonKind.reset:
        return 'reset';
      default:
        return '';
    }
  }
}

class FooterButtonModel {
  final FooterButtonKind kind;
  final bool isActive;
  final VoidCallback onTap;

  const FooterButtonModel({
    required this.kind,
    required this.isActive,
    required this.onTap,
  });
}

class FooterButtonWidget extends StatelessWidget {
  final FooterButtonModel data;

  const FooterButtonWidget({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ButtonWidget(
        text: const {
          'ok': 'ОК',
          'cancel': 'отмена',
          'reset': 'сброс',
        }[data.kind.toKey()]!,
        textColor: const {
          'ok': Colors.white,
          'cancel': Color(0xffa0a0a0),
          'reset': Color(0xffa0a0a0),
        }[data.kind.toKey()]!,
        borderColor: const {
          'ok': Color(0xff2eaeee),
          'cancel': Color(0xffb4b4b4),
          'reset': Color(0xffb4b4b4),
        }[data.kind.toKey()]!,
        backgroundColor: const {
          'ok': Color(0xff2eaeee),
          'cancel': Colors.white,
          'reset': Colors.white,
        }[data.kind.toKey()]!,
        onTap: data.onTap,
        isActive: data.isActive,
      );
}

class FooterWidget extends StatelessWidget {
  final FooterButtonModel ok;
  final FooterButtonModel? cancel;
  final FooterButtonModel? reset;

  const FooterWidget({
    Key? key,
    required this.ok,
    this.cancel,
    this.reset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        height: 70.0,
        color: const Color(0xffececec),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FooterButtonWidget(data: ok),
            if (cancel != null)
              FooterButtonWidget(
                data: cancel!,
              ),
            if (reset != null)
              FooterButtonWidget(
                data: reset!,
              ),
          ],
        ),
      );
}
