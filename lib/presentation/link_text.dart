import 'package:flutter/material.dart';
import 'package:private_notes_light/presentation/snackbars.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkText extends StatelessWidget {
  final String url;
  final String? urlText;
  const LinkText({super.key, required this.url, this.urlText});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: TextButton(
        style: TextButton.styleFrom(padding: EdgeInsets.zero),
        onPressed: () async {
          final result = await launchUrl(Uri.parse(url), mode: .externalApplication);
          if (result == false && context.mounted) {
            showErrorSnackbar(context);
          }
        },
        child: Row(
          crossAxisAlignment: .center,
          mainAxisSize: .min,
          spacing: 3,
          children: [Text(urlText ?? url), Icon(Icons.open_in_new_rounded, size: 14)],
        ),
      ),
    );
  }
}
