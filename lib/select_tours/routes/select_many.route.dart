import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:hot_tours/utils/map_to_list.dart';

import 'package:hot_tours/models/unsigned.dart';

import 'package:hot_tours/widgets/nav_bar.widget.dart';
import 'package:hot_tours/widgets/list_button.widget.dart';
import 'package:hot_tours/widgets/footer.widget.dart';

class SelectManyRoute extends HookWidget {
  final bool isRequired;

  final U<int> sectionIndex;
  final bool isLoading;

  final String primaryText;
  final List<String> primaryData;
  final bool isPrimarySingle;

  final String secondaryText;
  final List<String> secondaryData;
  final bool isSecondarySingle;

  final bool hasAlternative;
  final Widget? alternative;
  final bool Function()? alternativeIsSelected;

  final void Function(List<String>) onContinue;

  const SelectManyRoute({
    Key? key,
    this.isRequired = true,
    required this.sectionIndex,
    this.isLoading = false,
    required this.primaryText,
    required this.primaryData,
    required this.isPrimarySingle,
    this.secondaryText = '',
    required this.secondaryData,
    required this.isSecondarySingle,
    required this.hasAlternative,
    this.alternative,
    this.alternativeIsSelected,
    required this.onContinue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();

    final selectedPrimary = useState(<int>[]);
    final selectedSecondary = useState(<int>[]);

    final canSelectPrimary = useMemoized(
      () => isPrimarySingle
          ? selectedPrimary.value.isEmpty && selectedSecondary.value.isEmpty
          : selectedSecondary.value.isEmpty,
      [selectedPrimary.value, selectedSecondary.value],
    );
    final canSelectSecondary = useMemoized(
      () => isSecondarySingle
          ? selectedSecondary.value.isEmpty && selectedPrimary.value.isEmpty
          : selectedPrimary.value.isEmpty,
      [selectedSecondary.value, selectedPrimary.value],
    );

    void onSelectPrimary(int index) {
      if (selectedPrimary.value.contains(index)) {
        selectedPrimary.value =
            selectedPrimary.value.where((i) => i != index).toList();
      } else {
        selectedPrimary.value = [index, ...selectedPrimary.value];
      }
    }

    void onSelectSecondary(int index) {
      if (selectedSecondary.value.contains(index)) {
        selectedSecondary.value =
            selectedSecondary.value.where((i) => i != index).toList();
      } else {
        selectedSecondary.value = [index, ...selectedSecondary.value];
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: NavBarWidget(
                sectionsCount: const U(6),
                sectionIndex: sectionIndex,
                hasSectionIndicator: true,
                title: '???????????? ????????',
                hasSubtitle: false,
                backgroundColor: const Color(0xff2eaeee),
                hasBackButton: true,
                isLoading: isLoading,
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
                      Text(
                        primaryText,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 18.0,
                          color: Color(0xff4d4948),
                        ),
                      ),
                      if (!isPrimarySingle)
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            '?????????? ?????????????? ?????????????????? ??????????????????${!isRequired ? "\n?????? ????????????????????" : ""}',
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0,
                              color: Color(0xff7d7d7d),
                            ),
                          ),
                        ),
                      const SizedBox(height: 20.0),
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 350),
                        opacity: primaryData.isEmpty || isLoading ? 0.0 : 1.0,
                        child: Column(
                          children: primaryData.toList().mapToList((e, i) {
                            final isSelected =
                                selectedPrimary.value.contains(i);
                            return Padding(
                              padding: EdgeInsets.only(
                                top: i == 0 ? 0.0 : 20.0,
                                left: 50.0,
                                right: 50.0,
                              ),
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 350),
                                opacity:
                                    isSelected || canSelectPrimary ? 1.0 : 0.5,
                                child: ListButtonWidget(
                                  hasCheckbox: true,
                                  checkboxStatus: isSelected,
                                  text: e,
                                  onTap: canSelectPrimary || isSelected
                                      ? () => onSelectPrimary(i)
                                      : () {},
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      if (secondaryData.isNotEmpty)
                        if (secondaryText.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 28.0),
                            child: Container(
                              width: double.infinity,
                              height: 10.0,
                              color: const Color(0xffe5e5e5),
                            ),
                          )
                        else
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30.0),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  secondaryText,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 18.0,
                                    color: Color(0xff4d4948),
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                if (!isSecondarySingle)
                                  const Text(
                                    '?????????? ?????????????? ?????????????????? ??????????????????',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 14.0,
                                      color: Color(0xff7d7d7d),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                      if (hasAlternative)
                        alternative!
                      else if (secondaryData.isNotEmpty)
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 350),
                          opacity:
                              secondaryData.isEmpty || isLoading ? 0.0 : 1.0,
                          child: Column(
                            children: secondaryData.mapToList((e, i) {
                              final isSelected =
                                  selectedSecondary.value.contains(i);
                              return Padding(
                                padding: EdgeInsets.only(
                                  top: i == 0 ? 0.0 : 20.0,
                                  left: 50.0,
                                  right: 50.0,
                                ),
                                child: AnimatedOpacity(
                                  duration: const Duration(milliseconds: 350),
                                  opacity: canSelectSecondary || isSelected
                                      ? 1.0
                                      : 0.5,
                                  child: ListButtonWidget(
                                    hasCheckbox: true,
                                    checkboxStatus: isSelected,
                                    text: e,
                                    onTap: canSelectSecondary || isSelected
                                        ? () => onSelectSecondary(i)
                                        : () {},
                                  ),
                                ),
                              );
                            }),
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
                  isActive: isRequired
                      ? !canSelectPrimary || !canSelectSecondary
                      : true,
                  onTap: () => onContinue(
                    selectedPrimary.value.isNotEmpty
                        ? selectedPrimary.value
                            .mapToList((e, _) => primaryData[e])
                        : selectedSecondary.value
                            .mapToList((e, _) => secondaryData[e]),
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
