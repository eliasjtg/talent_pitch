import 'package:flutter/material.dart';

class CardErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const CardErrorWidget({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              leading: Icon(
                Icons.bug_report,
                color: Colors.red,
              ),
              title: Text('Ocurrio un error'),
              subtitle: Text('No hemos podido cargar la informacion'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  onPressed: onRetry,
                  child: const Text('Reintentar'),
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
