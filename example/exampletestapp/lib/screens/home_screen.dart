import 'package:flutter/material.dart';
import 'widget_gallery_screen.dart';
import 'form_widgets_screen.dart';
import 'theme_demo_screen.dart';
import 'api_client_screen.dart';
import 'offline_connectivity_screen.dart';
import 'navigation_demo_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reusable Widgets Test App'),
        centerTitle: true,
        elevation: 2,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'Test all your reusable widgets and features',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          _buildCategoryHeader('UI Widgets'),
          _buildDemoCard(
            context,
            title: 'Widget Gallery',
            subtitle: 'Test all 25+ reusable UI widgets',
            icon: Icons.widgets,
            color: Colors.blue,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const WidgetGalleryScreen(),
              ),
            ),
          ),
          _buildDemoCard(
            context,
            title: 'Form Widgets',
            subtitle: 'TextFields, Dropdowns, DatePickers, Radio Groups',
            icon: Icons.edit_note,
            color: Colors.green,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FormWidgetsScreen(),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildCategoryHeader('Features'),
          _buildDemoCard(
            context,
            title: 'Theme System',
            subtitle: 'Material 3 theming, dark/light mode',
            icon: Icons.palette,
            color: Colors.purple,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ThemeDemoScreen(),
              ),
            ),
          ),
          _buildDemoCard(
            context,
            title: 'Navigation',
            subtitle: 'Test navigation patterns and routing',
            icon: Icons.navigation,
            color: Colors.orange,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NavigationDemoScreen(),
              ),
            ),
          ),
          _buildDemoCard(
            context,
            title: 'API Client',
            subtitle: 'HTTP requests, retry logic, interceptors',
            icon: Icons.cloud,
            color: Colors.teal,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ApiClientScreen(),
              ),
            ),
          ),
          _buildDemoCard(
            context,
            title: 'Offline & Connectivity',
            subtitle: 'Hive caching, offline support, connectivity status',
            icon: Icons.wifi_off,
            color: Colors.red,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const OfflineConnectivityScreen(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDemoCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
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
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
