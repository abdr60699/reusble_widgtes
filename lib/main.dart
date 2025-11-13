import 'package:flutter/material.dart';

import 'sharedwidget/reusable_app_bar.dart';
import 'sharedwidget/reusable_dropdown.dart';
import 'sharedwidget/reusable_text_form_field.dart';
import 'sharedwidget/reusable_circle_avatar.dart';
import 'sharedwidget/reusable_datepicker.dart';
import 'sharedwidget/reusable_radiogroup.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedCountry;
  DateTime? _selectedDate;
  String _selectedGender = 'Male';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        titleText: 'Reusable Widgets Demo',
        centerTitle: true,
        elevation: 2,
        showElevation: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSectionTitle('Reusable Dropdown'),
            const SizedBox(height: 12),
            ReuabelDropdown<String>(
              labelText: 'Country',
              hintText: 'Select your country',
              items: const ['USA', 'Canada', 'UK', 'India', 'Australia', 'Germany', 'France'],
              allowClear: true,
              onChanged: (value) {
                setState(() {
                  _selectedCountry = value;
                });
              },
              initialValue: _selectedCountry,
            ),
            const SizedBox(height: 12),
            if (_selectedCountry != null)
              Text(
                'Selected: $_selectedCountry',
                style: const TextStyle(color: Colors.grey),
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
                  ReusableTextFormField(
                    label: 'Password',
                    hintText: 'Enter password',
                    obscureText: true,
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: const Icon(Icons.visibility_off),
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  ReusableTextFormField(
                    label: 'Bio',
                    hintText: 'Tell us about yourself',
                    maxLines: 3,
                    prefixIcon: const Icon(Icons.info),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Form is valid!')),
                        );
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
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: const [
                ReusableCircleAvatar(
                  initials: 'AM',
                  radius: 35,
                  backgroundColor: Colors.blue,
                  borderColor: Colors.blueAccent,
                  borderWidth: 2,
                  onTap: null,
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
                ReusableCircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.purple,
                  borderColor: Colors.purpleAccent,
                  borderWidth: 2,
                  fallbackIcon: Icons.person,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                ReusableCircleAvatar(
                  initials: 'XL',
                  radius: 30,
                  backgroundColor: Colors.pink,
                ),
                ReusableCircleAvatar(
                  initials: 'YZ',
                  radius: 30,
                  backgroundColor: Colors.deepOrange,
                ),
                ReusableCircleAvatar(
                  initials: 'QW',
                  radius: 30,
                  backgroundColor: Colors.indigo,
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
                setState(() {
                  _selectedDate = date;
                });
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
            const SizedBox(height: 12),
            if (_selectedDate != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      'Selected: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
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
                    items: const ['Male', 'Female', 'Other', 'Prefer not to say'],
                    value: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                    direction: Axis.vertical,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'You selected: $_selectedGender',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('More Radio Options'),
            const SizedBox(height: 12),
            ReusableRadioGroup<String>(
              items: const ['Option A', 'Option B', 'Option C'],
              value: 'Option A',
              onChanged: (value) {},
              direction: Axis.horizontal,
              spacing: 16,
            ),
            const SizedBox(height: 24),
          ],
        ),
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