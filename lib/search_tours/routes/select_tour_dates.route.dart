import 'package:flutter/material.dart';

import 'package:hot_tours/api.dart';

import 'package:hot_tours/utils/pair.dart';
import 'package:hot_tours/utils/string.dart';
import 'package:hot_tours/utils/show_route.dart';
import 'package:hot_tours/utils/map_to_list.dart';

import 'package:hot_tours/search_tours/models/data.model.dart';

import 'package:hot_tours/widgets/header.widget.dart';
import 'package:hot_tours/widgets/footer.widget.dart';

void showSelectTourDatesRoute({
  required BuildContext context,
  required DataModel data,
  required void Function(DataModel) onContinue,
}) =>
    showRoute<DataModel>(
      context: context,
      model: data,
      builder: (currentData) => PageRouteBuilder(
        pageBuilder: (context, fst, snd) => SelectTourDatesRoute(
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

class SelectTourDatesRoute extends StatefulWidget {
  final DataModel data;
  final void Function(DataModel) onContinue;

  const SelectTourDatesRoute({
    Key? key,
    required this.data,
    required this.onContinue,
  }) : super(key: key);

  @override
  _SelectTourDatesRouteState createState() => _SelectTourDatesRouteState();
}

class _SelectTourDatesRouteState extends State<SelectTourDatesRoute> {
  late bool isLoading;

  late final DateTime currentDate;

  late List<DateTime> availableDates;
  late List<DateTime> selectedDates;

  @override
  void initState() {
    super.initState();

    isLoading = true;

    currentDate = DateTime.now();
    availableDates = [];
    selectedDates = [];

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

  void onSelect(DateTime value) {
    setState(() {
      if (!selectedDates.contains(value))
        selectedDates = [...selectedDates, value];
      else
        selectedDates = selectedDates.where((date) => date != value).toList();
    });
  }

  bool isSelected(DateTime value) {
    return selectedDates
        .where((date) =>
            date.year == value.year &&
            date.month == value.month &&
            date.day == value.day)
        .isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: HeaderWidget(
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
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 78.0, bottom: 70.0),
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  itemCount: Utils.lastMonths(currentDate).length,
                  itemBuilder: (context, index) => TableWidget(
                    availableDates: availableDates,
                    isSelected: isSelected,
                    onSelect: onSelect,
                    date: Utils.lastMonths(currentDate)[index],
                  ),
                  separatorBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
                    child: Divider(
                      thickness: 3.0,
                      color: const Color(0xffe5e5e5),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: FooterWidget(
                ok: FooterButtonModel(
                  kind: FooterButtonKind.ok,
                  isActive: selectedDates.isNotEmpty,
                  onTap: () => widget
                      .onContinue(widget.data.setTourDates(selectedDates)),
                ),
                cancel: FooterButtonModel(
                  kind: FooterButtonKind.cancel,
                  isActive: true,
                  onTap: () => Navigator.of(context).pop(),
                ),
                reset: FooterButtonModel(
                  kind: FooterButtonKind.reset,
                  isActive: selectedDates.isNotEmpty,
                  onTap: () => setState(() => selectedDates = []),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum Status { past, selected, available, unavailable }

Color backgroundColor(Status status) {
  switch (status) {
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

Color textColor(Status status) {
  switch (status) {
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

Pair<Color, Color> allColors(Status status) =>
    Pair(backgroundColor(status), textColor(status));

class TableWidget extends StatefulWidget {
  final DateTime date;
  final List<DateTime> availableDates;
  final bool Function(DateTime) isSelected;
  final void Function(DateTime) onSelect;

  const TableWidget({
    Key? key,
    required this.date,
    required this.availableDates,
    required this.isSelected,
    required this.onSelect,
  }) : super(key: key);

  @override
  _TableWidgetState createState() => _TableWidgetState();
}

class _TableWidgetState extends State<TableWidget> {
  late final TableModel model;

  @override
  void initState() {
    super.initState();
    model = TableModel(widget.date);
  }

  bool isPast(DateTime value) => value.day < model.date.day;

  bool isSelected(DateTime value) => widget.isSelected(value);

  bool isAvailable(DateTime value) => widget.availableDates
      .where((x) =>
          x.year == value.year && x.month == value.month && x.day == value.day)
      .isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 30.0,
        right: 30.0,
      ),
      child: Column(
        children: <Widget>[
          Text(
            '${Utils.monthToString(model.date.month).capitalized} ${model.date.year}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              fontSize: 16.0,
              color: const Color(0xffa0a0a0),
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
                  Utils.weekdayToString(weekday).toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 18.0,
                    color: const Color(0xff4d4948),
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
                    final colors = allColors(status);

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
                          decoration: BoxDecoration(color: colors.fst),
                          child: Text(
                            isNull ? "" : date!.day.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              fontSize: 18.0,
                              color: colors.snd,
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
}

abstract class Utils {
  static int monthsCount(DateTime date) => 12 - date.month;

  static List<DateTime> lastMonths(DateTime date) => List.generate(
        12 - date.month + 1,
        (index) => DateTime(date.year, date.month + index),
      );

  static int daysCount(DateTime date) => [
        DateTime.september,
        DateTime.april,
        DateTime.june,
        DateTime.november,
      ].contains(date.month)
          ? 30
          : [
              DateTime.january,
              DateTime.march,
              DateTime.may,
              DateTime.july,
              DateTime.august,
              DateTime.october,
              DateTime.december,
            ].contains(date.month)
              ? 31
              : date.year % 4 == 0
                  ? 29
                  : 28;

  static int _decRanged(int min, int max, int value) =>
      value == min ? max : value - 1;

  static int _incRanged(int min, int max, int value) =>
      value == max ? min : value + 1;

  static int decWeekday(int value) => Utils._decRanged(1, 7, value);

  static int incWeekday(int value) => Utils._incRanged(1, 7, value);

  static String monthToString(int value) {
    assert(value >= 1 && value <= 12);
    return [
      'январь',
      'февраль',
      'март',
      'апрель',
      'май',
      'июнь',
      'июль',
      'август',
      'сентябрь',
      'октябрь',
      'ноябрь',
      'декабрь',
    ][value - 1];
  }

  static String weekdayToString(int value) {
    assert(value >= 1 && value <= 7);
    return ['пн', 'вт', 'ср', 'чт', 'пт', 'сб', 'вс'][value - 1];
  }
}

class TableModel {
  final DateTime date;

  const TableModel(this.date);

  int get daysCount => Utils.daysCount(date);

  List<int> get days => List.generate(daysCount, (x) => x + 1);

  List<int> get weekdays => List.generate(7, (x) => x + 1);

  Map<int, List<DateTime?>> get value {
    final result =
        weekdays.asMap().map((key, value) => MapEntry(value, <DateTime?>[]));

    var weekdayCounter = date.weekday;

    weekdayCounter = Utils.decWeekday(weekdayCounter);

    final daysBefore = days.where((x) => x < date.day).toList();

    for (final day in daysBefore.reversed) {
      for (final weekday in weekdays) {
        if (weekdayCounter == weekday) {
          result[weekday]!.add(DateTime(date.year, date.month, day));
        }
      }
      weekdayCounter = Utils.decWeekday(weekdayCounter);
    }

    weekdayCounter = date.weekday;

    final daysAfter = days.where((x) => x >= date.day).toList();

    for (final day in daysAfter) {
      for (final weekday in weekdays) {
        if (weekdayCounter == weekday) {
          result[weekday]!.add(DateTime(date.year, date.month, day));
        }
      }
      weekdayCounter = Utils.incWeekday(weekdayCounter);
    }

    for (final key in result.keys) {
      result[key]!.sort();
    }

    final firstKey = result.keys.firstWhere(
        (key) => result[key]!.map((date) => date?.day).toList().contains(1));

    final lastKey = result.keys.firstWhere((key) =>
        result[key]!.map((date) => date?.day).toList().contains(daysCount));

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
