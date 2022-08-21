import 'package:flutter/material.dart';
import 'package:kotd/components/preview/preview_slidable.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/knowledges.dart';

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
                child: PreviewSlidable(knowledges[i]),
              ),
            ),
    );
  }
}
