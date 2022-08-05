import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

import '../models/knowledges.dart';

class KnowledgeCreationScreen extends StatefulWidget {
  static const String routeName = "create";

  const KnowledgeCreationScreen({Key? key}) : super(key: key);

  @override
  State<KnowledgeCreationScreen> createState() => _KnowledgeCreationScreenState();
}

class _KnowledgeCreationScreenState extends State<KnowledgeCreationScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  String? urlInitialValue;

  Future<void> _saveForm(context) async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      final data = _formKey.currentState?.value;

      bool success = await Provider.of<Knowledges>(context, listen: false).add(data?["url"]);
      if (success) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          "Adding failed!",
          textAlign: TextAlign.center,
        )));
      }
    }
  }

  @override
  void didChangeDependencies() {
    urlInitialValue = ModalRoute.of(context)?.settings.arguments as String?;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(onPressed: () => _formKey.currentState?.reset(), splashRadius: 25, icon: const Icon(Icons.restore)),
          IconButton(onPressed: () async => await _saveForm(context), splashRadius: 25, icon: const Icon(Icons.save)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: FormBuilder(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                FormBuilderTextField(
                  name: "url",
                  initialValue: urlInitialValue,
                  decoration: const InputDecoration(hintText: "Knowledge Url"),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.url(),
                  ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
