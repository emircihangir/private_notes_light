import 'package:flutter/material.dart';
import 'package:private_notes_light/l10n/app_localizations.dart';

class HelpButton extends StatelessWidget {
  final String helpTitle;
  final String helpText;
  const HelpButton({super.key, required this.helpText, required this.helpTitle});

  @override
  Widget build(BuildContext context) {
    void handlePress() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(helpTitle),
            content: Text(helpText),
            actions: [
              TextButton(
                child: Text(AppLocalizations.of(context)!.ok),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    }

    return SizedBox(
      height: 40,
      child: IconButton(onPressed: handlePress, icon: Icon(Icons.help_outline_rounded)),
    );
  }
}
