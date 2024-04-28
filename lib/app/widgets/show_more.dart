import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Show more widget
class ShowMoreWidget extends StatelessWidget {
  /// Expandable [text]
  final String text;

  /// ShowMoreWidget constructor
  const ShowMoreWidget(
    this.text, {
    super.key,
  });

  @override
  Widget build(BuildContext context) => ReadMoreText(
        text,
        trimMode: TrimMode.Line,
        trimLines: 2,
        colorClickableText: Colors.pink,
        trimCollapsedText: AppLocalizations.of(context)!.show_more,
        trimExpandedText: AppLocalizations.of(context)!.show_less,
        moreStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        style: const TextStyle(color: Colors.white),
      );
}
