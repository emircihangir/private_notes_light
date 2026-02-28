import 'package:flutter/material.dart';
import 'package:private_notes_light/features/notes/domain/note.dart';

class ViewNoteView extends StatefulWidget {
  final Note note;
  final VoidCallback onEditPressed;
  const ViewNoteView({super.key, required this.note, required this.onEditPressed});

  @override
  State<ViewNoteView> createState() => _ViewNoteViewState();
}

class _ViewNoteViewState extends State<ViewNoteView> {
  final ScrollController _scrollController = ScrollController();
  bool _showAppBarTitle = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final shouldShow = _scrollController.offset > 80;
      if (shouldShow != _showAppBarTitle) {
        setState(() => _showAppBarTitle = shouldShow);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 0,
            automaticallyImplyLeading: true,
            centerTitle: true,
            title: AnimatedOpacity(
              opacity: _showAppBarTitle ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Text(
                widget.note.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              ),
            ),
            actions: [
              IconButton(onPressed: widget.onEditPressed, icon: const Icon(Icons.edit_rounded)),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            sliver: SliverToBoxAdapter(
              child: Text(widget.note.title, style: Theme.of(context).textTheme.headlineLarge),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            sliver: SliverToBoxAdapter(
              child: Text(widget.note.content, style: Theme.of(context).textTheme.bodyLarge),
            ),
          ),
        ],
      ),
    );
  }
}
