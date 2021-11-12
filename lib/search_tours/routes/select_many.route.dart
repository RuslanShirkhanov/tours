import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:hot_tours/utils/map_to_list.dart';

import 'package:hot_tours/widgets/nav_bar.widget.dart';
import 'package:hot_tours/widgets/list_button.widget.dart';
import 'package:hot_tours/widgets/footer.widget.dart';

class SelectManyRoute<T> extends HookWidget {
  final String title;
  final String subtitle;

  final List<T> values;
  final ValueNotifier<List<int>>? initial;
  final bool isSingle;

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
    required this.values,
    this.initial,
    required this.isSingle,
    required this.transform,
    required this.onContinue,
    this.cancel,
    this.reset,
    this.hasLoadingIndicator = false,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();

    final selected = useState(initial?.value ?? []);

    useEffect(() {
      selected.value = initial?.value ?? selected.value;
    }, [initial?.value]);

    final canSelect = useMemoized(
      () => selected.value.isEmpty ? true : !isSingle,
      [selected.value],
    );

    bool isSelected(int index) => selected.value.contains(index);

    void onSelect(int index) {
      if (selected.value.contains(index)) {
        selected.value = selected.value.where((i) => i != index).toList();
      } else {
        selected.value = [...selected.value, index];
      }
    }

    void reset() => selected.value = const [];

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: NavBarWidget(
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
                child: Scrollbar(
                  controller: scrollController,
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(
                      vertical: 20.0,
                      horizontal: 50.0,
                    ),
                    children: <Widget>[
                      Column(
                        children: values.mapToList((e, i) {
                          final _isSelected = isSelected(i);
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 350),
                              opacity: canSelect || _isSelected ? 1.0 : 0.5,
                              child: ListButtonWidget(
                                hasCheckbox: true,
                                checkboxStatus: _isSelected,
                                text: transform(e),
                                onTap: canSelect || _isSelected
                                    ? () => onSelect(i)
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
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: FooterWidget(
                ok: FooterButtonModel(
                  kind: FooterButtonKind.ok,
                  isActive: selected.value.isNotEmpty,
                  onTap: () => onContinue(selected.value), // !!!
                ),
                cancel: FooterButtonModel(
                  kind: FooterButtonKind.cancel,
                  isActive: true,
                  onTap: () => Navigator.of(context).pop(),
                ),
                reset: FooterButtonModel(
                  kind: FooterButtonKind.reset,
                  isActive: selected.value.isNotEmpty,
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
