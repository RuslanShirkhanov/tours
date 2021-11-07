import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:hot_tours/api.dart';
import 'package:hot_tours/utils/reqs.dart';

import 'package:hot_tours/utils/show_route.dart';

import 'package:hot_tours/widgets/form_submit.widget.dart';
import 'package:hot_tours/widgets/nav_bar.widget.dart';
import 'package:hot_tours/widgets/form_field.widget.dart';

import 'package:hot_tours/routes/rules.route.dart';

void showCallbackRoute({
  required BuildContext context,
}) =>
    showRoute<Object?>(
      context: context,
      model: null,
      builder: (data) => PageRouteBuilder(
        pageBuilder: (context, fst, snd) => const CallbackRoute(),
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

class CallbackRoute extends HookWidget {
  const CallbackRoute({Key? key}) : super(key: key);

  void Function(T) setState<T>(ValueNotifier<T> state) =>
      (T value) => state.value = value;

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();

    final formKey = useState(GlobalKey<FormState>());
    final formData = useState('');
    final focusNode = useFocusNode();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            NavBarWidget(
              hasBackButton: true,
              title: 'Обратный звонок',
              hasSubtitle: false,
              hasSectionIndicator: false,
              backgroundColor: const Color(0xff2eaeee),
              hasLoadingIndicator: false,
            ),
            Expanded(
              child: Scrollbar(
                controller: scrollController,
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.only(
                    top: 30.0,
                    bottom: 20.0,
                  ),
                  child: Column(
                    children: <Widget>[
                      Form(
                        key: formKey.value,
                        child: Column(
                          children: <Widget>[
                            const SizedBox(height: 130.0),
                            numberFormField(
                              focusNode: focusNode,
                              onChange: setState(formData),
                            ),
                            const SizedBox(height: 45.0),
                            FormSubmitWidget(
                              text: 'Отправить',
                              onTap: () {
                                focusNode.unfocus();
                                if (formKey.value.currentState!.validate()) {
                                  Api.makeCreateLeadRequest(
                                    context: context,
                                    kind: ReqKind.callback,
                                    note:
                                        'Обратный звонок\nДата: ${DateTime.now()}\nНомер: ${formData.value}',
                                  );
                                }
                              },
                              backgroundColor: const Color(0xff2eaeee),
                            ),
                            const SizedBox(height: 100.0),
                            SizedBox(
                              width: 320.0,
                              child: RichText(
                                text: TextSpan(
                                  children: <InlineSpan>[
                                    const TextSpan(
                                      text:
                                          'Отправляя запрос, Вы подтверждаете ',
                                    ),
                                    TextSpan(
                                      text: 'согласие',
                                      style: const TextStyle(
                                        color: Color(0xff0093dd),
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () => showRulesRoute(context),
                                    ),
                                    const TextSpan(
                                      text:
                                          ' на обработку персональных данных.',
                                    ),
                                  ],
                                  style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 10.0,
                                    color: Color(0xff4d4948),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
