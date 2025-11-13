import 'package:flutter/material.dart';
import 'package:connectivity_offline/connectivity_offline.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize offline support with custom configuration
  await OfflineSupport.initialize(
    config: OfflineConfig.development(),
  );

  runApp(const ConnectivityExampleApp());
}

class ConnectivityExampleApp extends StatelessWidget {
  const ConnectivityExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Connectivity & Offline Support',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ConnectivityState? _connectivityState;
  List<String> _logs = [];

  @override
  void initState() {
    super.initState();
    _initConnectivity();
  }

  Future<void> _initConnectivity() async {
    // Get initial connectivity state
    _connectivityState = await OfflineSupport.instance.checkConnectivity();
    setState(() {});

    // Listen to connectivity changes
    OfflineSupport.instance.connectivityStream.listen((state) {
      setState(() {
        _connectivityState = state;
        _addLog('Connectivity changed: ${state.status.name} (${state.connectionType.name})');
      });
    });
  }

  void _addLog(String message) {
    setState(() {
      _logs.insert(0, '${DateTime.now().toIso8601String()}: $message');
      if (_logs.length > 20) _logs.removeLast();
    });
  }

  Future<void> _testCache() async {
    try {
      // Store data
      await OfflineSupport.instance.cache.put(
        'test_key',
        {'message': 'Hello from cache!', 'timestamp': DateTime.now().toIso8601String()},
      );
      _addLog('✅ Data stored in cache');

      // Retrieve data
      final data = await OfflineSupport.instance.cache.get('test_key');
      _addLog('✅ Retrieved from cache: ${data?['message']}');
    } catch (e) {
      _addLog('❌ Cache error: $e');
    }
  }

  Future<void> _testQueue() async {
    try {
      final request = OfflineRequest(
        id: 'test_${DateTime.now().millisecondsSinceEpoch}',
        endpoint: '/api/test',
        method: 'POST',
        body: {'data': 'Test request'},
      );

      await OfflineSupport.instance.queue.add(request);
      _addLog('✅ Request queued: ${request.id}');

      final pending = await OfflineSupport.instance.queue.getPendingRequests();
      _addLog('📋 Pending requests: ${pending.length}');
    } catch (e) {
      _addLog('❌ Queue error: $e');
    }
  }

  Future<void> _syncNow() async {
    try {
      _addLog('🔄 Starting sync...');
      await OfflineSupport.instance.syncManager.syncNow();
      _addLog('✅ Sync completed');
    } catch (e) {
      _addLog('❌ Sync error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connectivity & Offline Support'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Module Info'),
                  content: const Text(
                    'This example demonstrates:\n\n'
                    '• Real-time connectivity monitoring\n'
                    '• Disk caching with Hive\n'
                    '• Offline request queue\n'
                    '• Automatic sync when online\n'
                    '• Platform-agnostic design',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Connectivity Status Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: _getStatusColor(),
            child: Column(
              children: [
                Icon(
                  _getStatusIcon(),
                  size: 48,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                Text(
                  _connectivityState?.status.name.toUpperCase() ?? 'CHECKING...',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  _connectivityState?.connectionType.name ?? '-',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          // Action Buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _testCache,
                  icon: const Icon(Icons.storage),
                  label: const Text('Test Cache'),
                ),
                ElevatedButton.icon(
                  onPressed: _testQueue,
                  icon: const Icon(Icons.queue),
                  label: const Text('Queue Request'),
                ),
                ElevatedButton.icon(
                  onPressed: _syncNow,
                  icon: const Icon(Icons.sync),
                  label: const Text('Sync Now'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _logs.clear();
                    });
                  },
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear Logs'),
                ),
              ],
            ),
          ),

          // Logs
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: _logs.isEmpty
                  ? const Center(
                      child: Text(
                        'No logs yet. Try the buttons above!',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: _logs.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            _logs[index],
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 12,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    if (_connectivityState == null) return Colors.grey;
    switch (_connectivityState!.status) {
      case ConnectivityStatus.online:
        return Colors.green;
      case ConnectivityStatus.offline:
        return Colors.red;
      case ConnectivityStatus.limited:
        return Colors.orange;
    }
  }

  IconData _getStatusIcon() {
    if (_connectivityState == null) return Icons.help_outline;
    switch (_connectivityState!.status) {
      case ConnectivityStatus.online:
        return Icons.cloud_done;
      case ConnectivityStatus.offline:
        return Icons.cloud_off;
      case ConnectivityStatus.limited:
        return Icons.cloud_queue;
    }
  }
}
