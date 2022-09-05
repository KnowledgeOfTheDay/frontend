import 'package:flutter/material.dart';
import 'package:flutter_chips_input/src/chips_input.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:kotd/models/categories.dart';
import 'package:kotd/models/category.dart';
import 'package:provider/provider.dart';

class InputChips extends StatefulWidget {
  final List<Category> initialValues;

  const InputChips(this.initialValues, {super.key});

  @override
  State<InputChips> createState() => _InputChipsState();
}

class _InputChipsState extends State<InputChips> {
  Widget _buildSuggestion(BuildContext context, ChipsInputState<Category> state, Category category) {
    print("Enter build suggestion");
    return ListTile(
      key: ObjectKey(category),
      tileColor: Theme.of(context).colorScheme.background.withOpacity(.5),
      title: Text(category.name),
      onTap: () => state.selectSuggestion(category),
    );
  }

  InputChip _buildChip(BuildContext context, ChipsInputState<Category> state, Category category) {
    return InputChip(
      key: ObjectKey(category),
      onDeleted: () => state.deleteChip(category),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      label: Text(category.name),
    );
  }

  List<Category> _findSuggestion(BuildContext context, String query) {
    print("enter find suggestion");
    if (query.isNotEmpty) {
      print("query ($query)not empty");
      final lowercaseQuery = query.toLowerCase();
      final provider = Provider.of<Categories>(context, listen: false);
      final result = provider.items.where((category) {
        return category.name.toLowerCase().contains(query.toLowerCase());
      }).toList(growable: false)
        ..sort((a, b) => a.name.toLowerCase().indexOf(lowercaseQuery).compareTo(b.name.toLowerCase().indexOf(lowercaseQuery)));
      print("result: $result");
      if (result.isNotEmpty) return result;

      return [Category(query)];
    } else {
      return const [];
    }
  }

  @override
  Widget build(BuildContext context) {
    print("enter build method of input_chips.dart");
    return FormBuilderChipsInput<Category>(
      name: "categories",
      maxChips: 5,
      initialValue: widget.initialValues,
      onChanged: (value) {},
      decoration: const InputDecoration(labelText: "Select a Categorie"),
      chipBuilder: _buildChip,
      findSuggestions: (query) async => _findSuggestion(context, query),
      suggestionBuilder: _buildSuggestion,
      allowChipEditing: true,
      suggestionsBoxMaxHeight: 200,
    );
  }
}