import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MemoEditForm extends StatelessWidget {
  final Map<String, dynamic> defaults;
  const MemoEditForm(this.defaults, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          FormBuilderTextField(
            name: "title",
            initialValue: defaults["title"] ?? "",
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.editFieldTitle,
              prefixIcon: const Icon(Icons.title, color: Colors.transparent),
            ),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
            ]),
          ),
          const SizedBox(
            height: 20,
          ),
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
        ],
      ),
    );
  }
}
