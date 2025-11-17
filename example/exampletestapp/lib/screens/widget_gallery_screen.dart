import 'package:flutter/material.dart';
import 'package:reuablewidgets/sharedwidget/reusable_app_bar.dart';
import 'package:reuablewidgets/sharedwidget/reusable_badge.dart';
import 'package:reuablewidgets/sharedwidget/reusable_circle_avatar.dart';
import 'package:reuablewidgets/sharedwidget/reusable_container.dart';
import 'package:reuablewidgets/sharedwidget/reusable_divider.dart';
import 'package:reuablewidgets/sharedwidget/reusable_icon_button.dart';
import 'package:reuablewidgets/sharedwidget/reusable_image.dart';
import 'package:reuablewidgets/sharedwidget/reusable_shimmer.dart';
import 'package:reuablewidgets/sharedwidget/reusable_error_view.dart';
import 'package:reuablewidgets/sharedwidget/reusable_refresh_indicator.dart';
import 'package:reuablewidgets/sharedwidget/reusable_animated_switcher.dart';
import 'package:reuablewidgets/sharedwidget/reusable_toast.dart';
import 'package:reuablewidgets/sharedwidget/reusabel_snackbar.dart';

class WidgetGalleryScreen extends StatefulWidget {
  const WidgetGalleryScreen({super.key});

  @override
  State<WidgetGalleryScreen> createState() => _WidgetGalleryScreenState();
}

class _WidgetGalleryScreenState extends State<WidgetGalleryScreen> {
  bool _isLoading = false;
  bool _showContent = true;
  String _selectedValue = 'Option 1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        title: 'Widget Gallery',
        showBackButton: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() => _isLoading = true);
          await Future.delayed(const Duration(seconds: 2));
          setState(() => _isLoading = false);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Refreshed!')),
            );
          }
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionTitle('Basic Widgets'),
            _buildWidgetShowcase(
              title: 'Reusable Container',
              child: ReusableContainer(
                padding: const EdgeInsets.all(16),
                borderRadius: 12,
                backgroundColor: Colors.blue.withOpacity(0.1),
                borderColor: Colors.blue,
                borderWidth: 2,
                child: const Text(
                  'This is a reusable container with custom styling',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            _buildWidgetShowcase(
              title: 'Reusable Badge',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  ReusableBadge(
                    label: 'New',
                    backgroundColor: Colors.red,
                  ),
                  ReusableBadge(
                    label: 'Featured',
                    backgroundColor: Colors.orange,
                  ),
                  ReusableBadge(
                    label: 'Sale',
                    backgroundColor: Colors.green,
                  ),
                ],
              ),
            ),
            _buildWidgetShowcase(
              title: 'Reusable Circle Avatar',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ReusableCircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.purple,
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                  ReusableCircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.blue,
                    imageUrl: 'https://via.placeholder.com/150',
                  ),
                  ReusableCircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.green,
                    text: 'AB',
                  ),
                ],
              ),
            ),
            _buildWidgetShowcase(
              title: 'Reusable Icon Buttons',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ReusableIconButton(
                    icon: Icons.favorite,
                    onPressed: () => _showToast(context, 'Liked!'),
                    color: Colors.red,
                  ),
                  ReusableIconButton(
                    icon: Icons.share,
                    onPressed: () => _showToast(context, 'Shared!'),
                    color: Colors.blue,
                  ),
                  ReusableIconButton(
                    icon: Icons.bookmark,
                    onPressed: () => _showToast(context, 'Bookmarked!'),
                    color: Colors.orange,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('Dividers'),
            _buildWidgetShowcase(
              title: 'Reusable Dividers',
              child: Column(
                children: [
                  const Text('Horizontal Divider'),
                  ReusableDivider(thickness: 2, color: Colors.grey[300]!),
                  const SizedBox(height: 8),
                  const Text('Vertical Divider (in Row)'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Left'),
                      ReusableDivider(
                        isVertical: true,
                        thickness: 2,
                        color: Colors.blue,
                        height: 40,
                      ),
                      const Text('Right'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('Loading & States'),
            _buildWidgetShowcase(
              title: 'Reusable Shimmer',
              child: ReusableShimmer(
                isLoading: _isLoading,
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _isLoading
                      ? null
                      : const Center(
                          child: Text(
                            'Content loaded!',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                ),
              ),
            ),
            _buildWidgetShowcase(
              title: 'Toggle Shimmer',
              child: ElevatedButton(
                onPressed: () {
                  setState(() => _isLoading = !_isLoading);
                },
                child: Text(_isLoading ? 'Stop Loading' : 'Start Loading'),
              ),
            ),
            _buildWidgetShowcase(
              title: 'Reusable Error View',
              child: ReusableErrorView(
                message: 'Something went wrong',
                onRetry: () {
                  _showToast(context, 'Retrying...');
                },
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('Animations'),
            _buildWidgetShowcase(
              title: 'Reusable Animated Switcher',
              child: Column(
                children: [
                  ReusableAnimatedSwitcher(
                    child: _showContent
                        ? Container(
                            key: const ValueKey('content1'),
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Content 1',
                              style: TextStyle(fontSize: 18),
                            ),
                          )
                        : Container(
                            key: const ValueKey('content2'),
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Content 2',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      setState(() => _showContent = !_showContent);
                    },
                    child: const Text('Toggle Content'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('Feedback Widgets'),
            _buildWidgetShowcase(
              title: 'Toast & Snackbar',
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _showToast(context, 'This is a toast!'),
                    icon: const Icon(Icons.notifications),
                    label: const Text('Show Toast'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () => _showSnackbar(context, 'This is a snackbar!'),
                    icon: const Icon(Icons.info),
                    label: const Text('Show Snackbar'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildWidgetShowcase({
    required String title,
    required Widget child,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
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
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  void _showToast(BuildContext context, String message) {
    ReusableToast.show(
      context: context,
      message: message,
      backgroundColor: Colors.black87,
    );
  }

  void _showSnackbar(BuildContext context, String message) {
    ReusableSnackbar.show(
      context: context,
      message: message,
    );
  }
}
