import 'package:flutter/material.dart';

import 'package:hot_tours/utils/date.dart';
import 'package:hot_tours/utils/map_to_list.dart';
import 'package:hot_tours/utils/pair.dart';
import 'package:hot_tours/utils/show_route.dart';

import 'package:hot_tours/models/unsigned.dart';
import 'package:hot_tours/select_tours/models/data.model.dart';

import 'package:hot_tours/widgets/nav_bar.widget.dart';
import 'package:hot_tours/widgets/list_button.widget.dart';
import 'package:hot_tours/widgets/footer.widget.dart';

import 'package:hot_tours/select_tours/routes/select_how_long.route.dart';
import 'package:hot_tours/search_tours/routes/select_tour_dates.route.dart';

void showSelectWhenRoute({
  required BuildContext context,
  required DataModel data,
}) =>
    showRoute<DataModel>(
      context: context,
      model: data,
      builder: (currentData) => PageRouteBuilder(
        pageBuilder: (context, fst, snd) => SelectWhenRoute(
          data: currentData!,
          onContinue: (newData) => showSelectHowLongRoute(
            context: context,
            data: newData,
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

class SelectWhenRoute extends StatefulWidget {
  final DataModel data;
  final void Function(DataModel) onContinue;

  const SelectWhenRoute({
    Key? key,
    required this.data,
    required this.onContinue,
  }) : super(key: key);

  @override
  State<SelectWhenRoute> createState() => _SelectWhenRouteState();
}

class _SelectWhenRouteState extends State<SelectWhenRoute> {
  static const _items = [
    'Чем быстрее, тем лучше',
    'Ближайшие 2 недели',
    'Ближайший месяц',
  ];

  late final DateTime currentDate;
  late Pair<DateTime?, DateTime?> range;
  late final List<int> selectedItems;

  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();

    currentDate = DateTime.now();
    range = const Pair(null, null);
    selectedItems = [];

    scrollController = ScrollController();
  }

  @override
  void dispose() {
    scrollController.dispose();

    super.dispose();
  }

  void onSelectItem(int index) {
    setState(() {
      if (selectedItems.contains(index)) {
        selectedItems.removeWhere((i) => i == index);
      } else {
        selectedItems.add(index);
      }
    });
  }

  bool isItemAvailable(int index) => range.fst == null && range.snd == null;
  bool isItemSelected(int index) => selectedItems.contains(index);

  bool get okIsActive => true;
  void onOk() {
    if (selectedItems.isEmpty) {
      if (range.fst == null && range.snd == null) {
        widget.onContinue(widget.data);
      } else {
        widget.onContinue(
          widget.data.setRange(
            Pair(range.fst!, range.snd!),
          ),
        );
      }
    } else {
      widget.onContinue(
        widget.data.setWhen(
          selectedItems.map(_items.elementAt).toList(),
        ),
      );
    }
  }

  bool get cancelIsActive => true;
  void onCancel() => Navigator.of(context).pop();

  bool get resetIsActive =>
      selectedItems.isNotEmpty || (range.fst != null && range.snd != null);
  void onReset() {
    setState(() {
      range = const Pair(null, null);
      selectedItems.clear();
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: NavBarWidget(
                  sectionsCount: const U(6),
                  sectionIndex: widget.data.sectionIndex,
                  hasSectionIndicator: true,
                  title: 'Подбор тура',
                  hasSubtitle: false,
                  backgroundColor: const Color(0xff2eaeee),
                  hasBackButton: true,
                  hasLoadingIndicator: true,
                ),
              ),
              Align(
                child: Padding(
                  padding: const EdgeInsets.only(top: 55.0, bottom: 70.0),
                  child: Scrollbar(
                    controller: scrollController,
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      children: <Widget>[
                        const Text(
                          'Когда хотите полететь?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 18.0,
                            color: Color(0xff4d4948),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        const Text(
                          'можно выбрать несколько вариантов\nили пропустить',
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0,
                            color: Color(0xff7d7d7d),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        ..._items.mapToList(
                          (element, index) => Padding(
                            padding: EdgeInsets.only(
                              top: index == 0 ? 0.0 : 20.0,
                              left: 50.0,
                              right: 50.0,
                            ),
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 350),
                              opacity: isItemAvailable(index) ||
                                      isItemSelected(index)
                                  ? 1.0
                                  : 0.5,
                              child: ListButtonWidget(
                                hasCheckbox: true,
                                checkboxStatus: isItemSelected(index),
                                text: element,
                                onTap: isItemAvailable(index) ||
                                        isItemSelected(index)
                                    ? () => onSelectItem(index)
                                    : () {},
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30.0),
                        const Text(
                          'или выберите даты вылета',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0,
                            color: Color(0xff7d7d7d),
                          ),
                        ),
                        const SizedBox(height: 30.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50.0),
                          child: ListButtonWidget(
                            isActive: selectedItems.isEmpty,
                            text: () {
                              final dates = range.days;
                              if (dates.isEmpty) {
                                return 'Даты вылета';
                              }
                              return range.pretty;
                            }(),
                            onTap: () => showRoute<Object?>(
                              context: context,
                              model: null,
                              builder: (_) => PageRouteBuilder(
                                pageBuilder: (context, fst, snd) =>
                                    SelectWhenDialogRoute(
                                  currentDate: currentDate,
                                  range: range,
                                  onContinue: (value) =>
                                      setState(() => range = value),
                                ),
                                transitionsBuilder: (context, fst, snd, child) {
                                  const begin = Offset(1.0, 0.0);
                                  const end = Offset.zero;
                                  const curve = Curves.ease;

                                  final tween = Tween(begin: begin, end: end)
                                      .chain(CurveTween(curve: curve));

                                  return SlideTransition(
                                    position: fst.drive(tween),
                                    child: child,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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

class SelectWhenDialogRoute extends StatefulWidget {
  final DateTime currentDate;
  final Pair<DateTime?, DateTime?> range;
  final void Function(Pair<DateTime?, DateTime?>) onContinue;

  const SelectWhenDialogRoute({
    Key? key,
    required this.currentDate,
    required this.range,
    required this.onContinue,
  }) : super(key: key);

  @override
  State<SelectWhenDialogRoute> createState() => _SelectWhenDialogRouteState();
}

class _SelectWhenDialogRouteState extends State<SelectWhenDialogRoute> {
  late Pair<DateTime?, DateTime?> range;

  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();

    range = widget.range;

    scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();

    scrollController.dispose();
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

  bool isAvailable(DateTime value) => value.compareTo(widget.currentDate) >= 0;
  bool isSelected(DateTime value) => range.contains(value);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 70.0),
                  child: Scrollbar(
                    controller: scrollController,
                    child: DateTableListWidget(
                      currentDate: widget.currentDate,
                      isAvailable: isAvailable,
                      isSelected: isSelected,
                      onSelect: onSelect,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: FooterWidget(
                  ok: FooterButtonModel(
                    kind: FooterButtonKind.ok,
                    isActive: range.fst != null && range.snd != null,
                    onTap: () {
                      widget.onContinue(range);
                      Navigator.pop(context);
                    },
                  ),
                  cancel: FooterButtonModel(
                    kind: FooterButtonKind.cancel,
                    isActive: true,
                    onTap: () => Navigator.pop(context),
                  ),
                  reset: FooterButtonModel(
                    kind: FooterButtonKind.reset,
                    isActive: range.fst != null && range.snd != null,
                    onTap: () => setState(() => range = const Pair(null, null)),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
