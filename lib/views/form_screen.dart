import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/models/object_model.dart';
import '../viewmodels/objects_viewmodel.dart';

class FormScreen extends StatefulWidget {
  final ObjectModel? object; // null = create, non-null = edit

  const FormScreen({super.key, this.object});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;

  // Dynamic key-value fields for `data`
  final List<MapEntry<TextEditingController, TextEditingController>>
  _dataFields = [];

  bool get _isEditing => widget.object != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.object?.name ?? '');
    widget.object?.data?.forEach((key, value) {
      _addDataField(key: key, value: value.toString());
    });
  }

  void _addDataField({String key = '', String value = ''}) {
    setState(() {
      _dataFields.add(
        MapEntry(
          TextEditingController(text: key),
          TextEditingController(text: value),
        ),
      );
    });
  }

  void _removeDataField(int index) {
    setState(() {
      _dataFields[index].key.dispose();
      _dataFields[index].value.dispose();
      _dataFields.removeAt(index);
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final Map<String, dynamic>? data = _dataFields.isNotEmpty
        ? {
            for (final entry in _dataFields)
              if (entry.key.text.trim().isNotEmpty)
                entry.key.text.trim(): entry.value.text.trim(),
          }
        : null;

    final object = ObjectModel(
      id: widget.object?.id ?? '',
      name: _nameController.text.trim(),
      data: data,
    );

    final vm = context.read<ObjectsViewModel>();
    final success = _isEditing
        ? await vm.updateObject(object)
        : await vm.createObject(object);

    if (mounted) {
      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditing ? 'Object updated!' : 'Object created!'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Operation failed. Try again.')),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    for (final e in _dataFields) {
      e.key.dispose();
      e.value.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ObjectsViewModel>();

    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit Object' : 'Create Object')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name *',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Name is required' : null,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Data Fields',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: _addDataField,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Field'),
                ),
              ],
            ),
            ..._dataFields.asMap().entries.map((entry) {
              final index = entry.key;
              final field = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: field.key,
                        decoration: const InputDecoration(
                          labelText: 'Key',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: field.value,
                        decoration: const InputDecoration(
                          labelText: 'Value',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () => _removeDataField(index),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: vm.isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: vm.isLoading
                  ? const CircularProgressIndicator()
                  : Text(
                      _isEditing ? 'Update Object' : 'Create Object',
                      style: const TextStyle(fontSize: 16),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
