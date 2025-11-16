import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:reuablewidgets/sharedwidget/reusable_app_bar.dart';
import 'package:reuablewidgets/sharedwidget/reusable_shimmer.dart';
import 'package:reuablewidgets/sharedwidget/reusable_error_view.dart';
import 'package:reuablewidgets/sharedwidget/reusable_container.dart';

class ApiClientScreen extends StatefulWidget {
  const ApiClientScreen({super.key});

  @override
  State<ApiClientScreen> createState() => _ApiClientScreenState();
}

class _ApiClientScreenState extends State<ApiClientScreen> {
  bool _isLoading = false;
  String? _errorMessage;
  List<dynamic> _users = [];
  Map<String, dynamic>? _singleUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        title: 'API Client Demo',
        showBackButton: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Test HTTP API Requests',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          _buildActionCard(
            title: 'GET Request',
            description: 'Fetch list of users from JSONPlaceholder API',
            icon: Icons.download,
            color: Colors.blue,
            onPressed: _fetchUsers,
          ),
          _buildActionCard(
            title: 'GET Single Item',
            description: 'Fetch a single user by ID',
            icon: Icons.person,
            color: Colors.green,
            onPressed: _fetchSingleUser,
          ),
          _buildActionCard(
            title: 'POST Request',
            description: 'Create a new resource',
            icon: Icons.upload,
            color: Colors.orange,
            onPressed: _createPost,
          ),
          _buildActionCard(
            title: 'Simulate Error',
            description: 'Test error handling with invalid endpoint',
            icon: Icons.error,
            color: Colors.red,
            onPressed: _simulateError,
          ),
          const SizedBox(height: 24),
          if (_isLoading)
            ReusableShimmer(
              isLoading: true,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          if (_errorMessage != null && !_isLoading)
            ReusableErrorView(
              message: _errorMessage!,
              onRetry: () {
                setState(() => _errorMessage = null);
              },
            ),
          if (_users.isNotEmpty && !_isLoading && _errorMessage == null)
            _buildUsersList(),
          if (_singleUser != null && !_isLoading && _errorMessage == null)
            _buildSingleUserCard(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: _isLoading ? null : onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUsersList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Users List',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ..._users.take(5).map((user) {
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Text(
                  user['id'].toString(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(user['name'] ?? 'Unknown'),
              subtitle: Text(user['email'] ?? 'No email'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildSingleUserCard() {
    return ReusableContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: 12,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'User Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 12),
          _buildDetailRow('ID', _singleUser!['id'].toString()),
          _buildDetailRow('Name', _singleUser!['name']),
          _buildDetailRow('Email', _singleUser!['email']),
          _buildDetailRow('Phone', _singleUser!['phone']),
          _buildDetailRow('Website', _singleUser!['website']),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchUsers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _users = [];
      _singleUser = null;
    });

    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/users'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _users = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchSingleUser() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _users = [];
      _singleUser = null;
    });

    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/users/1'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _singleUser = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load user');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _createPost() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _users = [];
      _singleUser = null;
    });

    try {
      final response = await http.post(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'title': 'Test Post',
          'body': 'This is a test post from the API client demo',
          'userId': 1,
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        setState(() => _isLoading = false);

        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Post Created'),
              content: Text('ID: ${data['id']}\nTitle: ${data['title']}'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      } else {
        throw Exception('Failed to create post');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _simulateError() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _users = [];
      _singleUser = null;
    });

    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/invalid-endpoint'),
      );

      if (response.statusCode == 200) {
        setState(() => _isLoading = false);
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }
}
