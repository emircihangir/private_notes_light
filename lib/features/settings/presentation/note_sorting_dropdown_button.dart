import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/features/settings/application/settings_controller.dart';
import 'package:private_notes_light/features/settings/domain/sorting_option.dart';
import 'package:private_notes_light/l10n/app_localizations.dart';

class NoteSortingDropdownButton extends ConsumerWidget {
  const NoteSortingDropdownButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settingsController = ref.watch(settingsControllerProvider);
    const iconSize = 20.0;
    const rowSpacing = 8.0;

    return settingsController
            .whenData(
              (settingsData) => DropdownButtonHideUnderline(
                child: DropdownButton<SortingOption>(
                  alignment: const AlignmentGeometry.xy(0, 0),
                  isExpanded: false,
                  icon: const Icon(Icons.arrow_drop_down_rounded),
                  items: [
                    DropdownMenuItem(
                      value: SortingOption.aToZ,
                      child: Row(
                        spacing: rowSpacing,
                        children: [
                          const Icon(Icons.sort_rounded, size: iconSize),
                          Text(l10n.aToZ),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: SortingOption.zToA,
                      child: Row(
                        spacing: rowSpacing,
                        children: [
                          const Icon(Icons.sort_rounded, size: iconSize),
                          Text(l10n.zToA),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: SortingOption.newestFirst,
                      child: Row(
                        spacing: rowSpacing,
                        children: [
                          const Icon(Icons.calendar_month_rounded, size: iconSize),
                          Text(l10n.newestFirst),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: SortingOption.oldestFirst,
                      child: Row(
                        spacing: rowSpacing,
                        children: [
                          const Icon(Icons.calendar_month_rounded, size: iconSize),
                          Text(l10n.oldestFirst),
                        ],
                      ),
                    ),
                  ],
                  value: settingsData.sortingOption,
                  onChanged: (value) async => await ref.read(settingsControllerProvider.notifier).setSortingOption(value!),
                ),
              ),
            )
            .valueOrNull ??
        const SizedBox();
  }
}
