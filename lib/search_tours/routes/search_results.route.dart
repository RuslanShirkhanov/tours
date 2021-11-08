import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:hot_tours/api.dart';

import 'package:hot_tours/utils/date.dart';
import 'package:hot_tours/utils/color.dart';
import 'package:hot_tours/utils/narrow.dart';
import 'package:hot_tours/utils/sorted.dart';
import 'package:hot_tours/utils/string.dart';
import 'package:hot_tours/utils/thousands.dart';
import 'package:hot_tours/utils/show_route.dart';

import 'package:hot_tours/models/tour.model.dart';
import 'package:hot_tours/models/unsigned.dart';
import 'package:hot_tours/models/hotel_comment.model.dart';
import 'package:hot_tours/search_tours/models/data.model.dart';

import 'package:hot_tours/widgets/nav_bar.widget.dart';
import 'package:hot_tours/widgets/image_widget.dart';
import 'package:hot_tours/widgets/shown_stars.widget.dart';
import 'package:hot_tours/widgets/slider.widget.dart';
import 'package:hot_tours/select_tours/widgets/button.widget.dart';

import 'package:hot_tours/search_tours/routes/form.route.dart';

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

class SearchResultsRoute extends HookWidget {
  final DataModel data;
  final List<TourModel> tours;

  const SearchResultsRoute({
    Key? key,
    required this.data,
    required this.tours,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();

    final _tours = tours
        .sorted((a, b) => a.hotelName.compareTo(b.hotelName))
        .narrow((a, b) => a.hotelName == b.hotelName);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            NavBarWidget(
              hasSectionIndicator: false,
              title: 'Результаты поиска',
              hasSubtitle: false,
              backgroundColor: const Color(0xff2eaeee),
              hasBackButton: true,
              hasLoadingIndicator: false,
            ),
            Expanded(
              child: Scrollbar(
                controller: scrollController,
                child: ListView(
                  controller: scrollController,
                  children: _tours
                      .map(
                        (collection) => Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: CardWidget(
                            tours: collection,
                            onTap: () => showCardRoute(
                              context: context,
                              data: data,
                              tours: collection,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final List<TourModel> tours;
  final void Function() onTap;

  const CardWidget({
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
                                  : tours.first.hotelDesc.length > 70
                                      ? tours.first.hotelDesc
                                              .substring(0, 70)
                                              .replaceAll('\n', ' ') +
                                          '...'
                                      : tours.first.hotelDesc
                                          .replaceAll('\n', ' '),
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
                            onTap: onTap,
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

void showCardRoute({
  required BuildContext context,
  required DataModel data,
  required List<TourModel> tours,
}) =>
    showRoute<Object?>(
      context: context,
      model: null,
      builder: (_) => PageRouteBuilder(
        pageBuilder: (context, fst, snd) => CardRoute(data: data, tours: tours),
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

class CardRoute extends HookWidget {
  final DataModel data;
  final List<TourModel> tours;

  const CardRoute({
    Key? key,
    required this.data,
    required this.tours,
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
              title: 'Выберите тур',
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
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          HeaderWidget(data: data.setTour(tours.first)),
                          const SizedBox(height: 10.0),
                          SliderWidget(tour: tours.first),
                          const SizedBox(height: 15.0),
                          DescriptionWidget(data: data.setTour(tours.first)),
                          const SizedBox(height: 15.0),
                          DescriptionButtonsWidget(
                              data: data.setTour(tours.first)),
                          const SizedBox(height: 20.0),
                          Container(
                            color: const Color(0xffeba627),
                            height: 36.0,
                            child: const Center(
                              child: Text(
                                'Туры в этот отель',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 20.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          ToursListWidget(data: data, tours: tours),
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

class HeaderWidget extends StatelessWidget {
  final DataModel data;

  const HeaderWidget({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(
          top: 12.0,
          left: 14.0,
          right: 35.0,
          bottom: 8.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      data.tour!.hotelName.capitalized,
                      maxLines: 2,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.normal,
                        fontSize: 16.0,
                        color: Color(0xff4d4948),
                      ),
                    ),
                    const SizedBox(width: 6.0),
                    Container(
                      width: 36.0,
                      height: 18.0,
                      decoration: BoxDecoration(
                        color: fade(data.tour!.hotelRating),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 1.5),
                          child: Text(
                            '${data.tour!.hotelRating}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.normal,
                              fontSize: 13.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6.0),
                Text(
                  data.tour!.targetCityName,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.normal,
                    fontSize: 12.0,
                    color: Color(0xff7d7d7d),
                  ),
                ),
              ],
            ),
            ShownStarsWidget(data: data.tour!.hotelStar),
          ],
        ),
      );
}

class DescriptionWidget extends StatelessWidget {
  final DataModel data;

  const DescriptionWidget({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        width: double.infinity,
        child: Text(
          data.tour!.hotelDesc.trim().isNotEmpty
              ? data.tour!.hotelDesc.trim()
              : 'Описание отеля временно отсутствует.',
          textAlign: TextAlign.start,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.normal,
            fontSize: 12.0,
            color: Color(0xff4d4948),
          ),
        ),
      );
}

class DescriptionButtonsWidget extends StatelessWidget {
  final DataModel data;

  const DescriptionButtonsWidget({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Spacer(),
          DescriptionButtonWidget(
            text: 'Больше',
            onTap: () => launch(data.tour!.hotelDescUrl),
          ),
          const Spacer(),
          DescriptionButtonWidget(
            text: 'Отзывы',
            onTap: () => showHotelCommentsRoute(context: context, data: data),
          ),
          const Spacer(),
        ],
      );
}

class DescriptionButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const DescriptionButtonWidget({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 80.0,
          height: 28.0,
          decoration: BoxDecoration(
            color: const Color(0xfff5f5f5),
            border: Border.all(
              color: const Color(0xffc1c1c1),
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.normal,
                fontSize: 14.0,
              ),
            ),
          ),
        ),
      );
}

class ToursListWidget extends StatelessWidget {
  final DataModel data;
  final List<TourModel> tours;

  const ToursListWidget({
    Key? key,
    required this.data,
    required this.tours,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: tours.length,
        itemBuilder: (_, index) => Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 20.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                () {
                      final date = Date.parseDate(tours[index].dateIn);
                      final day = U(date.day);
                      final month = U(date.month);
                      final nights = tours[index].nightsCount;
                      return '$day ${declineWord(Date.monthToString(month.value), day)}, $nights ${declineWord('ночь', nights)}';
                    }() +
                    '\n' +
                    () {
                      final adults = tours[index].adultsCount;
                      final children = tours[index].childrenCount;
                      if (children.eq(0)) {
                        return '$adults ${declineWord('взрослый', adults)}';
                      }
                      return '$adults ${declineWord('взрослый', adults)}, $children ${declineWord('ребёнок', children)}';
                    }() +
                    '\n' +
                    (tours[index].roomTypeDesc.length > 25
                        ? tours[index]
                                .roomTypeDesc
                                .capitalized
                                .substring(0, 25) +
                            '...'
                        : tours[index].roomTypeDesc.capitalized) +
                    '\n' +
                    '${tours[index].mealTypeDesc.capitalized} (${tours[index].mealType.capitalized})',
                textAlign: TextAlign.start,
                style: const TextStyle(fontSize: 12.0),
              ),
              ButtonWidget(
                isFlexible: true,
                text:
                    '${thousands(tours[index].cost)} ${tours[index].costCurrency.toUpperCase() == 'RUB' ? 'р.' : tours[index].costCurrency}',
                isActive: true,
                onTap: () => showInformationRoute(
                  context: context,
                  data: data.setTour(tours[index]),
                ),
              ),
            ],
          ),
        ),
        separatorBuilder: (_, __) => const Divider(),
      );
}

void showHotelCommentsRoute({
  required BuildContext context,
  required DataModel data,
}) =>
    showRoute<DataModel>(
      context: context,
      model: data,
      builder: (currentData) => PageRouteBuilder(
        pageBuilder: (context, fst, snd) =>
            HotelCommentsRoute(data: currentData!),
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

class HotelCommentsRoute extends HookWidget {
  final DataModel data;

  const HotelCommentsRoute({
    Key? key,
    required this.data,
  }) : super(key: key);

  void Function(T) setState<T>(ValueNotifier<T> state) =>
      (T value) => state.value = value;

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();

    final isLoading = useState(true);

    final hotelComments = useState(<HotelCommentModel>[]);

    useEffect(() {
      Api.getHotelComments(hotelId: data.tour!.hotelId).then((value) {
        setState(hotelComments)(value);
        setState(isLoading)(false);
      });
    }, []);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            NavBarWidget(
              hasSectionIndicator: false,
              title: 'Отзывы об отеле',
              hasSubtitle: false,
              backgroundColor: const Color(0xff2eaeee),
              hasBackButton: true,
              hasLoadingIndicator: true,
              isLoading: isLoading.value,
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
                          const Divider(),
                          if (hotelComments.value.isEmpty && !isLoading.value)
                            const Text(
                              'К сожалению по данному отелю пока нет отзывов.',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.normal,
                                fontSize: 12.0,
                              ),
                            )
                          else
                            AnimatedOpacity(
                              duration: const Duration(milliseconds: 350),
                              opacity: isLoading.value ? 0.0 : 1.0,
                              child: ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: hotelComments.value.length,
                                itemBuilder: (_, index) => HotelCommentWidget(
                                  model: hotelComments.value[index],
                                ),
                                separatorBuilder: (_, __) => const Divider(),
                              ),
                            ),
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

class ParametersWidget extends StatelessWidget {
  final DataModel data;

  const ParametersWidget({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '${data.tour!.departCityName} → ${data.tour!.targetCountryName}',
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.normal,
                fontSize: 15.0,
                color: Color(0xff2eaeee),
              ),
            ),
            const SizedBox(height: 12.0),
            Text(
              () {
                final date = Date.parseDate(data.tour!.dateIn);
                final day = U(date.day);
                final month = U(date.month);
                final nights = data.tour!.nightsCount;
                return 'Вылет $day ${declineWord(Date.monthToString(month.value), day)}, $nights ${declineWord('ночь', nights)}';
              }(),
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.normal,
                fontSize: 12.0,
                color: Color(0xff4d4948),
              ),
            ),
            const SizedBox(height: 6.0),
            Text(
              () {
                final adults = data.tour!.adultsCount;
                final children = data.tour!.childrenCount;
                if (children.eq(0)) {
                  return '$adults ${declineWord('взрослый', adults)}';
                }
                return '$adults ${declineWord('взрослый', adults)}, $children ${declineWord('ребёнок', children)}';
              }(),
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.normal,
                fontSize: 12.0,
                color: Color(0xff4d4948),
              ),
            ),
            const SizedBox(height: 6.0),
            Text(
              '${data.tour!.roomTypeDesc.capitalized} (${data.tour!.roomType.capitalized})',
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.normal,
                fontSize: 12.0,
                color: Color(0xff4d4948),
              ),
            ),
            const SizedBox(height: 6.0),
            Text(
              '${data.tour!.mealTypeDesc.capitalized} (${data.tour!.mealType.capitalized})',
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.normal,
                fontSize: 12.0,
                color: Color(0xff4d4948),
              ),
            ),
            const SizedBox(height: 12.0),
            const Text(
              'В стоимость входит: авиаперелёт, проживание в отеле,\nмедицинская страховка, трансфер.',
              maxLines: 2,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                fontSize: 11.0,
                color: Color(0xff7d7d7d),
              ),
            ),
          ],
        ),
      );
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
