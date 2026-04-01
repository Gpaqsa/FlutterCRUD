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
                return _ObjectCard(
                  object: object,
                  onTap: () => _navigateToDetail(context, object),
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

class _ObjectCard extends StatelessWidget {
  final ObjectModel object;
  final VoidCallback onTap;

  const _ObjectCard({required this.object, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        onTap: onTap,
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
