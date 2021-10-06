import 'package:flutter/material.dart';

import 'package:hot_tours/utils/show_route.dart';

import 'package:hot_tours/widgets/header.widget.dart';

void showRulesRoute(BuildContext context) => showRoute<Object?>(
      context: context,
      model: null,
      builder: (data) => PageRouteBuilder(
        pageBuilder: (context, fst, snd) => const RulesRoute(),
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

class RulesRoute extends StatelessWidget {
  const RulesRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: HeaderWidget(
                  hasBackButton: true,
                  hasSubtitle: false,
                  hasSectionIndicator: false,
                  title: 'Согласие',
                  hasLoadingIndicator: false,
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 48.0),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20.0,
                      horizontal: 20.0,
                    ),
                    child: Text(
                      '''
Пользуясь данным интернет ресурсом, в порядке ст. 9 Федерального закона от 27.07.2006 N 152-ФЗ «О персональных данных» свободно своей волей и в своих интересах пользователь сайта все-туры.рф даёт согласие на автоматизированную, а также без использования средств автоматизации обработку, хранение, систематизацию своих персональных данных и на передачу (в том числе на трансграничную) своих персональных данных третьим лицам.
                
Согласие дается на обработку следующих моих персональных данных: фамилия, имя, отчество; год, месяц, день рождения; пол; гражданство; адрес места жительства; номер телефона; паспортные данные; данные заграничного паспорта; пользовательские данные (сведения о местоположении; тип и версия ОС; тип и версия Браузера; тип устройства и разрешение его экрана; источник откуда пришел на сайт пользователь; с какого сайта или по какой рекламе; язык ОС и Браузера; какие страницы открывает и на какие кнопки нажимает пользователь; ip-адрес); иная информация.
                
Цель обработки персональных данных: обработка входящих запросов физических лиц с целью оказания услуг и консультирования; аналитики действий физического лица на веб-сайте и функционирования веб-сайта; проведение рекламных и новостных рассылок.
                
Персональные данные не являются общедоступными. Согласие может быть отозвано пользователем в письменной форме.
                
Также пользователь подтверждает, что ознакомлен(а) с правами субъектов персональных данных, закрепленными в главе 3 ФЗ «О персональных данных».
                        '''
                          .trim(),
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.normal,
                        fontSize: 18.0,
                        color: Color(0xff4d4948),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
