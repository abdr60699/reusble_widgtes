import 'package:flutter/material.dart';
import 'sharedwidget/shared_widgets.dart';

void main() {
  runApp(const ReusableWidgetsApp());
}

class ReusableWidgetsApp extends StatelessWidget {
  const ReusableWidgetsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reusable Widgets Library',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const WidgetCatalogScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WidgetCatalogScreen extends StatelessWidget {
  const WidgetCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reusable Widgets Catalog'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCategoryCard(
            context,
            title: 'Animations',
            description: 'Transitions, effects, and animated widgets',
            icon: Icons.animation,
            color: Colors.purple,
          ),
          _buildCategoryCard(
            context,
            title: 'Auth',
            description: 'Authentication and permission widgets',
            icon: Icons.security,
            color: Colors.red,
          ),
          _buildCategoryCard(
            context,
            title: 'Basic',
            description: 'Containers, badges, avatars, dividers',
            icon: Icons.widgets,
            color: Colors.blue,
          ),
          _buildCategoryCard(
            context,
            title: 'Buttons',
            description: 'Icon buttons and button variants',
            icon: Icons.touch_app,
            color: Colors.green,
          ),
          _buildCategoryCard(
            context,
            title: 'Cards',
            description: 'Various card layouts for data display',
            icon: Icons.credit_card,
            color: Colors.orange,
          ),
          _buildCategoryCard(
            context,
            title: 'Dialogs',
            description: 'Modal dialogs, popups, and overlays',
            icon: Icons.open_in_new,
            color: Colors.indigo,
          ),
          _buildCategoryCard(
            context,
            title: 'Ecommerce',
            description: 'Shopping cart, products, pricing',
            icon: Icons.shopping_cart,
            color: Colors.teal,
          ),
          _buildCategoryCard(
            context,
            title: 'Effects',
            description: 'Glassmorphism, gradients, visual effects',
            icon: Icons.blur_on,
            color: Colors.pink,
          ),
          _buildCategoryCard(
            context,
            title: 'Feedback',
            description: 'Toasts, progress indicators, states',
            icon: Icons.feedback,
            color: Colors.amber,
          ),
          _buildCategoryCard(
            context,
            title: 'Forms',
            description: 'Text fields, dropdowns, inputs',
            icon: Icons.edit_note,
            color: Colors.cyan,
          ),
          _buildCategoryCard(
            context,
            title: 'Layout',
            description: 'Grids, steppers, layout helpers',
            icon: Icons.view_quilt,
            color: Colors.deepPurple,
          ),
          _buildCategoryCard(
            context,
            title: 'Media',
            description: 'Image, video, audio, PDF, QR',
            icon: Icons.perm_media,
            color: Colors.deepOrange,
          ),
          _buildCategoryCard(
            context,
            title: 'Navigation',
            description: 'App bars, bottom nav, drawers',
            icon: Icons.navigation,
            color: Colors.lightBlue,
          ),
          _buildCategoryCard(
            context,
            title: 'Pickers',
            description: 'Date, time, color, image pickers',
            icon: Icons.calendar_today,
            color: Colors.lime,
          ),
          _buildCategoryCard(
            context,
            title: 'Responsive',
            description: 'Adaptive and responsive widgets',
            icon: Icons.devices,
            color: Colors.brown,
          ),
          _buildCategoryCard(
            context,
            title: 'Utilities',
            description: 'Version checkers and utilities',
            icon: Icons.build,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$title widgets - Coming soon!'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
      ),
    );
  }
}
