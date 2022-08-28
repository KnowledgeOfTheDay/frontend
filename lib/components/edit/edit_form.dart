import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditForm extends StatelessWidget {
  final Map<String, dynamic> defaults;
  final GlobalKey<FormBuilderState> _formKey;
  const EditForm(this._formKey, this.defaults, {Key? key}) : super(key: key);

  String _priorityToText(int value, BuildContext context) {
    String result = value.toString();
    switch (value) {
      case 1:
        result = "1 - ${AppLocalizations.of(context)!.priorityLow}";
        break;
      case 3:
        result = "3 - ${AppLocalizations.of(context)!.priorityMedium}";
        break;
      case 5:
        result = "5 - ${AppLocalizations.of(context)!.priorityHigh}";
        break;
    }

    return result;
  }

  String? _validateTitle(String? value, BuildContext context) {
    final url = _formKey.currentState?.fields["url"]?.value;
    if ((null == url || url!.isEmpty) && (null == value || value.isEmpty)) {
      return AppLocalizations.of(context)!.errorTitleCannotBeEmpty;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: Column(
          children: [
            FormBuilderTextField(
              name: "url",
              initialValue: defaults["url"] ?? "",
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.editFieldUrl,
                prefixIcon: const Icon(
                  Icons.link,
                ),
              ),
              style: const TextStyle(fontSize: 18),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.url(),
              ]),
            ),
            const SizedBox(height: 10),
            FormBuilderTextField(
              name: "title",
              initialValue: defaults["title"] ?? "",
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.editFieldTitle,
                prefixIcon: const Icon(Icons.title),
              ),
              validator: (val) => _validateTitle(val, context),
            ),
            const SizedBox(height: 30),
            FormBuilderTextField(
              name: "description",
              initialValue: defaults["description"] ?? "",
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.editFieldDescription,
                prefixIcon: const Icon(Icons.description),
              ),
              minLines: 1,
              maxLines: 5,
            ),
            const SizedBox(
              height: 10,
            ),
            FormBuilderDropdown(
                name: "priority",
                decoration: const InputDecoration(prefixIcon: Icon(Icons.star)),
                initialValue: defaults["priority"] ?? 1,
                items: [
                  for (int i = 1; i <= 5; i++)
                    DropdownMenuItem(
                      value: i,
                      child: Text(_priorityToText(i, context)),
                    )
                ])
          ],
        ),
      ),
    );
  }
}