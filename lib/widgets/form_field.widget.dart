import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:hot_tours/utils/string.dart';

Widget nameFormField({
  required void Function(String) onChange,
  FocusNode? focusNode,
}) =>
    FormFieldWidget(
      focusNode: focusNode,
      labelText: 'Имя',
      hintText: 'Введите Ваше имя',
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Поле не должно быть пустым';
        } else if (value.trim().replaceAll(RegExp(r'\s+'), '').isEmpty) {
          return 'Некорректное имя';
        } else {
          onChange(value.trim().replaceAll(RegExp(r'\s+'), '').capitalized);
        }
        return null;
      },
      keyboardType: TextInputType.name,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.singleLineFormatter,
        FilteringTextInputFormatter.allow(RegExp(
          r'[а-я]|[a-z]|\s',
          caseSensitive: false,
        )),
      ],
    );

Widget numberFormField({
  required void Function(String) onChange,
  FocusNode? focusNode,
}) =>
    FormFieldWidget(
      focusNode: focusNode,
      labelText: 'Телефон',
      hintText: 'Введите номер телефона',
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Поле не должно быть пустым';
        } else if (!['7', '8'].contains(value[0]) || value.length < 17) {
          return 'Некорректный номер телефона';
        } else {
          onChange(value);
        }
        return null;
      },
      keyboardType: TextInputType.phone,
      inputFormatters: <TextInputFormatter>[
        LengthLimitingTextInputFormatter(17),
        FilteringTextInputFormatter.singleLineFormatter,
        FilteringTextInputFormatter.digitsOnly,
        PhoneNumberTextInputFormatter(),
      ],
    );

class FormFieldWidget extends StatelessWidget {
  final String labelText;
  final String hintText;
  final String? Function(String?) validator;
  final TextInputType keyboardType;
  final FocusNode? focusNode;
  final List<TextInputFormatter> inputFormatters;

  const FormFieldWidget({
    Key? key,
    required this.labelText,
    required this.hintText,
    required this.validator,
    required this.keyboardType,
    this.focusNode,
    this.inputFormatters = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                labelText,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 20.0,
                  color: Color(0xff4d4948),
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            TextFormField(
              focusNode: focusNode,
              validator: validator,
              inputFormatters: inputFormatters,
              cursorColor: Colors.black,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 17.0),
                errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffdc2323)),
                  borderRadius: BorderRadius.zero,
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffc2c1c1)),
                  borderRadius: BorderRadius.zero,
                ),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffc2c1c1)),
                  borderRadius: BorderRadius.zero,
                ),
                hintText: hintText,
                hintStyle: const TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 20.0,
                  color: Color(0xffc2c1c1),
                ),
              ),
            ),
          ],
        ),
      );
}

class PhoneNumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;
    int usedSubstringIndex = 0;
    final newText = StringBuffer();
    if (newTextLength >= 2) {
      newText.write(newValue.text.substring(0, usedSubstringIndex = 1) + ' (');
      if (newValue.selection.end >= 1) {
        selectionIndex += 2;
      }
    }
    if (newTextLength >= 5) {
      newText.write(newValue.text.substring(1, usedSubstringIndex = 4) + ') ');
      if (newValue.selection.end >= 4) {
        selectionIndex += 2;
      }
    }
    if (newTextLength >= 8) {
      newText.write(newValue.text.substring(4, usedSubstringIndex = 7) + '-');
      if (newValue.selection.end >= 7) {
        selectionIndex += 1;
      }
    }
    if (newTextLength >= 10) {
      newText.write(newValue.text.substring(7, usedSubstringIndex = 9) + '-');
      if (newValue.selection.end >= 9) {
        selectionIndex += 1;
      }
    }
    if (newTextLength >= usedSubstringIndex) {
      newText.write(newValue.text.substring(usedSubstringIndex));
    }
    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
