import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:reuablewidgets/sharedwidget/reusable_app_bar.dart';
import 'package:reuablewidgets/sharedwidget/reusable_container.dart';
import 'package:reuablewidgets/sharedwidget/reusable_text_form_field.dart';
import 'package:reuablewidgets/sharedwidget/reusable_toast.dart';

class OfflineConnectivityScreen extends StatefulWidget {
  const OfflineConnectivityScreen({super.key});

  @override
  State<OfflineConnectivityScreen> createState() =>
      _OfflineConnectivityScreenState();
}

class _OfflineConnectivityScreenState extends State<OfflineConnectivityScreen> {
  static const String _boxName = 'testBox';
  final _keyController = TextEditingController();
  final _valueController = TextEditingController();
  Box? _box;
  Map<String, dynamic> _cachedData = {};

  @override
  void initState() {
    super.initState();
    _initHive();
  }

  Future<void> _initHive() async {
    try {
      // Open or create the box
      _box = await Hive.openBox(_boxName);
      _loadCachedData();
    } catch (e) {
      if (mounted) {
        ReusableToast.show(
          context: context,
          message: 'Error initializing Hive: $e',
          backgroundColor: Colors.red,
        );
      }
    }
  }

  void _loadCachedData() {
    if (_box != null) {
      setState(() {
        _cachedData = Map<String, dynamic>.from(_box!.toMap());
      });
    }
  }

  @override
  void dispose() {
    _keyController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        title: 'Offline & Caching',
        showBackButton: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Test Hive Local Storage',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Data persists even after app restart',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ReusableContainer(
            padding: const EdgeInsets.all(16),
            borderRadius: 12,
            backgroundColor: Colors.blue.withOpacity(0.1),
            borderColor: Colors.blue,
            borderWidth: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue),
                    const SizedBox(width: 8),
                    const Text(
                      'Hive Status',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  'Box Name',
                  _boxName,
                ),
                _buildInfoRow(
                  'Status',
                  _box != null ? 'Initialized' : 'Not Initialized',
                ),
                _buildInfoRow(
                  'Items Count',
                  _cachedData.length.toString(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Add Data to Cache',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ReusableTextFormField(
            controller: _keyController,
            labelText: 'Key',
            hintText: 'Enter a key',
            prefixIcon: Icons.key,
          ),
          const SizedBox(height: 12),
          ReusableTextFormField(
            controller: _valueController,
            labelText: 'Value',
            hintText: 'Enter a value',
            prefixIcon: Icons.text_fields,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _saveData,
                  icon: const Icon(Icons.save),
                  label: const Text('Save to Cache'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _clearAll,
                  icon: const Icon(Icons.delete),
                  label: const Text('Clear All'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Cached Data',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (_cachedData.isEmpty)
            ReusableContainer(
              padding: const EdgeInsets.all(32),
              borderRadius: 12,
              backgroundColor: Colors.grey.withOpacity(0.1),
              child: Column(
                children: [
                  Icon(
                    Icons.inbox,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No cached data',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
          else
            ..._cachedData.entries.map((entry) {
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: const Icon(
                      Icons.data_object,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    entry.key,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(entry.value.toString()),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteData(entry.key),
                  ),
                ),
              );
            }).toList(),
          const SizedBox(height: 24),
          const Text(
            'Quick Actions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            icon: Icons.add,
            label: 'Add Sample Data',
            color: Colors.blue,
            onPressed: _addSampleData,
          ),
          _buildActionButton(
            icon: Icons.refresh,
            label: 'Reload Data',
            color: Colors.green,
            onPressed: _loadCachedData,
          ),
          _buildActionButton(
            icon: Icons.info,
            label: 'Show Box Info',
            color: Colors.orange,
            onPressed: _showBoxInfo,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.grey[700],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 16),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveData() async {
    if (_box == null) {
      ReusableToast.show(
        context: context,
        message: 'Hive box not initialized',
        backgroundColor: Colors.red,
      );
      return;
    }

    final key = _keyController.text.trim();
    final value = _valueController.text.trim();

    if (key.isEmpty || value.isEmpty) {
      ReusableToast.show(
        context: context,
        message: 'Please enter both key and value',
        backgroundColor: Colors.orange,
      );
      return;
    }

    try {
      await _box!.put(key, value);
      _keyController.clear();
      _valueController.clear();
      _loadCachedData();

      if (mounted) {
        ReusableToast.show(
          context: context,
          message: 'Data saved successfully',
          backgroundColor: Colors.green,
        );
      }
    } catch (e) {
      if (mounted) {
        ReusableToast.show(
          context: context,
          message: 'Error saving data: $e',
          backgroundColor: Colors.red,
        );
      }
    }
  }

  Future<void> _deleteData(String key) async {
    if (_box == null) return;

    try {
      await _box!.delete(key);
      _loadCachedData();

      if (mounted) {
        ReusableToast.show(
          context: context,
          message: 'Deleted: $key',
          backgroundColor: Colors.orange,
        );
      }
    } catch (e) {
      if (mounted) {
        ReusableToast.show(
          context: context,
          message: 'Error deleting data: $e',
          backgroundColor: Colors.red,
        );
      }
    }
  }

  Future<void> _clearAll() async {
    if (_box == null || _cachedData.isEmpty) return;

    try {
      await _box!.clear();
      _loadCachedData();

      if (mounted) {
        ReusableToast.show(
          context: context,
          message: 'All data cleared',
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      if (mounted) {
        ReusableToast.show(
          context: context,
          message: 'Error clearing data: $e',
          backgroundColor: Colors.red,
        );
      }
    }
  }

  Future<void> _addSampleData() async {
    if (_box == null) return;

    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      await _box!.put('user_name', 'John Doe');
      await _box!.put('user_email', 'john@example.com');
      await _box!.put('timestamp', timestamp.toString());
      await _box!.put('app_version', '1.0.0');

      _loadCachedData();

      if (mounted) {
        ReusableToast.show(
          context: context,
          message: 'Sample data added',
          backgroundColor: Colors.green,
        );
      }
    } catch (e) {
      if (mounted) {
        ReusableToast.show(
          context: context,
          message: 'Error adding sample data: $e',
          backgroundColor: Colors.red,
        );
      }
    }
  }

  void _showBoxInfo() {
    if (_box == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Box Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: $_boxName'),
            Text('Path: ${_box!.path}'),
            Text('Items: ${_box!.length}'),
            Text('Is Open: ${_box!.isOpen}'),
            Text('Is Empty: ${_box!.isEmpty}'),
            const SizedBox(height: 16),
            const Text(
              'Keys:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...(_box!.keys.take(10).map((key) => Text('  • $key'))),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
