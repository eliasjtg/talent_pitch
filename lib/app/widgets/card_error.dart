import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Card error
class CardErrorWidget extends StatelessWidget {
  /// [onRetry] callback
  final VoidCallback? onRetry;

  /// CardErrorWidget constructor
  const CardErrorWidget({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(
                Icons.bug_report,
                color: Colors.red,
              ),
              title: Text(AppLocalizations.of(context)!.error_title),
              subtitle: Text(AppLocalizations.of(context)!.error_subtitle),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  onPressed: onRetry,
                  child: Text(AppLocalizations.of(context)!.retry),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
