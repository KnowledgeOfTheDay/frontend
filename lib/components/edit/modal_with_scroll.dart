import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:kotd/models/categories.dart';
import 'package:kotd/models/category.dart';
import 'package:kotd/models/knowledge.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'edit_form.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/knowledges.dart';

class ModalWithScroll extends StatefulWidget {
  final String? id;
  final Map<String, dynamic> initialValues;
  final bool isEdit;

  const ModalWithScroll({this.id, this.initialValues = const {}, this.isEdit = false, Key? key}) : super(key: key);

  @override
  State<ModalWithScroll> createState() => _ModalWithScrollState();
}

class _ModalWithScrollState extends State<ModalWithScroll> {
  static final _formKey = GlobalKey<FormBuilderState>();
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();

  void _addMissingCategories(BuildContext context, List<Category> categories) {
    final provider = Provider.of<Categories>(context, listen: false);
    for (final category in categories) {
      if (!provider.items.any((element) => element.name == category.name)) {
        provider.add(category);
      }
    }
  }

  Future<void> _saveForm(context) async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      final data = _formKey.currentState?.value;
      if (null != data) {
        final provider = Provider.of<Knowledges>(context, listen: false);

        bool success = !widget.isEdit && null == widget.id
            ? await provider.add(Knowledge.fromJson(data))
            : await provider.update(widget.id!, Knowledge.fromJson({...widget.initialValues, ...data}));
        if (success) {
          // _addMissingCategories(context, data["categories"]);
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
            AppLocalizations.of(context)!.errorAddingFailed,
            textAlign: TextAlign.center,
          )));
          _btnController.error();
        }
      }
    } else {
      _btnController.error();
    }
  }

  @override
  void didChangeDependencies() {
    Provider.of<Categories>(context, listen: false).fetchCategories().then((value) {});

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (MediaQuery.of(context).size.height) * .5,
      child: Material(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(top: 12, right: 12, bottom: 12),
                child: RoundedLoadingButton(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  width: 100,
                  controller: _btnController,
                  onPressed: () async => await _saveForm(context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(AppLocalizations.of(context)!.editSave),
                  ),
                ),
              )
            ],
          ),
          body: FormBuilder(key: _formKey, child: EditForm(_formKey, widget.initialValues, buttonController: _btnController)),
        ),
      ),
    );
  }
}
