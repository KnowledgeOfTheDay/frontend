import 'package:flutter/material.dart';
import 'package:kotd/components/preview/preview_slidable.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/knowledge.dart';
import '../models/knowledges.dart';

class KnowledgesList extends StatefulWidget {
  final Function(List<Knowledge>)? filter;

  const KnowledgesList({this.filter, Key? key}) : super(key: key);

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
          messenger.showSnackBar(SnackBar(
            content: Text(
              AppLocalizations.of(context)!.errorFailedFetchingData,
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
    final errorMessage = AppLocalizations.of(context)!.errorFailedFetchingData;
    bool success = await Provider.of<Knowledges>(context, listen: false).fetchKnowledges();
    setState(() {
      _isLoading = false;
    });

    if (!success) {
      messenger.showSnackBar(SnackBar(
        content: Text(
          errorMessage,
          textAlign: TextAlign.center,
        ),
      ));
    }
  }

  List<Knowledge> _applyFilter(List<Knowledge> knowledges) {
    if (null != widget.filter) {
      return widget.filter!(knowledges);
    }

    return knowledges;
  }

  @override
  Widget build(BuildContext context) {
    var knowledges = Provider.of<Knowledges>(context).items.where((element) => !element.isUsed).toList();
    knowledges = _applyFilter(knowledges);
    knowledges.sort((a, b) {
      int cmp = b.priority.compareTo(a.priority);
      if (cmp != 0) return cmp;
      return b.createdAt.compareTo(a.createdAt);
    });

    return RefreshIndicator(
      onRefresh: _refreshList,
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: knowledges.length,
              itemBuilder: (_, i) => ChangeNotifierProvider.value(
                value: knowledges[i],
                child: PreviewSlidable(knowledges[i]),
              ),
            ),
    );
  }
}
