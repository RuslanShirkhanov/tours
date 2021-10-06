import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import 'package:hot_tours/api.dart';

import 'package:hot_tours/utils/reqs.dart';
import 'package:hot_tours/utils/show_route.dart';

import 'package:hot_tours/models/unsigned.dart';
import 'package:hot_tours/models/abstract_data.model.dart';

import 'package:hot_tours/widgets/header.widget.dart';
import 'package:hot_tours/select_tour/widgets/form.widget.dart';

import 'package:hot_tours/routes/rules.route.dart';

void showFormRoute({
  required BuildContext context,
  required AbstractDataModel data,
}) =>
    showRoute<AbstractDataModel>(
      context: context,
      model: data,
      builder: (currentData) => PageRouteBuilder(
        pageBuilder: (context, fst, snd) => FormRoute(
          data: currentData!,
          onContinue: (newData) => Api.makeCreateLeadRequest(
            context: context,
            kind: ReqKind.select,
            note: newData.toString(),
          ),
        ),
        transitionsBuilder: (context, fst, snd, child) {
          const begin = Offset(1.0, 0.0);
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

class FormRoute extends StatelessWidget {
  final AbstractDataModel data;
  final void Function(AbstractDataModel) onContinue;

  const FormRoute({
    Key? key,
    required this.data,
    required this.onContinue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            HeaderWidget(
              sectionsCount: U<int>(6),
              sectionIndex: U<int>(5),
              hasSectionIndicator: true,
              title: 'Заявка на тур',
              hasSubtitle: false,
              backgroundColor: const Color(0xff2eaeee),
              hasBackButton: true,
              hasLoadingIndicator: false,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                  top: 30.0,
                  bottom: 20.0,
                ),
                child: Column(
                  children: <Widget>[
                    const Text(
                      'Введите Ваше имя и телефон:',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.normal,
                        fontSize: 20.0,
                        color: const Color(0xff0093dd),
                      ),
                    ),
                    const SizedBox(height: 55.0),
                    FormWidget(
                      onSubmit: (formData) => onContinue(
                        data.setName(formData.name).setNumber(formData.number),
                      ),
                    ),
                    const SizedBox(height: 55.0),
                    const SizedBox(
                      width: 320.0,
                      child: const Text(
                        'Запрос не является бронированием тура. Наш специалист\nсвяжется с Вами и предоставит подробную информацию о туре.',
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.normal,
                          fontSize: 10.0,
                          color: const Color(0xff4d4948),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    SizedBox(
                      width: 320.0,
                      child: RichText(
                        text: TextSpan(
                          children: <InlineSpan>[
                            TextSpan(
                              text: 'Отправляя запрос, Вы подтверждаете ',
                            ),
                            TextSpan(
                              text: 'согласие',
                              style: TextStyle(
                                color: Color(0xff0093dd),
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => showRulesRoute(context),
                            ),
                            TextSpan(
                              text: ' на обработку персональных данных.',
                            ),
                          ],
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.normal,
                            fontSize: 10.0,
                            color: Color(0xff4d4948),
                          ),
                        ),
                      ),
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