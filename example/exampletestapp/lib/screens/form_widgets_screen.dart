import 'package:flutter/material.dart';
import 'package:reuablewidgets/sharedwidget/reusable_app_bar.dart';
import 'package:reuablewidgets/sharedwidget/reusable_text_form_field.dart';
import 'package:reuablewidgets/sharedwidget/reusable_dropdown.dart';
import 'package:reuablewidgets/sharedwidget/reusable_datepicker.dart';
import 'package:reuablewidgets/sharedwidget/reusable_radiogroup.dart';
import 'package:reuablewidgets/sharedwidget/reusable_toast.dart';

class FormWidgetsScreen extends StatefulWidget {
  const FormWidgetsScreen({super.key});

  @override
  State<FormWidgetsScreen> createState() => _FormWidgetsScreenState();
}

class _FormWidgetsScreenState extends State<FormWidgetsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  String? _selectedCountry;
  String? _selectedGender;
  DateTime? _selectedDate;

  final List<String> _countries = [
    'United States',
    'India',
    'United Kingdom',
    'Canada',
    'Australia',
  ];

  final List<String> _genderOptions = ['Male', 'Female', 'Other'];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        title: 'Form Widgets',
        showBackButton: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Test all form widgets',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Text Form Fields'),
            ReusableTextFormField(
              controller: _nameController,
              labelText: 'Full Name',
              hintText: 'Enter your full name',
              prefixIcon: Icons.person,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ReusableTextFormField(
              controller: _emailController,
              labelText: 'Email',
              hintText: 'Enter your email',
              prefixIcon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ReusableTextFormField(
              controller: _passwordController,
              labelText: 'Password',
              hintText: 'Enter your password',
              prefixIcon: Icons.lock,
              isPassword: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ReusableTextFormField(
              controller: _phoneController,
              labelText: 'Phone Number',
              hintText: 'Enter your phone number',
              prefixIcon: Icons.phone,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Dropdown'),
            ReusableDropdown<String>(
              value: _selectedCountry,
              items: _countries,
              hintText: 'Select your country',
              labelText: 'Country',
              prefixIcon: Icons.flag,
              onChanged: (value) {
                setState(() => _selectedCountry = value);
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a country';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Date Picker'),
            ReusableDatePicker(
              labelText: 'Date of Birth',
              selectedDate: _selectedDate,
              onDateSelected: (date) {
                setState(() => _selectedDate = date);
                ReusableToast.show(
                  context: context,
                  message: 'Selected: ${date.toString().split(' ')[0]}',
                  backgroundColor: Colors.black87,
                );
              },
              firstDate: DateTime(1950),
              lastDate: DateTime.now(),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Radio Group'),
            ReusableRadioGroup<String>(
              title: 'Gender',
              options: _genderOptions,
              selectedValue: _selectedGender,
              onChanged: (value) {
                setState(() => _selectedGender = value);
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Submit Form',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: _resetForm,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Reset Form',
                style: TextStyle(fontSize: 16),
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
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Form is valid
      final data = {
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'country': _selectedCountry,
        'gender': _selectedGender,
        'dob': _selectedDate?.toString().split(' ')[0],
      };

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Form Submitted'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: data.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text('${entry.key}: ${entry.value ?? 'Not selected'}'),
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      ReusableToast.show(
        context: context,
        message: 'Please fill all required fields',
        backgroundColor: Colors.red,
      );
    }
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _phoneController.clear();
    setState(() {
      _selectedCountry = null;
      _selectedGender = null;
      _selectedDate = null;
    });

    ReusableToast.show(
      context: context,
      message: 'Form reset successfully',
      backgroundColor: Colors.black87,
    );
  }
}
