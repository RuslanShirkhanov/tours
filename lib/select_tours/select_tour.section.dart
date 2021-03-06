import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:hot_tours/api.dart';

import 'package:hot_tours/utils/show_route.dart';
import 'package:hot_tours/utils/sorted.dart';
import 'package:hot_tours/utils/connection.dart';
import 'package:hot_tours/utils/common_storage.dart';

import 'package:hot_tours/models/unsigned.dart';
import 'package:hot_tours/models/depart_city.model.dart';
import 'package:hot_tours/select_tours/models/data.model.dart';

import 'package:hot_tours/select_tours/routes/select_from.route.dart';
import 'package:hot_tours/select_tours/routes/select_where.route.dart';

import 'package:hot_tours/widgets/nav_bar.widget.dart';
import 'package:hot_tours/widgets/list_button.widget.dart';
import 'package:hot_tours/widgets/footer.widget.dart';

void showSelectTourSection({
  required BuildContext context,
}) =>
    showRoute<DataModel?>(
      context: context,
      model: DataModel.empty(),
      builder: (data) => PageRouteBuilder(
        pageBuilder: (context, fst, snd) => SelectTourSection(
          data: data!,
          onContinue: (data) => showSelectWhereRoute(
            context: context,
            data: data,
          ),
        ),
        transitionsBuilder: (context, fst, snd, child) {
          const begin = Offset(0.0, 1.0);
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

class SelectTourSection extends HookWidget {
  final DataModel data;
  final void Function(DataModel) onContinue;

  const SelectTourSection({
    Key? key,
    required this.data,
    required this.onContinue,
  }) : super(key: key);

  void Function(T) setState<T>(ValueNotifier<T> state) =>
      (T value) => state.value = value;

  @override
  Widget build(BuildContext context) {
    final connection = ConnectionUtil.useConnection();

    final scrollController = useScrollController();

    final isLoading = useState(false);

    final departCities = useState(const <DepartCityModel>[]);
    final selectedCity = useState<DepartCityModel?>(null);

    useEffect(() {
      setState<bool>(isLoading)(true);

      if (connection.value.isNotNone) {
        Api.getDepartCities(showcase: false).then((value) {
          departCities.value = value.sorted((a, b) => a.name.compareTo(b.name));
          setState<DepartCityModel?>(selectedCity)(
            CommonStorageController.getValue(
              key: CDK.departCity,
              initial: value[0],
            ),
          );
          setState<bool>(isLoading)(false);
        });
      }
    }, [connection.value]);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: NavBarWidget(
                sectionsCount: const U(6),
                sectionIndex: data.sectionIndex,
                hasSectionIndicator: true,
                title: '???????????? ????????',
                hasSubtitle: false,
                backgroundColor: const Color(0xff2eaeee),
                hasBackButton: true,
                isLoading: isLoading.value,
                hasLoadingIndicator: true,
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 53.0, bottom: 70.0),
                child: Scrollbar(
                  controller: scrollController,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.only(
                      top: 80.0,
                      bottom: 20.0,
                      left: 50.0,
                      right: 50.0,
                    ),
                    child: Column(
                      children: <Widget>[
                        const Text(
                          '???????????????? ?????????? ????????????',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.normal,
                            fontSize: 22.0,
                            color: Color(0xff4d4948),
                          ),
                        ),
                        const SizedBox(height: 70.0),
                        ListButtonWidget(
                          text: selectedCity.value?.name ?? '',
                          onTap: () => showSelectFromRoute(
                              context: context,
                              data: departCities.value,
                              onSelect: (value) =>
                                  setState<DepartCityModel?>(selectedCity)(
                                    CommonStorageController.setValue(
                                      key: CDK.departCity,
                                      value: value,
                                    ),
                                  )),
                        ),
                      ],
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
                  isActive: selectedCity.value != null,
                  onTap: () => onContinue(
                    data.setDepartCity(selectedCity.value!),
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
