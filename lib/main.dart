import 'package:flutter/material.dart';


import 'sharedwidget/reusable_app_bar.dart';
import 'sharedwidget/reusable_dropdown.dart';
import 'sharedwidget/reusable_text_form_field.dart';
import 'sharedwidget/reusable_circle_avatar.dart';
import 'sharedwidget/reusable_datepicker.dart';
import 'sharedwidget/reusable_radiogroup.dart';
import 'sharedwidget/reusabel_snackbar.dart';
import 'sharedwidget/reusable_refresh_indicator.dart';
import 'sharedwidget/reusable_animated_switcher.dart';
import 'sharedwidget/reusable_container.dart';
import 'sharedwidget/reusable_badge.dart';
import 'sharedwidget/reusable_image.dart';
import 'sharedwidget/reusable_icon_button.dart';
import 'sharedwidget/reusable_drawer.dart';
import 'sharedwidget/reusable_error_view.dart';
import 'sharedwidget/reusable_divider.dart';
import 'sharedwidget/reusable_stepper.dart';
import 'sharedwidget/reusable_shimmer.dart';
import 'sharedwidget/reusable_tab_bar.dart';
import 'sharedwidget/reusable_toast.dart';
import 'sharedwidget/reusable_bottom_nav_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reusable Widgets Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedCountry;
  DateTime? _selectedDate;
  String _selectedGender = 'Male';
  final _formKey = GlobalKey<FormState>();
  bool _isRefreshing = false;
  int _currentNavIndex = 0;
  bool _showContent = true;
  int _currentStep = 0;

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isRefreshing = false);
    if (mounted) {
      ReusabelSnackbar.success(context, 'Content refreshed successfully!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        titleText: 'Reusable Widgets Demo',
        centerTitle: true,
        elevation: 2,
        showElevation: true,
        actions: [
          ReusableBadge(
            count: 5,
            child: IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                ReusableToast.info(context, 'You have 5 notifications');
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      drawer: ReusableDrawer(
        headerTitle: 'Demo App',
        headerSubtitle: 'All Reusable Widgets',
        items: [
          DrawerItem(
            icon: Icons.home,
            title: 'Home',
            onTap: () {
              ReusableToast.success(context, 'Home selected');
            },
          ),
          DrawerItem(
            icon: Icons.widgets,
            title: 'Widgets',
            onTap: () {
              ReusableToast.info(context, 'Widgets selected');
            },
          ),
          DrawerItem(
            icon: Icons.settings,
            title: 'Settings',
            onTap: () {},
          ),
        ],
      ),
      body: ReusableRefreshIndicator(
        onRefresh: _handleRefresh,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionTitle('Reusable Animated Switcher'),
              const SizedBox(height: 12),
              ReusableAnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: _showContent
                    ? ReusableContainer(
                        key: const ValueKey('content1'),
                        padding: const EdgeInsets.all(16),
                        backgroundColor: Colors.blue.shade50,
                        child: const Column(
                          children: [
                            Icon(Icons.check_circle, size: 48, color: Colors.blue),
                            SizedBox(height: 8),
                            Text('Content A', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      )
                    : ReusableContainer(
                        key: const ValueKey('content2'),
                        padding: const EdgeInsets.all(16),
                        backgroundColor: Colors.green.shade50,
                        child: const Column(
                          children: [
                            Icon(Icons.star, size: 48, color: Colors.green),
                            SizedBox(height: 8),
                            Text('Content B', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  setState(() => _showContent = !_showContent);
                },
                child: const Text('Toggle Content'),
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('Reusable Container'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ReusableContainer(
                      padding: const EdgeInsets.all(16),
                      backgroundColor: Colors.purple.shade100,
                      borderRadius: BorderRadius.circular(12),
                      child: const Column(
                        children: [
                          Icon(Icons.star, color: Colors.purple),
                          SizedBox(height: 8),
                          Text('Container 1', style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ReusableContainer(
                      padding: const EdgeInsets.all(16),
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade300, Colors.purple.shade300],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        ReusableToast.success(context, 'Container tapped!');
                      },
                      child: const Column(
                        children: [
                          Icon(Icons.touch_app, color: Colors.white),
                          SizedBox(height: 8),
                          Text('Tap Me', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('Reusable Badge'),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ReusableBadge(
                    count: 3,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.mail, color: Colors.white),
                    ),
                  ),
                  ReusableBadge(
                    label: 'NEW',
                    badgeColor: Colors.green,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.shopping_cart, color: Colors.white),
                    ),
                  ),
                  ReusableBadge(
                    count: 99,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.notifications, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('Reusable Image'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ReusableImage.network(
                      'https://picsum.photos/200/200',
                      height: 120,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ReusableImage.network(
                      'https://picsum.photos/200/201',
                      height: 120,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('Reusable Icon Button'),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ReusableIconButton(
                    icon: Icons.favorite,
                    iconColor: Colors.red,
                    backgroundColor: Colors.red.shade50,
                    tooltip: 'Like',
                    onPressed: () {
                      ReusableToast.success(context, 'Liked!');
                    },
                  ),
                  ReusableIconButton(
                    icon: Icons.share,
                    iconColor: Colors.blue,
                    backgroundColor: Colors.blue.shade50,
                    tooltip: 'Share',
                    onPressed: () {
                      ReusableToast.info(context, 'Share clicked');
                    },
                  ),
                  ReusableIconButton(
                    icon: Icons.bookmark,
                    iconColor: Colors.green,
                    backgroundColor: Colors.green.shade50,
                    tooltip: 'Bookmark',
                    onPressed: () {
                      ReusableToast.success(context, 'Bookmarked!');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('Reusable Divider'),
              const SizedBox(height: 12),
              const ReusableDivider(thickness: 2, color: Colors.blue),
              const SizedBox(height: 12),
              const ReusableDivider(
                text: 'OR',
                thickness: 1,
                color: Colors.grey,
              ),
              const SizedBox(height: 12),
              const ReusableDivider(
                isDashed: true,
                thickness: 2,
                color: Colors.orange,
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('Reusable Shimmer'),
              const SizedBox(height: 12),
              ReusableShimmer(
                child: Column(
                  children: [
                    ReusableShimmer.placeholder(
                      width: double.infinity,
                      height: 100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        ReusableShimmer.placeholder(
                          width: 60,
                          height: 60,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ReusableShimmer.placeholder(
                                width: double.infinity,
                                height: 16,
                              ),
                              const SizedBox(height: 8),
                              ReusableShimmer.placeholder(
                                width: 150,
                                height: 12,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('Reusable Stepper'),
              const SizedBox(height: 12),
              ReusableStepper(
                currentStep: _currentStep,
                onStepContinue: () {
                  if (_currentStep < 2) {
                    setState(() => _currentStep++);
                  } else {
                    ReusableToast.success(context, 'Completed!');
                  }
                },
                onStepCancel: () {
                  if (_currentStep > 0) {
                    setState(() => _currentStep--);
                  }
                },
                onStepTapped: (index) {
                  setState(() => _currentStep = index);
                },
                steps: [
                  StepItem(
                    title: 'Step 1',
                    subtitle: 'Account Setup',
                    content: const Text('Enter your account details'),
                  ),
                  StepItem(
                    title: 'Step 2',
                    subtitle: 'Personal Info',
                    content: const Text('Enter your personal information'),
                  ),
                  StepItem(
                    title: 'Step 3',
                    subtitle: 'Confirmation',
                    content: const Text('Review and confirm'),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('Reusable Error View'),
              const SizedBox(height: 12),
              SizedBox(
                height: 250,
                child: ReusableErrorView(
                  title: 'Connection Error',
                  message: 'Unable to connect to the server',
                  onRetry: () {
                    ReusableToast.info(context, 'Retrying...');
                  },
                ),
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('Reusable Snackbar'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ElevatedButton(
                    onPressed: () => ReusabelSnackbar.success(context, 'Success! Operation completed.'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text('Success'),
                  ),
                  ElevatedButton(
                    onPressed: () => ReusabelSnackbar.error(context, 'Error! Something went wrong.'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Error'),
                  ),
                  ElevatedButton(
                    onPressed: () => ReusabelSnackbar.info(context, 'Info: Here is some information.'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: const Text('Info'),
                  ),
                  ElevatedButton(
                    onPressed: () => ReusabelSnackbar.warning(context, 'Warning! Please be careful.'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                    child: const Text('Warning'),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('Reusable Toast'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ElevatedButton(
                    onPressed: () => ReusableToast.success(context, 'Success Toast!'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text('Toast Success'),
                  ),
                  ElevatedButton(
                    onPressed: () => ReusableToast.error(context, 'Error Toast!'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Toast Error'),
                  ),
                  ElevatedButton(
                    onPressed: () => ReusableToast.warning(context, 'Warning Toast!'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                    child: const Text('Toast Warning'),
                  ),
                  ElevatedButton(
                    onPressed: () => ReusableToast.info(context, 'Info Toast!'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: const Text('Toast Info'),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('Reusable Dropdown'),
              const SizedBox(height: 12),
              ReuabelDropdown<String>(
                labelText: 'Country',
                hintText: 'Select your country',
                items: const [
                  'USA',
                  'Canada',
                  'UK',
                  'India',
                  'Australia',
                  'Germany',
                  'France'
                ],
                allowClear: true,
                onChanged: (value) {
                  setState(() => _selectedCountry = value);
                },
                initialValue: _selectedCountry,
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('Reusable Text Form Fields'),
              const SizedBox(height: 12),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    ReusableTextFormField(
                      label: 'Full Name',
                      hintText: 'Enter your full name',
                      prefixIcon: const Icon(Icons.person),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Name is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    ReusableTextFormField(
                      label: 'Email Address',
                      hintText: 'example@email.com',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.email),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        }
                        if (!value.contains('@')) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ReusableToast.success(context, 'Form is valid!');
                        }
                      },
                      child: const Text('Validate Form'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('Reusable Circle Avatars'),
              const SizedBox(height: 12),
              const Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  ReusableCircleAvatar(
                    initials: 'AM',
                    radius: 35,
                    backgroundColor: Colors.blue,
                    borderColor: Colors.blueAccent,
                    borderWidth: 2,
                  ),
                  ReusableCircleAvatar(
                    initials: 'SK',
                    radius: 35,
                    backgroundColor: Colors.green,
                    borderColor: Colors.greenAccent,
                    borderWidth: 2,
                  ),
                  ReusableCircleAvatar(
                    initials: 'TJ',
                    radius: 35,
                    backgroundColor: Colors.orange,
                    borderColor: Colors.orangeAccent,
                    borderWidth: 2,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('Reusable Date Picker'),
              const SizedBox(height: 12),
              ReusableDatePicker(
                label: 'Select Date',
                hint: 'Choose a date',
                mode: ReusableDatePickerMode.date,
                initialDateTime: _selectedDate,
                onChanged: (date) {
                  setState(() => _selectedDate = date);
                },
                decoration: InputDecoration(
                  labelText: 'Birth Date',
                  hintText: 'Pick your birth date',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.calendar_today),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                ),
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('Reusable Radio Group'),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Gender:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ReusableRadioGroup<String>(
                      items: const [
                        'Male',
                        'Female',
                        'Other',
                        'Prefer not to say'
                      ],
                      value: _selectedGender,
                      onChanged: (value) {
                        setState(() => _selectedGender = value);
                      },
                      direction: Axis.vertical,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ReusableBottomNavBar(
        currentIndex: _currentNavIndex,
        onTap: (index) {
          setState(() => _currentNavIndex = index);
          ReusableToast.info(context, 'Tab ${index + 1} selected');
        },
        items: [
          NavBarItem(
            icon: Icons.home,
            label: 'Home',
          ),
          NavBarItem(
            icon: Icons.widgets,
            label: 'Widgets',
          ),
          NavBarItem(
            icon: Icons.settings,
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }
}
