import 'package:flutter/material.dart';

import 'package:hot_tours/api.dart';

import 'package:hot_tours/utils/reqs.dart';
import 'package:hot_tours/utils/show_route.dart';

import 'package:hot_tours/widgets/header.widget.dart';
import 'package:hot_tours/select_tour/widgets/button.widget.dart';

import 'package:hot_tours/routes/hub.route.dart';

void showRequestErrorRoute({
  required BuildContext context,
  required ReqKind kind,
  required String data,
}) =>
    showRoute<String>(
      context: context,
      model: data,
      builder: (currentData) => PageRouteBuilder(
        pageBuilder: (context, fst, snd) => RequestErrorRoute(
          onContinue: () => Api.makeCreateLeadRequest(
            context: context,
            kind: kind,
            note: data,
            isRepeated: true,
          ),
        ),
        transitionsBuilder: (context, fst, snd, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: fst.drive(tween),
            child: child,
          );
        },
      ),
    );

class RequestErrorRoute extends StatelessWidget {
  final void Function() onContinue;

  const RequestErrorRoute({
    Key? key,
    required this.onContinue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: HeaderWidget(
                hasBackButton: true,
                hasSectionIndicator: false,
                hasSubtitle: false,
                title: 'Заявка отправляется',
                backgroundColor: const Color(0xff2eaeee),
                hasLoadingIndicator: false,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 48.0),
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 40.0),
                    const Text(
                      'Ваша заявка не отправлена',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.normal,
                        fontSize: 22.0,
                        color: Color(0xffdc2323),
                      ),
                    ),
                    const SizedBox(height: 40.0),
                    const Text(
                      'Проверьте подключение к интернету и попробуйте ещё раз',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 18.0,
                        color: Color(0xff4d4948),
                      ),
                    ),
                    const SizedBox(height: 40.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ButtonWidget(
                          isFlexible: true,
                          text: 'Отправить снова',
                          isActive: true,
                          onTap: onContinue,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ButtonWidget(
                          isFlexible: true,
                          text: 'Отмена',
                          isActive: true,
                          onTap: () => showHubRoute(context, removeUntil: true),
                          textColor: const Color(0xffa0a0a0),
                          backgroundColor: Colors.white,
                          borderColor: const Color(0xffb4b4b4),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
