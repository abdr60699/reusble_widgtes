import 'package:flutter/material.dart';
import 'package:fcm_notifications/fcm_notifications.dart';

// Background message handler must be top-level function
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initialize FCM
  await FCMService.initialize(
    FCMConfig.development.copyWith(
      backgroundMessageHandler: _firebaseMessagingBackgroundHandler,
    ),
  );

  runApp(const FCMExampleApp());
}

class FCMExampleApp extends StatelessWidget {
  const FCMExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FCM Notifications Example',
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
  String? _fcmToken;
  final List<PushNotification> _notifications = [];
  bool _permissionGranted = false;

  @override
  void initState() {
    super.initState();
    _setupFCM();
  }

  Future<void> _setupFCM() async {
    // Listen to notifications
    FCMService.instance.notificationStream.listen((notification) {
      setState(() {
        _notifications.insert(0, notification);
      });

      // Show snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${notification.title}: ${notification.body}'),
            action: SnackBarAction(
              label: 'View',
              onPressed: () {
                _showNotificationDetails(notification);
              },
            ),
          ),
        );
      }
    });

    // Listen to token changes
    FCMService.instance.tokenStream.listen((token) {
      setState(() {
        _fcmToken = token;
      });
    });

    // Get initial token
    _fcmToken = FCMService.instance.currentToken;

    setState(() {});
  }

  Future<void> _requestPermission() async {
    final settings = await FCMService.instance.requestPermission();

    setState(() {
      _permissionGranted =
          settings.authorizationStatus == AuthorizationStatus.authorized ||
              settings.authorizationStatus ==
                  AuthorizationStatus.provisional;
    });

    if (_permissionGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission granted!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission denied')),
      );
    }
  }

  Future<void> _refreshToken() async {
    final token = await FCMService.instance.getToken();
    setState(() {
      _fcmToken = token;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Token refreshed')),
    );
  }

  Future<void> _subscribeToTopic(String topic) async {
    await FCMService.instance.subscribeToTopic(topic);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Subscribed to $topic')),
      );
    }
  }

  Future<void> _unsubscribeFromTopic(String topic) async {
    await FCMService.instance.unsubscribeFromTopic(topic);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unsubscribed from $topic')),
      );
    }
  }

  void _showNotificationDetails(PushNotification notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(notification.title ?? 'Notification'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (notification.body != null) ...[
                const Text(
                  'Body:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(notification.body!),
                const SizedBox(height: 12),
              ],
              if (notification.data != null) ...[
                const Text(
                  'Data:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(notification.data.toString()),
                const SizedBox(height: 12),
              ],
              const Text(
                'Received:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(notification.receivedAt.toString()),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FCM Example'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // FCM Token Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'FCM Token',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: _refreshToken,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (_fcmToken != null)
                    SelectableText(
                      _fcmToken!,
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'monospace',
                      ),
                    )
                  else
                    const Text('No token available'),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: _requestPermission,
                    icon: const Icon(Icons.notifications),
                    label: const Text('Request Permission'),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Topics Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Topics',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [
                      ElevatedButton(
                        onPressed: () => _subscribeToTopic('news'),
                        child: const Text('Subscribe to News'),
                      ),
                      OutlinedButton(
                        onPressed: () => _unsubscribeFromTopic('news'),
                        child: const Text('Unsubscribe News'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      ElevatedButton(
                        onPressed: () => _subscribeToTopic('sports'),
                        child: const Text('Subscribe to Sports'),
                      ),
                      OutlinedButton(
                        onPressed: () => _unsubscribeFromTopic('sports'),
                        child: const Text('Unsubscribe Sports'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Notifications Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Received Notifications',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('${_notifications.length}'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_notifications.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: Text(
                          'No notifications yet.\nSend a test notification from Firebase Console.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _notifications.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final notification = _notifications[index];
                        return ListTile(
                          leading: const Icon(Icons.notifications),
                          title: Text(notification.title ?? 'No title'),
                          subtitle: Text(notification.body ?? 'No body'),
                          trailing: Text(
                            _formatTime(notification.receivedAt),
                            style: const TextStyle(fontSize: 12),
                          ),
                          onTap: () => _showNotificationDetails(notification),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inSeconds < 60) {
      return '${diff.inSeconds}s ago';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }
}
