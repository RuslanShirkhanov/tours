import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:hot_tours/api.dart';

import 'package:hot_tours/hot_tours/models/data.model.dart';
import 'package:hot_tours/models/hotel_comment.model.dart';

import 'package:hot_tours/utils/show_route.dart';

import 'package:hot_tours/widgets/nav_bar.widget.dart';

import 'package:hot_tours/hot_tours/routes/card.route.dart';

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
              backgroundColor: const Color(0xffdc2323),
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
