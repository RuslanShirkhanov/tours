import 'package:flutter/material.dart';

import 'package:hot_tours/api.dart';

import 'package:hot_tours/utils/narrow.dart';
import 'package:hot_tours/utils/sorted.dart';
import 'package:hot_tours/utils/show_route.dart';

import 'package:hot_tours/models/tour.model.dart';
import 'package:hot_tours/models/unsigned.dart';

import 'package:hot_tours/search_tours/models/data.model.dart';

import 'package:hot_tours/widgets/header.widget.dart';
import 'package:hot_tours/widgets/image_widget.dart';
import 'package:hot_tours/widgets/shown_stars.widget.dart';
import 'package:hot_tours/select_tours/widgets/button.widget.dart';

void showSearchResultsRoute({
  required BuildContext context,
  required DataModel data,
  required List<TourModel> tours,
}) =>
    showRoute<DataModel>(
      context: context,
      model: data,
      builder: (currentData) => PageRouteBuilder(
        pageBuilder: (context, fst, snd) => SearchResultsRoute(
          data: currentData!,
          tours: tours,
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

@immutable
class SearchResultsRoute extends StatelessWidget {
  final DataModel data;
  final List<TourModel> tours;

  const SearchResultsRoute({
    Key? key,
    required this.data,
    required this.tours,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _tours = tours
        .sorted((a, b) => a.hotelName.compareTo(b.hotelName))
        .narrow((a, b) => a.hotelName == b.hotelName);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            HeaderWidget(
              hasSectionIndicator: false,
              title: 'Результаты поиска',
              hasSubtitle: false,
              backgroundColor: const Color(0xff2eaeee),
              hasBackButton: true,
              hasLoadingIndicator: false,
            ),
            Expanded(
              child: ListView(
                children: _tours
                    .map(
                      (collection) => Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: _HotelCardWidget(
                          tours: collection,
                          onTap: () {}, // !!!
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

@immutable
class _HotelCardWidget extends StatelessWidget {
  final List<TourModel> tours;
  final void Function() onTap;

  const _HotelCardWidget({
    Key? key,
    required this.tours,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 360.0,
          height: 320.0,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xffd6d6d6)),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            tours.first.hotelName,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        ShownStarsWidget(data: tours.first.hotelStar),
                      ],
                    ),
                    const SizedBox(height: 3.0),
                    Text(
                      tours.first.targetCityName,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 12.0,
                        color: Color(0xff7d7d7d),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: tours.first.photosCount.value == 0
                      ? blackPlug()
                      : NetworkImageWidget(
                          url: Api.makeImageUri(
                            hotelId: tours.first.hotelId,
                            imageNumber: const U<int>(0),
                          ),
                        ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(
                    left: 17.0,
                    top: 13.0,
                    right: 23.0,
                  ),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 10.0),
                      Row(
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              tours.first.hotelDesc.isEmpty
                                  ? 'Описание отеля временно отсутствует. Ведётся добавление информации.'
                                  : tours.first.hotelDesc,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 5,
                              style: const TextStyle(
                                fontFamily: 'Roboto',
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.normal,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ButtonWidget(
                            isFlexible: true,
                            isActive: true,
                            text:
                                '${tours.first.cost} ${tours.first.costCurrency.toUpperCase() == 'RUB' ? 'р.' : tours.first.costCurrency}',
                            onTap: () {}, // !!!
                          ),
                          const SizedBox(width: 8.0),
                          const Text(
                            'за номер',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                              fontSize: 13.0,
                              color: Color(0xff7d7d7d),
                            ),
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
