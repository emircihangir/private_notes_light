import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/core/fade_page_route_builder.dart';
import 'package:private_notes_light/features/authentication/presentation/signup_screen.dart';
import 'package:private_notes_light/features/welcome/data/welcome_repository.dart';
import 'package:private_notes_light/features/welcome/presentation/dot_indicator.dart';
import 'package:private_notes_light/features/welcome/presentation/slide_page.dart';
import 'package:private_notes_light/l10n/app_localizations.dart';

class SlideData {
  final IconData icon;
  final String title;
  final Widget body;
  const SlideData({required this.icon, required this.title, required this.body});
}

class WelcomePage extends ConsumerStatefulWidget {
  const WelcomePage({super.key});

  @override
  ConsumerState<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends ConsumerState<WelcomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  List<SlideData> _slides = [];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _goToNextPage() async {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      await ref.read(welcomeRepositoryProvider).markShown();
      if (mounted) {
        Navigator.of(
          context,
        ).pushAndRemoveUntil(fadePageRouteBuilder(SignupScreen()), (route) => false);
      }
    }
  }

  // Slides
  SlideData _slide1() => SlideData(
    icon: Icons.lock_outline_rounded,
    title: AppLocalizations.of(context)!.slide1Title,
    body: Text(
      AppLocalizations.of(context)!.slide1Content,
      style: Theme.of(context).textTheme.bodyLarge,
      textAlign: TextAlign.justify,
    ),
  );

  SlideData _slide2() => SlideData(
    icon: Icons.edit_note_rounded,
    title: AppLocalizations.of(context)!.slide2Title,
    body: Text(
      AppLocalizations.of(context)!.slide2Content,
      style: Theme.of(context).textTheme.bodyLarge,
      textAlign: TextAlign.justify,
    ),
  );

  SlideData _slide3() => SlideData(
    icon: Icons.warning_amber_rounded,
    title: AppLocalizations.of(context)!.slide3Title,
    body: Expanded(
      child: SingleChildScrollView(
        child: Text(
          AppLocalizations.of(context)!.slide3Content,
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.justify,
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    _slides = [_slide1(), _slide2(), _slide3()];
    final colorScheme = Theme.of(context).colorScheme;
    final isLastPage = _currentPage == _slides.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (_, index) => SlidePage(slide: _slides[index]),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _slides.length,
                  (index) =>
                      DotIndicator(isActive: index == _currentPage, color: colorScheme.primary),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: Row(
                children: [
                  const Spacer(),
                  TextButton(
                    onPressed: _goToNextPage,
                    child: Text(
                      isLastPage
                          ? AppLocalizations.of(context)!.getStarted
                          : AppLocalizations.of(context)!.next,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
