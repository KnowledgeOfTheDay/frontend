import 'package:flutter/material.dart';
import 'knowledge_list_item.dart';
import 'package:provider/provider.dart';

import '../models/knowledges.dart';
import 'knowledge_list_item.dart';

class KnowledgesList extends StatefulWidget {
  const KnowledgesList({Key? key}) : super(key: key);

  @override
  State<KnowledgesList> createState() => _KnowledgesListState();
}

class _KnowledgesListState extends State<KnowledgesList> {
  bool _isLoading = false;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    if (!_isInitialized) {
      _isInitialized = true;
      _isLoading = true;

      final messenger = ScaffoldMessenger.of(context);
      Provider.of<Knowledges>(context, listen: false).fetchKnowledges().then((success) {
        setState(() {
          _isLoading = false;
        });

        if (!success) {
          messenger.showSnackBar(const SnackBar(
            content: Text(
              "Failed to fetch data",
              textAlign: TextAlign.center,
            ),
            behavior: SnackBarBehavior.floating,
          ));
        }
      });
    }

    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> _refreshList() async {
    final messenger = ScaffoldMessenger.of(context);
    bool success = await Provider.of<Knowledges>(context, listen: false).fetchKnowledges();
    setState(() {
      _isLoading = false;
    });

    if (!success) {
      messenger.showSnackBar(const SnackBar(
        content: Text(
          "Failed to fetch data",
          textAlign: TextAlign.center,
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final knowledges = Provider.of<Knowledges>(context).items;

    return RefreshIndicator(
      onRefresh: _refreshList,
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: knowledges.length,
              itemBuilder: (_, i) => ChangeNotifierProvider.value(
                value: knowledges[i],
                child: KnowledgeListItem(knowledges[i]),
              ),
            ),
    );
  }
}
