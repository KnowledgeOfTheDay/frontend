import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class UrlEditForm extends StatelessWidget {
  final Map<String, dynamic> defaults;
  const UrlEditForm(this.defaults, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          FormBuilderTextField(
            name: "url",
            initialValue: defaults["url"] ?? "",
            maxLines: null,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              hintText: "Website Url",
              prefixIcon: Icon(
                Icons.link,
                color: Colors.transparent,
              ),
            ),
            style: const TextStyle(fontSize: 18),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.url(),
            ]),
          )
        ],
      ),
    );
  }
}
