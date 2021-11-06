import 'package:flutter/material.dart';

import 'package:hot_tours/models/star.model.dart';

import 'package:hot_tours/utils/show_route.dart';

import 'package:hot_tours/widgets/nav_bar.widget.dart';
import 'package:hot_tours/widgets/feedback_button.widget.dart';
import 'package:hot_tours/widgets/select_stars.widget.dart';

import 'package:hot_tours/routes/hub.route.dart';

void showFeedbackRoute(BuildContext context) => showRoute<Object>(
      removeUntil: true,
      context: context,
      builder: (_) => PageRouteBuilder(
        pageBuilder: (context, fst, snd) => const FeedbackRoute(),
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

class FeedbackRoute extends StatefulWidget {
  const FeedbackRoute({Key? key}) : super(key: key);

  @override
  State<FeedbackRoute> createState() => _FeedbackRouteState();
}

class _FeedbackRouteState extends State<FeedbackRoute> {
  late List<StarModel> selectedStars;

  @override
  void initState() {
    super.initState();
    selectedStars = StarModel.getStars.getRange(0, 4).toList();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              NavBarWidget(
                hasSectionIndicator: false,
                title: 'Заявка отправлена',
                hasSubtitle: false,
                backgroundColor: const Color(0xffeba627),
                hasBackButton: true,
                hasLoadingIndicator: false,
              ),
              const SizedBox(height: 50.0),
              const Text(
                'Спасибо,\nВаша заявка отправлена',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 20.0,
                  color: Color(0xff4d4948),
                ),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'В ближайшее время с Вами\nсвяжется наш менеджер',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal,
                  fontSize: 18.0,
                  color: Color(0xff0093dd),
                ),
              ),
              const SizedBox(height: 85.0),
              const Text(
                'Понравилось приложение?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal,
                  fontSize: 20.0,
                  color: Color(0xffdb6221),
                ),
              ),
              const SizedBox(height: 10.0),
              const Text(
                'Оцените нас:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal,
                  fontSize: 18.0,
                  color: Color(0xff7d7d7d),
                ),
              ),
              const SizedBox(height: 35.0),
              SelectStarsWidget(
                stars: StarModel.getStars,
                onSelect: (value) => setState(() => selectedStars = value),
              ),
              const SizedBox(height: 45.0),
              FeedbackButtonWidget(
                text: 'Оценить',
                textColor: Colors.white,
                backgroundColor: const Color(0xffeba627),
                onTap: () {}, // !!!
              ),
              const SizedBox(height: 30.0),
              FeedbackButtonWidget(
                text: 'Не сейчас',
                textColor: Colors.white,
                backgroundColor: const Color(0xff2eaeee),
                onTap: () => showHubRoute(context, removeUntil: true),
              ),
            ],
          ),
        ),
      );
}
