import 'package:flutter/material.dart';
import 'package:private_notes_light/features/welcome/presentation/welcome_page.dart';

class SlidePage extends StatelessWidget {
  final SlideData slide;
  const SlidePage({super.key, required this.slide});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(color: colorScheme.primaryContainer, shape: BoxShape.circle),
            child: Center(child: Icon(slide.icon, size: 48, color: colorScheme.onPrimaryContainer)),
          ),
          const SizedBox(height: 40),
          Text(slide.title, textAlign: TextAlign.center, style: textTheme.headlineMedium),
          const SizedBox(height: 20),
          Flexible(
            child: SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(maxWidth: 500),
                child: Text(
                  slide.content,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
