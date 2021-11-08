import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:hot_tours/api.dart';

import 'package:hot_tours/utils/date.dart';
import 'package:hot_tours/utils/pair.dart';
import 'package:hot_tours/utils/string.dart';
import 'package:hot_tours/utils/show_route.dart';
import 'package:hot_tours/utils/map_to_list.dart';

import 'package:hot_tours/search_tours/models/data.model.dart';

import 'package:hot_tours/widgets/nav_bar.widget.dart';
import 'package:hot_tours/widgets/footer.widget.dart';

void showSelectDatesRoute({
  required BuildContext context,
  required DataModel data,
  required void Function(DataModel) onContinue,
}) =>
    showRoute<DataModel>(
      context: context,
      model: data,
      builder: (currentData) => PageRouteBuilder(
        pageBuilder: (context, fst, snd) => SelectDatesRoute(
          data: currentData!,
          onContinue: (newData) {
            Navigator.of(context).pop();
            onContinue(newData);
          },
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

class SelectDatesRoute extends StatefulWidget {
  final DataModel data;
  final void Function(DataModel) onContinue;

  const SelectDatesRoute({
    Key? key,
    required this.data,
    required this.onContinue,
  }) : super(key: key);

  @override
  _SelectDatesRouteState createState() => _SelectDatesRouteState();
}

class _SelectDatesRouteState extends State<SelectDatesRoute> {
  late bool isLoading;

  late final DateTime currentDate;

  late List<DateTime> availableDates;
  late Pair<DateTime?, DateTime?> range;

  @override
  void initState() {
    super.initState();

    isLoading = true;

    currentDate = DateTime.now();
    availableDates = [];
    range = const Pair(null, null);

    Api.getTourDates(
      departCityId: widget.data.departCity!.id,
      countryId: widget.data.targetCountry!.id,
    ).then((value) {
      setState(() {
        availableDates = value;
        isLoading = false;
      });
    });
  }

  void showSelectedSnackBar(BuildContext context) =>
      WidgetsBinding.instance!.scheduleFrameCallback(
        (_) => Future.delayed(
          const Duration(milliseconds: 175),
          () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration: Duration(milliseconds: 450),
              behavior: SnackBarBehavior.floating,
              content: SizedBox(
                child: Text('Диапазон выбран'),
              ),
            ),
          ),
        ),
      );

  void onSelect(DateTime value) {
    setState(() {
      if (range.fst == null && range.snd == null) {
        range = Pair(value, value);
        return;
      }

      if (range.fst != null && range.snd != null && range.fst == range.snd) {
        if (value.compareTo(range.fst!) >= 0) {
          range = Pair(range.fst, value);
        } else {
          range = Pair(value, range.fst);
        }
        showSelectedSnackBar(context);
      }
    });
  }

  bool isAvailable(DateTime value) => availableDates
      .where((x) =>
          x.year == value.year && x.month == value.month && x.day == value.day)
      .isNotEmpty;

  bool isSelected(DateTime value) => range.contains(value);

  bool get okIsActive => range.fst != null && range.snd != null;
  void onOk() =>
      widget.onContinue(widget.data.setTourDates(range.days.toList()));

  bool get cancelIsActive => true;
  void onCancel() => Navigator.of(context).pop();

  bool get resetIsActive => range.fst != null || range.snd != null;
  void onReset() => setState(() => range = const Pair(null, null));

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: NavBarWidget(
                  backgroundColor: const Color(0xff2Eaeee),
                  hasSectionIndicator: false,
                  title: 'Поиск туров',
                  hasSubtitle: true,
                  subtitle: 'Выберите даты вылета',
                  hasBackButton: true,
                  isLoading: isLoading,
                  hasLoadingIndicator: true,
                ),
              ),
              Align(
                child: Padding(
                  padding: const EdgeInsets.only(top: 78.0, bottom: 70.0),
                  child: DateTableListWidget(
                    currentDate: currentDate,
                    isAvailable: isAvailable,
                    isSelected: isSelected,
                    onSelect: onSelect,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: FooterWidget(
                  ok: FooterButtonModel(
                    kind: FooterButtonKind.ok,
                    isActive: okIsActive,
                    onTap: onOk,
                  ),
                  cancel: FooterButtonModel(
                    kind: FooterButtonKind.cancel,
                    isActive: cancelIsActive,
                    onTap: onCancel,
                  ),
                  reset: FooterButtonModel(
                    kind: FooterButtonKind.reset,
                    isActive: resetIsActive,
                    onTap: onReset,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

enum Status { past, selected, available, unavailable }

extension on Status {
  Color get backgroundColor {
    switch (this) {
      case Status.past:
        return Colors.white.withAlpha(0);
      case Status.selected:
        return const Color(0xff93d0f4);
      case Status.available:
        return Colors.white.withAlpha(0);
      case Status.unavailable:
        return Colors.white.withAlpha(0);
    }
  }

  Color get textColor {
    switch (this) {
      case Status.past:
        return const Color(0xffd6d6d6);
      case Status.selected:
        return const Color(0xff4d4948);
      case Status.available:
        return const Color(0xff4d4948);
      case Status.unavailable:
        return const Color(0xffd6d6d6);
    }
  }
}

class DateTableListWidget extends HookWidget {
  final DateTime currentDate;
  final bool Function(DateTime) isAvailable;
  final bool Function(DateTime) isSelected;
  final void Function(DateTime) onSelect;

  const DateTableListWidget({
    Key? key,
    required this.currentDate,
    required this.isAvailable,
    required this.isSelected,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();

    return Scrollbar(
      controller: scrollController,
      child: ListView.separated(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        itemCount: 12,
        itemBuilder: (context, index) => DateTableWidget(
          currentDate: currentDate,
          isAvailable: isAvailable,
          isSelected: isSelected,
          onSelect: onSelect,
          date: currentDate.nextMonths[index],
        ),
        separatorBuilder: (context, index) => const Padding(
          padding: EdgeInsets.only(top: 15.0, bottom: 10.0),
          child: Divider(
            thickness: 3.0,
            color: Color(0xffe5e5e5),
          ),
        ),
      ),
    );
  }
}

class DateTableWidget extends StatefulWidget {
  final DateTime currentDate;
  final DateTime date;
  final bool Function(DateTime) isAvailable;
  final bool Function(DateTime) isSelected;
  final void Function(DateTime) onSelect;

  const DateTableWidget({
    Key? key,
    required this.currentDate,
    required this.date,
    required this.isAvailable,
    required this.isSelected,
    required this.onSelect,
  }) : super(key: key);

  @override
  _DateTableWidgetState createState() => _DateTableWidgetState();
}

class _DateTableWidgetState extends State<DateTableWidget> {
  late final DateTableModel model;

  @override
  void initState() {
    super.initState();
    model = DateTableModel(widget.date);
  }

  bool isPast(DateTime value) => value.day < model.date.day;

  bool isSelected(DateTime value) => widget.isSelected(value);

  bool isAvailable(DateTime value) => widget.isAvailable(value);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(
          left: 30.0,
          right: 30.0,
        ),
        child: Column(
          children: <Widget>[
            Text(
              '${Date.monthToString(model.date.month).capitalized} ${model.date.year}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                fontSize: 16.0,
                color: Color(0xffa0a0a0),
              ),
            ),
            const SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: model.weekdays.mapToList(
                (weekday, _) => Container(
                  width: 40.0,
                  height: 25.0,
                  alignment: Alignment.center,
                  child: Text(
                    Date.weekdayToString(weekday).toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 18.0,
                      color: Color(0xff4d4948),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: model.weekdays.mapToList(
                (weekday, _) => Column(
                  children: model.value[weekday]!.mapToList(
                    (date, index) {
                      final isNull = date == null;
                      final status = isNull
                          ? Status.past
                          : isPast(date!)
                              ? Status.past
                              : isSelected(date)
                                  ? Status.selected
                                  : isAvailable(date)
                                      ? Status.available
                                      : Status.unavailable;
                      final isToday = isNull ||
                          (date!.month == widget.currentDate.month) &&
                              (date.day == widget.currentDate.day);

                      return Container(
                        padding: EdgeInsets.only(top: index == 0 ? 0.0 : 8.0),
                        child: GestureDetector(
                          onTap:
                              [Status.past, Status.unavailable].contains(status)
                                  ? () {}
                                  : () => widget.onSelect(date!),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 350),
                            width: 40.0,
                            height: 25.0,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: status.backgroundColor,
                            ),
                            child: Text(
                              isNull ? '' : date!.day.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 18.0,
                                color: isToday
                                    ? const Color(0xff0093dd)
                                    : status.textColor,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}

class DateTableModel {
  final DateTime date;

  const DateTableModel(this.date);

  List<int> get days => List.generate(date.daysCount, (x) => x + 1);

  List<int> get weekdays => List.generate(7, (x) => x + 1);

  Map<int, List<DateTime?>> get value {
    final result =
        weekdays.asMap().map((key, value) => MapEntry(value, <DateTime?>[]));

    var weekdayCounter = date.weekday;

    weekdayCounter = Date.decWeekday(weekdayCounter);

    final daysBefore = days.where((x) => x < date.day).toList();

    for (final day in daysBefore.reversed) {
      for (final weekday in weekdays) {
        if (weekdayCounter == weekday) {
          result[weekday]!.add(DateTime(date.year, date.month, day));
        }
      }
      weekdayCounter = Date.decWeekday(weekdayCounter);
    }

    weekdayCounter = date.weekday;

    final daysAfter = days.where((x) => x >= date.day).toList();

    for (final day in daysAfter) {
      for (final weekday in weekdays) {
        if (weekdayCounter == weekday) {
          result[weekday]!.add(DateTime(date.year, date.month, day));
        }
      }
      weekdayCounter = Date.incWeekday(weekdayCounter);
    }

    for (final key in result.keys) {
      result[key]!.sort();
    }

    final firstKey = result.keys.firstWhere(
        (key) => result[key]!.map((date) => date?.day).toList().contains(1));

    final lastKey = result.keys.firstWhere((key) => result[key]!
        .map((date) => date?.day)
        .toList()
        .contains(date.daysCount));

    for (final key in result.keys) {
      if (key < firstKey) {
        result[key] = [null, ...result[key]!];
      }
      if (key > lastKey) {
        result[key] = [...result[key]!, null];
      }
    }

    return result;
  }
}
