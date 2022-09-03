import 'package:flutter/material.dart';
import 'package:kotd/components/knowledges_list.dart';
import 'package:kotd/models/category.dart';

import '../models/knowledge.dart';

class FilteredListScreen extends StatefulWidget {
  static const String routeName = "filtered-list";

  const FilteredListScreen({Key? key}) : super(key: key);

  @override
  State<FilteredListScreen> createState() => _FilteredListScreenState();
}

class _FilteredListScreenState extends State<FilteredListScreen> {
  @override
  Widget build(BuildContext context) {
    final category = ModalRoute.of(context)!.settings.arguments as Category;

    List<Knowledge> _filterByCategory(List<Knowledge> knowledges) {
      return knowledges.where((element) => element.categories.map((e) => e.name).contains(category.name)).toList();
    }

    return Scaffold(
      appBar: AppBar(title: Text(category.name)),
      body: KnowledgesList(filter: _filterByCategory),
    );
  }
}
