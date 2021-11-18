import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:hot_tours/utils/date.dart';
import 'package:hot_tours/utils/string.dart';

import 'package:hot_tours/models/abstract_data.model.dart';
import 'package:hot_tours/search_tours/models/data.model.dart' as search_tours;

import 'package:hot_tours/widgets/form_field.widget.dart';
import 'package:hot_tours/widgets/form_submit.widget.dart';

class FormModel {
  String name;
  String number;

  FormModel({
    required this.name,
    required this.number,
  });
}

class FormWidget extends HookWidget {
  final AbstractDataModel data;
  final void Function(FormModel) onSubmit;

  const FormWidget({
    Key? key,
    required this.data,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = useState(GlobalKey<FormState>());
    final formData = useState(FormModel(name: '', number: ''));

    final nameFocusNode = useFocusNode();
    void setName(String value) => formData.value.name = value;

    final numberFocusNode = useFocusNode();
    void setNumber(String value) => formData.value.number = value;

    return Form(
      key: formKey.value,
      child: Column(
        children: <Widget>[
          nameFormField(
            focusNode: nameFocusNode,
            onChange: setName,
          ),
          const SizedBox(height: 30.0),
          numberFormField(
            focusNode: numberFocusNode,
            onChange: setNumber,
          ),
          if (data is search_tours.DataModel)
            () {
              final _data = data as search_tours.DataModel;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 40.0),
                  Text(
                    '${_data.departCity!.name} ${_data.targetCountry!.name}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.normal,
                      fontSize: 18.0,
                    ),
                  ),
                  Text(
                    _data.tourDates.pretty +
                        ', ' +
                        () {
                          final nights = _data.nightsCount;
                          return '${nights.fst} - ${nights.snd} ночей';
                        }() +
                        ', ' +
                        () {
                          final people = _data.peopleCount;
                          if (people.snd!.eq(0)) {
                            return '${people.fst} ${declineWord('взрослый', people.fst!)}';
                          }
                          return '${people.fst} ${declineWord('взрослый', people.fst!).substring(0, 3)} + ${people.snd} ${declineWord('ребёнок', people.snd!).substring(0, 3)}';
                        }(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.normal,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              );
            }(),
          const SizedBox(height: 40.0),
          FormSubmitWidget(
            text: 'Отправить',
            onTap: () {
              nameFocusNode.unfocus();
              numberFocusNode.unfocus();
              if (formKey.value.currentState!.validate()) {
                onSubmit(formData.value);
              }
            },
            backgroundColor: const Color(0xffeba627),
          ),
        ],
      ),
    );
  }
}
