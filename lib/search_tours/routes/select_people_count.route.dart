import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:hot_tours/utils/map_to_list.dart';
import 'package:hot_tours/utils/pair.dart';
import 'package:hot_tours/utils/show_route.dart';

import 'package:hot_tours/models/unsigned.dart';
import 'package:hot_tours/search_tours/models/data.model.dart';

import 'package:hot_tours/widgets/nav_bar.widget.dart';
import 'package:hot_tours/widgets/list_button.widget.dart';
import 'package:hot_tours/widgets/footer.widget.dart';

void showSelectPeopleCountRoute({
  required BuildContext context,
  required DataModel data,
  required void Function(DataModel) onContinue,
}) =>
    showRoute<DataModel>(
      context: context,
      model: data,
      builder: (currentData) => PageRouteBuilder(
        pageBuilder: (context, fst, snd) => SelectPeopleCount(
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

class SelectPeopleCount extends HookWidget {
  final DataModel data;
  final void Function(DataModel) onContinue;

  const SelectPeopleCount({
    Key? key,
    required this.data,
    required this.onContinue,
  }) : super(key: key);

  Widget _buildAdultsSelector({
    required int value,
    required bool isDecrementActive,
    required VoidCallback decrement,
    required bool isIncrementActive,
    required VoidCallback increment,
  }) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60.0),
        child: Container(
          height: 45.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                onTap: isDecrementActive ? decrement : () {},
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 350),
                  opacity: isDecrementActive ? 1.0 : 0.5,
                  child: Container(
                    width: 45.0,
                    height: 45.0,
                    decoration: BoxDecoration(
                      color: const Color(0xff2eaeee),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.remove,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                '$value ' + (value <= 1 || value >= 5 ? 'человек' : 'человека'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.normal,
                  fontSize: 22.0,
                  color: Color(0xff4d4948),
                ),
              ),
              GestureDetector(
                onTap: isIncrementActive ? increment : () {},
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 350),
                  opacity: isIncrementActive ? 1.0 : 0.5,
                  child: Container(
                    width: 45.0,
                    height: 45.0,
                    decoration: BoxDecoration(
                      color: const Color(0xff2eaeee),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildChildSelector({
    required int index,
    required int value,
    required void Function(int) remove,
  }) =>
      Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 60.0,
        ),
        child: Container(
          height: 45.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                onTap: () => remove(index),
                child: Container(
                  width: 45.0,
                  height: 45.0,
                  decoration: BoxDecoration(
                    color: const Color(0xff2eaeee),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.remove,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Text(
                '$value ' +
                    (value >= 5 ? 'лет' : 'год') +
                    (value > 1 && value < 5 ? 'а' : ''),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.normal,
                  fontSize: 22.0,
                  color: Color(0xff4d4948),
                ),
              ),
              Opacity(
                opacity: 0,
                child: Container(
                  width: 45.0,
                  height: 45.0,
                  decoration: BoxDecoration(
                    color: const Color(0xff2eaeee),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.remove,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildButton({
    required int value,
    required bool isActive,
    required void Function(int) onTap,
  }) =>
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: isActive ? () => onTap(value) : () {},
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 350),
            opacity: isActive ? 1.0 : 0.5,
            child: Container(
              width: 85.0,
              height: 45.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    offset: const Offset(1.0, 1.0),
                    blurRadius: 10.0,
                    color: Colors.black.withAlpha(25),
                  ),
                ],
              ),
              child: Text(
                '$value ' +
                    (value >= 5 ? 'лет' : 'год') +
                    (value > 1 && value < 5 ? 'а' : ''),
                textAlign: TextAlign.center,
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
      );

  Widget _buildAddChildDialog({
    required BuildContext context,
    required bool isSelectable,
    required void Function(int) append,
  }) {
    void onTap(int value) {
      append(value);
      Navigator.of(context).pop();
    }

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 320.0,
            height: 320.0,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) => index + 1)
                          .map((day) => _buildButton(
                                value: day,
                                onTap: onTap,
                                isActive: isSelectable,
                              ))
                          .toList(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) => index + 3 + 1)
                          .map((day) => _buildButton(
                                value: day,
                                onTap: onTap,
                                isActive: isSelectable,
                              ))
                          .toList(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) => index + 6 + 1)
                          .map((day) => _buildButton(
                                value: day,
                                onTap: onTap,
                                isActive: isSelectable,
                              ))
                          .toList(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) => index + 9 + 1)
                          .map((day) => _buildButton(
                                value: day,
                                onTap: onTap,
                                isActive: isSelectable,
                              ))
                          .toList(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) => index + 12 + 1)
                          .map((day) => _buildButton(
                                value: day,
                                onTap: onTap,
                                isActive: isSelectable,
                              ))
                          .toList(),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scrollController0 = useScrollController();
    final scrollController1 = useScrollController();

    final adultsCount = useState(1);
    final childrenAges = useState(<int>[]);

    const adultsMinCount = 1;
    const adultsMaxCount = 4;

    const childrenMaxCount = 3;

    void decrement() => adultsCount.value -= 1;

    void increment() => adultsCount.value += 1;

    void remove(int index) {
      childrenAges.value.removeAt(index);
      childrenAges.value = [...childrenAges.value];
    }

    void append(int value) {
      childrenAges.value.add(value);
      childrenAges.value = [...childrenAges.value];
    }

    return Scaffold(
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
                subtitle: 'Выберите количество туристов',
                hasBackButton: true,
                hasLoadingIndicator: false,
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 78.0, bottom: 70.0),
                child: Scrollbar(
                  controller: scrollController0,
                  child: ListView(
                    controller: scrollController0,
                    children: <Widget>[
                      const SizedBox(height: 80.0),
                      const Text(
                        'Взрослые',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.normal,
                          fontSize: 18.0,
                          color: Color(0xff7d7d7d),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      _buildAdultsSelector(
                        value: adultsCount.value,
                        isDecrementActive: adultsCount.value > adultsMinCount,
                        decrement: decrement,
                        isIncrementActive: adultsCount.value < adultsMaxCount,
                        increment: increment,
                      ),
                      const SizedBox(height: 20.0),
                      const Text(
                        'Дети',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.normal,
                          fontSize: 18.0,
                          color: Color(0xff7d7d7d),
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Scrollbar(
                        controller: scrollController1,
                        child: SingleChildScrollView(
                          controller: scrollController1,
                          child: Column(
                            children: childrenAges.value.mapToList(
                              (age, index) => _buildChildSelector(
                                index: index,
                                value: age,
                                remove: remove,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 55.0),
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 350),
                          opacity: childrenAges.value.length == childrenMaxCount
                              ? 0.5
                              : 1.0,
                          child: ListButtonWidget(
                            text: 'Добавить ребёнка',
                            onTap: childrenAges.value.length == childrenMaxCount
                                ? () {}
                                : () => showGeneralDialog(
                                      context: context,
                                      transitionDuration:
                                          const Duration(milliseconds: 350),
                                      pageBuilder: (context, a, b) =>
                                          _buildAddChildDialog(
                                        context: context,
                                        append: append,
                                        isSelectable:
                                            childrenAges.value.length <
                                                childrenMaxCount,
                                      ),
                                    ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
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
                  isActive: true,
                  onTap: () => onContinue(
                    data
                        .setPeopleCount(
                          Pair(
                            U(adultsCount.value),
                            U(childrenAges.value.length),
                          ),
                        )
                        .setChildrenAges(
                          childrenAges.value.map((age) => U(age)).toList(),
                        ),
                  ),
                ),
                cancel: FooterButtonModel(
                  kind: FooterButtonKind.cancel,
                  isActive: true,
                  onTap: () => Navigator.of(context).pop(),
                ),
                reset: FooterButtonModel(
                  kind: FooterButtonKind.reset,
                  isActive: adultsCount.value > adultsMinCount ||
                      childrenAges.value.isNotEmpty,
                  onTap: () {
                    adultsCount.value = adultsMinCount;
                    childrenAges.value = [];
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
