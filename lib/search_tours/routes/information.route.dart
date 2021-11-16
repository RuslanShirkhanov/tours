import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:hot_tours/utils/show_route.dart';
import 'package:hot_tours/utils/thousands.dart';

import 'package:hot_tours/search_tours/models/data.model.dart';

import 'package:hot_tours/widgets/nav_bar.widget.dart';
import 'package:hot_tours/widgets/slider.widget.dart';
import 'package:hot_tours/search_tours/widgets/header.widget.dart';
import 'package:hot_tours/search_tours/widgets/parameters.widget.dart';
import 'package:hot_tours/select_tours/widgets/button.widget.dart';

import 'package:hot_tours/search_tours/routes/form.route.dart';

void showInformationRoute({
  required BuildContext context,
  required DataModel data,
}) =>
    showRoute<DataModel>(
      context: context,
      model: data,
      builder: (currentData) => PageRouteBuilder(
        pageBuilder: (context, fst, snd) =>
            InformationRoute(data: currentData!),
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

class InformationRoute extends HookWidget {
  final DataModel data;

  const InformationRoute({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            NavBarWidget(
              hasSectionIndicator: false,
              title: 'Информация о туре',
              hasSubtitle: false,
              backgroundColor: const Color(0xff2eaeee),
              hasBackButton: true,
              hasLoadingIndicator: false,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: Scrollbar(
                  controller: scrollController,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xffd6d6d6),
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        children: <Widget>[
                          HeaderWidget(data: data),
                          const SizedBox(height: 10.0),
                          SliderWidget(tour: data.tour!),
                          const SizedBox(height: 10.0),
                          ParametersWidget(data: data),
                          const SizedBox(height: 35.0),
                          BuyButtonWidget(data: data),
                        ],
                      ),
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
}

class BuyButtonWidget extends StatelessWidget {
  final DataModel data;

  const BuyButtonWidget({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Купить',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.normal,
              fontSize: 14.0,
              color: Color(0xff7d7d7d),
            ),
          ),
          const SizedBox(width: 13.0),
          ButtonWidget(
            isFlexible: true,
            isActive: true,
            text:
                '${thousands(data.tour!.cost)} ${data.tour!.costCurrency.toUpperCase() == 'RUB' ? 'р.' : data.tour!.costCurrency}',
            onTap: () => showFormRoute(context: context, data: data),
            borderColor: const Color(0xffeba627),
            backgroundColor: const Color(0xffeba627),
          ),
          const SizedBox(width: 13.0),
          const Text(
            'Купить',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.normal,
              fontSize: 14.0,
              color: Colors.transparent,
            ),
          ),
        ],
      );
}
