import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:hot_tours/utils/map_to_list.dart';

import 'package:hot_tours/widgets/header.widget.dart';
import 'package:hot_tours/widgets/list_button.widget.dart';
import 'package:hot_tours/widgets/footer.widget.dart';

class SelectManyRoute<T> extends HookWidget {
  final String title;
  final String subtitle;

  final List<T> primaryData;
  final bool isPrimarySingle;

  final List<T> secondaryData;
  final bool isSecondarySingle;

  final String Function(T) transform;
  final void Function(List<int>) onContinue;

  final FooterButtonModel? cancel;
  final FooterButtonModel? reset;

  final bool hasLoadingIndicator;
  final bool isLoading;

  const SelectManyRoute({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.primaryData,
    this.isPrimarySingle = false,
    required this.secondaryData,
    this.isSecondarySingle = false,
    required this.transform,
    required this.onContinue,
    this.cancel,
    this.reset,
    this.hasLoadingIndicator = false,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

    void reset() {
      selectedPrimary.value = const [];
      selectedSecondary.value = const [];
    }

    void onSelectPrimary(int index) {
      if (selectedPrimary.value.contains(index))
        selectedPrimary.value =
            selectedPrimary.value.where((i) => i != index).toList();
      else
        selectedPrimary.value = [index, ...selectedPrimary.value];
    }

    void onSelectSecondary(int index) {
      if (selectedSecondary.value.contains(index))
        selectedSecondary.value =
            selectedSecondary.value.where((i) => i != index).toList();
      else
        selectedSecondary.value = [index, ...selectedSecondary.value];
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: HeaderWidget(
                backgroundColor: const Color(0xff2Eaeee),
                hasSectionIndicator: false,
                title: title,
                hasSubtitle: true,
                subtitle: subtitle,
                hasBackButton: true,
                hasLoadingIndicator: hasLoadingIndicator,
                isLoading: isLoading,
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 78.0, bottom: 70.0),
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: 50.0,
                  ),
                  children: <Widget>[
                    Column(
                      children: primaryData.mapToList((e, i) {
                        final isSelected = selectedPrimary.value.contains(i);
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 350),
                            opacity: canSelectPrimary || isSelected ? 1.0 : 0.5,
                            child: ListButtonWidget(
                              hasCheckbox: true,
                              checkboxStatus: isSelected,
                              text: transform(e),
                              onTap: canSelectPrimary || isSelected
                                  ? () => onSelectPrimary(i)
                                  : () {},
                            ),
                          ),
                        );
                      }),
                    ),
                    Column(
                      children: secondaryData.mapToList((e, i) {
                        final isSelected = selectedSecondary.value.contains(i);
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 350),
                            opacity:
                                canSelectSecondary || isSelected ? 1.0 : 0.5,
                            child: ListButtonWidget(
                              hasCheckbox: true,
                              checkboxStatus: isSelected,
                              text: transform(e),
                              onTap: canSelectSecondary || isSelected
                                  ? () => onSelectSecondary(i)
                                  : () {},
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: FooterWidget(
                ok: FooterButtonModel(
                  kind: FooterButtonKind.ok,
                  isActive: !canSelectPrimary || !canSelectSecondary,
                  onTap: () => onContinue(
                    selectedPrimary.value.isNotEmpty
                        ? selectedPrimary.value.mapToList((index, _) => index)
                        : selectedSecondary.value
                            .mapToList((index, _) => index),
                  ),
                ),
                cancel: FooterButtonModel(
                  kind: FooterButtonKind.cancel,
                  isActive: true,
                  onTap: () => Navigator.of(context).pop(),
                ),
                reset: FooterButtonModel(
                  kind: FooterButtonKind.reset,
                  isActive: selectedPrimary.value.isNotEmpty ||
                      selectedSecondary.value.isNotEmpty,
                  onTap: reset,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
