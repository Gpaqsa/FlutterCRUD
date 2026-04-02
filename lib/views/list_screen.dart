import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/objects_viewmodel.dart';
import '../data/models/object_model.dart';
import 'detail_screen.dart';
import 'form_screen.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ObjectsViewModel>().fetchObjects());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restful API Demo APP'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(context),
        child: const Icon(Icons.add),
      ),
      body: Consumer<ObjectsViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (vm.state == ViewState.error) {
            return _ErrorView(
              message: vm.errorMessage ?? 'Unknown error',
              onRetry: () => vm.fetchObjects(),
            );
          }
          if (vm.objects.isEmpty) {
            return const Center(child: Text('No objects found.'));
          }
          return RefreshIndicator(
            onRefresh: vm.fetchObjects,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: vm.objects.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final object = vm.objects[index];
                return _SwipeToDeleteCard(
                  key: ValueKey(object.id),
                  object: object,
                  onTap: () => _navigateToDetail(context, object),
                  onDelete: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Delete Object'),
                        content: Text(
                          'Are you sure you want to delete "${object.name}"?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            child: const Text(
                              'Delete',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                    if (confirmed == true && context.mounted) {
                      final success = await context
                          .read<ObjectsViewModel>()
                          .deleteObject(object.id);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              success
                                  ? '"${object.name}" deleted.'
                                  : 'Failed to delete. Try again.',
                            ),
                          ),
                        );
                      }
                    }
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _navigateToDetail(BuildContext context, ObjectModel object) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailScreen(object: object)),
    );
  }

  void _navigateToForm(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FormScreen()),
    );
  }
}

// ── Custom swipe card ────────────────────────────────────────────────────────

class _SwipeToDeleteCard extends StatefulWidget {
  final ObjectModel object;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _SwipeToDeleteCard({
    super.key,
    required this.object,
    required this.onTap,
    required this.onDelete,
  });

  @override
  State<_SwipeToDeleteCard> createState() => _SwipeToDeleteCardState();
}

class _SwipeToDeleteCardState extends State<_SwipeToDeleteCard> {
  static const double _deleteButtonWidth = 80.0;
  static const double _cardHeight = 80.0;

  double _dragOffset = 0.0;
  bool _isOpen = false;

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta.dx;
      _dragOffset = _dragOffset.clamp(-_deleteButtonWidth, 0.0);
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    if (_dragOffset < -_deleteButtonWidth / 2 || velocity < -300) {
      setState(() {
        _dragOffset = -_deleteButtonWidth;
        _isOpen = true;
      });
    } else {
      _close();
    }
  }

  void _close() {
    setState(() {
      _dragOffset = 0.0;
      _isOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      onTap: _isOpen ? _close : null,
      child: SizedBox(
        height: _cardHeight,
        child: Stack(
          children: [
            // ── Red delete button (fixed behind) ──────────────
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: _deleteButtonWidth,
              child: GestureDetector(
                onTap: () {
                  _close();
                  widget.onDelete();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.delete_outline, color: Colors.white, size: 22),
                      SizedBox(height: 4),
                      Text(
                        'Delete',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Card slides on top ─────────────────────────────
            AnimatedContainer(
              duration: _dragOffset == 0.0 || _dragOffset == -_deleteButtonWidth
                  ? const Duration(milliseconds: 200)
                  : Duration.zero,
              curve: Curves.easeOut,
              transform: Matrix4.translationValues(_dragOffset, 0, 0),
              child: _ObjectCard(
                object: widget.object,
                onTap: _isOpen ? _close : widget.onTap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Card UI ──────────────────────────────────────────────────────────────────

class _ObjectCard extends StatelessWidget {
  final ObjectModel object;
  final VoidCallback onTap;

  const _ObjectCard({required this.object, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      child: ListTile(
        onTap: onTap,
        // minVerticalPadding: 18,
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Text(
            object.id,
            style: TextStyle(
              fontSize: 11,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          object.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

// ── Error view ───────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
