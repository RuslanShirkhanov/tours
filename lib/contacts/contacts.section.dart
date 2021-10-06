import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:hot_tours/utils/show_route.dart';

import 'package:hot_tours/widgets/header.widget.dart';
import 'package:hot_tours/widgets/list_button.widget.dart';

import 'package:hot_tours/contacts/routes/callback.route.dart';

void showContactsRoute({
  required BuildContext context,
}) =>
    showRoute<Object?>(
      context: context,
      model: null,
      builder: (data) => PageRouteBuilder(
        pageBuilder: (context, fst, snd) => const ContactsRoute(),
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

class ContactsRoute extends HookWidget {
  const ContactsRoute({Key? key}) : super(key: key);

  Widget _buildButton({
    required String path,
    required String text,
    required void Function() onTap,
  }) =>
      ListButtonWidget(
        path: path,
        text: text,
        onTap: onTap,
      );

  void Function(T) setState<T>(ValueNotifier<T> state) =>
      (T value) => state.value = value;

  void _showSnackBar({
    required BuildContext context,
    required String text,
  }) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.normal,
              fontSize: 16.0,
              color: Colors.white,
            ),
          ),
        ),
      );

  void _showErrorAlert({
    required BuildContext context,
    required bool value,
  }) {
    if (!value) {
      _showSnackBar(
        context: context,
        text: 'Ошибка: не удалось открыть приложение',
      );
    }
  }

  Future<void> _makeLaunchRequest({
    required BuildContext context,
    required ValueNotifier<bool> state,
    required String url,
  }) async {
    setState(state)(true);
    await launch(url).then(
      (value) => _showErrorAlert(
        context: context,
        value: value,
      ),
    );
    setState(state)(false);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = useState(false);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: HeaderWidget(
                hasSectionIndicator: false,
                title: 'Контакты',
                hasSubtitle: false,
                backgroundColor: const Color(0xff2eaeee),
                hasBackButton: true,
                hasLoadingIndicator: true,
                isLoading: isLoading.value,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 48.0),
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                  top: 40.0,
                  left: 40.0,
                  right: 40.0,
                  bottom: 20.0,
                ),
                child: Column(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        _buildButton(
                          path: 'assets/phone.svg',
                          text: '8 (800) 700 24 19',
                          onTap: () => _makeLaunchRequest(
                            context: context,
                            state: isLoading,
                            url: 'tel:88007002419',
                          ),
                        ),
                        const SizedBox(height: 25.0),
                        _buildButton(
                          path: 'assets/phone.svg',
                          text: 'Обратный звонок',
                          onTap: () => showCallbackRoute(context: context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 54.0),
                    Column(
                      children: <Widget>[
                        _buildButton(
                          path: 'assets/email.svg',
                          text: 'all-turs@yandex.ru',
                          onTap: () => _makeLaunchRequest(
                            context: context,
                            state: isLoading,
                            url: 'mailto:all-turs@yandex.ru',
                          ),
                        ),
                        const SizedBox(height: 25.0),
                        _buildButton(
                          path: 'assets/cursor.svg',
                          text: 'все-туры.рф',
                          onTap: () => _makeLaunchRequest(
                            context: context,
                            state: isLoading,
                            url: 'https://все-туры.рф/',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 54.0),
                    Column(
                      children: <Widget>[
                        _buildButton(
                          path: 'assets/whatsapp.svg',
                          text: 'WhatsApp',
                          onTap: () => _makeLaunchRequest(
                            context: context,
                            state: isLoading,
                            url: 'whatsapp://send?phone=79628212311',
                          ),
                        ),
                        const SizedBox(height: 25.0),
                        _buildButton(
                          path: 'assets/viber.svg',
                          text: 'Viber',
                          onTap: () => _makeLaunchRequest(
                            context: context,
                            state: isLoading,
                            url: 'viber://chat?number=%2B7(962)8212311',
                          ),
                        ),
                        const SizedBox(height: 25.0),
                        _buildButton(
                          path: 'assets/telegram.svg',
                          text: 'Telegram',
                          onTap: () => _makeLaunchRequest(
                            context: context,
                            state: isLoading,
                            url: 'tg://resolve?domain=vseturi',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
