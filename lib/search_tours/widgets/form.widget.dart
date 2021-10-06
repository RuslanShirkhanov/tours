import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

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
  final void Function(FormModel) onSubmit;

  const FormWidget({
    Key? key,
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

    return Container(
      child: Form(
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
            const SizedBox(height: 45.0),
            FormSubmitWidget(
              text: 'Отправить',
              onTap: () {
                nameFocusNode.unfocus();
                numberFocusNode.unfocus();
                if (formKey.value.currentState!.validate())
                  onSubmit(formData.value);
              },
              textColor: Colors.white,
              backgroundColor: const Color(0xff2eaeee),
            ),
          ],
        ),
      ),
    );
  }
}
