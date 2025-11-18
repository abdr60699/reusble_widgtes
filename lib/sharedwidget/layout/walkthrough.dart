import 'package:flutter/material.dart';

/// A reusable walkthrough/tutorial widget.
///
/// Creates an overlay that highlights specific widgets and shows
/// tutorial messages for user onboarding.
///
/// Example:
/// ```dart
/// Walkthrough(
///   steps: [
///     WalkthroughStep(
///       title: 'Welcome',
///       description: 'This is the home button',
///       targetKey: homeButtonKey,
///     ),
///   ],
///   onComplete: () => print('Tutorial complete'),
/// )
/// ```
class Walkthrough extends StatefulWidget {
  /// List of walkthrough steps
  final List<WalkthroughStep> steps;

  /// Callback when walkthrough is completed
  final VoidCallback? onComplete;

  /// Whether to show skip button
  final bool showSkipButton;

  const Walkthrough({
    super.key,
    required this.steps,
    this.onComplete,
    this.showSkipButton = true,
  });

  @override
  State<Walkthrough> createState() => _WalkthroughState();
}

class _WalkthroughState extends State<Walkthrough> {
  int _currentStep = 0;

  void _nextStep() {
    if (_currentStep < widget.steps.length - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      _complete();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  void _complete() {
    widget.onComplete?.call();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final step = widget.steps[_currentStep];
    final theme = Theme.of(context);

    return Stack(
      children: [
        // Semi-transparent overlay
        GestureDetector(
          onTap: () {}, // Prevent clicks through
          child: Container(
            color: Colors.black54,
          ),
        ),
        // Highlight target widget if key is provided
        if (step.targetKey != null) _buildHighlight(step.targetKey!),
        // Tutorial card
        Center(
          child: Card(
            margin: const EdgeInsets.all(32),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (step.icon != null) ...[
                    Icon(step.icon, size: 48, color: theme.colorScheme.primary),
                    const SizedBox(height: 16),
                  ],
                  Text(
                    step.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    step.description,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentStep > 0)
                        TextButton(
                          onPressed: _previousStep,
                          child: const Text('Previous'),
                        )
                      else
                        const SizedBox.shrink(),
                      Text(
                        '${_currentStep + 1} / ${widget.steps.length}',
                        style: theme.textTheme.bodySmall,
                      ),
                      Row(
                        children: [
                          if (widget.showSkipButton && _currentStep < widget.steps.length - 1)
                            TextButton(
                              onPressed: _complete,
                              child: const Text('Skip'),
                            ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _nextStep,
                            child: Text(
                              _currentStep < widget.steps.length - 1 ? 'Next' : 'Done',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHighlight(GlobalKey key) {
    final RenderBox? renderBox =
        key.currentContext?.findRenderObject() as RenderBox?;

    if (renderBox == null) return const SizedBox.shrink();

    final size = renderBox.size;
    final position = renderBox.localToGlobal(Offset.zero);

    return Positioned(
      left: position.dx - 8,
      top: position.dy - 8,
      width: size.width + 16,
      height: size.height + 16,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

/// Represents a single step in the walkthrough
class WalkthroughStep {
  final String title;
  final String description;
  final IconData? icon;
  final GlobalKey? targetKey;

  const WalkthroughStep({
    required this.title,
    required this.description,
    this.icon,
    this.targetKey,
  });
}
