import 'package:flutter/material.dart';
import 'widgets/custom_button.dart';
import 'widgets/custom_card.dart';
import 'widgets/custom_textfield.dart';
import 'widgets/custom_chip.dart';
import 'widgets/custom_avatar.dart';
import 'widgets/custom_loading.dart';
import 'widgets/custom_badge.dart';
import 'sharedwidget/reusable_app_bar.dart';
import 'sharedwidget/reusable_dropdown.dart';

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
            _buildSectionTitle('Custom Buttons'),
            const SizedBox(height: 12),
            CustomButton(
              text: 'Primary Button',
              onPressed: () {},
            ),
            const SizedBox(height: 12),
            CustomButton(
              text: 'Button with Icon',
              icon: Icons.star,
              color: Colors.purple,
              onPressed: () {},
            ),
            const SizedBox(height: 12),
            CustomButton(
              text: 'Disabled Button',
              onPressed: null,
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('Custom Cards'),
            const SizedBox(height: 12),
            CustomCard(
              title: 'Card with Icon',
              subtitle: 'This is a subtitle',
              icon: Icons.shopping_cart,
              iconColor: Colors.green,
              onTap: () {},
            ),
            const SizedBox(height: 12),
            CustomCard(
              title: 'Card with Trailing',
              subtitle: 'Another card example',
              icon: Icons.notification_important,
              iconColor: Colors.orange,
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
            const SizedBox(height: 12),
            CustomCard(
              title: 'Simple Card',
              icon: Icons.settings,
              iconColor: Colors.blueGrey,
              onTap: () {},
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('Custom Text Fields'),
            const SizedBox(height: 12),
            const CustomTextField(
              label: 'Email',
              hint: 'Enter your email',
              prefixIcon: Icons.email,
            ),
            const SizedBox(height: 12),
            const CustomTextField(
              label: 'Password',
              hint: 'Enter your password',
              prefixIcon: Icons.lock,
              suffixIcon: Icons.visibility,
              obscureText: true,
            ),
            const SizedBox(height: 12),
            const CustomTextField(
              hint: 'Search...',
              prefixIcon: Icons.search,
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('Custom Chips'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                CustomChip(
                  label: 'Flutter',
                  backgroundColor: Colors.blue,
                  icon: Icons.code,
                ),
                CustomChip(
                  label: 'Dart',
                  backgroundColor: Colors.teal,
                  icon: Icons.favorite,
                ),
                CustomChip(
                  label: 'UI/UX',
                  backgroundColor: Colors.purple,
                  onDeleted: () {},
                ),
                CustomChip(
                  label: 'Mobile',
                  backgroundColor: Colors.orange,
                  icon: Icons.phone_android,
                ),
              ],
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('Custom Avatars'),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                CustomAvatar(
                  initials: 'AB',
                  size: 60,
                  backgroundColor: Colors.blue,
                ),
                CustomAvatar(
                  initials: 'CD',
                  size: 60,
                  backgroundColor: Colors.green,
                ),
                CustomAvatar(
                  initials: 'EF',
                  size: 60,
                  backgroundColor: Colors.purple,
                ),
                CustomAvatar(
                  initials: 'GH',
                  size: 60,
                  backgroundColor: Colors.orange,
                ),
              ],
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('Custom Loading Indicator'),
            const SizedBox(height: 12),
            const Center(
              child: CustomLoading(
                message: 'Loading...',
                size: 40,
              ),
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('Custom Badges'),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomBadge(
                  count: 5,
                  child: Icon(Icons.shopping_cart, size: 40, color: Colors.blue),
                ),
                CustomBadge(
                  count: 99,
                  badgeColor: Colors.green,
                  child: Icon(Icons.message, size: 40, color: Colors.blue),
                ),
                CustomBadge(
                  label: 'NEW',
                  badgeColor: Colors.red,
                  child: Icon(Icons.notifications, size: 40, color: Colors.blue),
                ),
                CustomBadge(
                  count: 150,
                  badgeColor: Colors.purple,
                  child: Icon(Icons.mail, size: 40, color: Colors.blue),
                ),
              ],
            ),
            const SizedBox(height: 24),

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

            _buildSectionTitle('Different Button Styles'),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Success',
                    color: Colors.green,
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomButton(
                    text: 'Warning',
                    color: Colors.orange,
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomButton(
                    text: 'Danger',
                    color: Colors.red,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('More Card Examples'),
            const SizedBox(height: 12),
            CustomCard(
              title: 'Profile Settings',
              subtitle: 'Manage your account',
              icon: Icons.person,
              iconColor: Colors.blue,
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            const SizedBox(height: 12),
            CustomCard(
              title: 'Notifications',
              subtitle: '5 new messages',
              icon: Icons.notifications_active,
              iconColor: Colors.red,
              trailing: CustomBadge(
                count: 5,
                badgeColor: Colors.red,
                child: const Icon(Icons.notifications, size: 24),
              ),
              onTap: () {},
            ),
            const SizedBox(height: 12),
            CustomCard(
              title: 'Dark Mode',
              subtitle: 'Toggle theme',
              icon: Icons.dark_mode,
              iconColor: Colors.indigo,
              trailing: Switch(
                value: false,
                onChanged: (value) {},
              ),
              onTap: () {},
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('Various Avatars'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: const [
                CustomAvatar(
                  initials: 'JD',
                  size: 50,
                  backgroundColor: Colors.red,
                ),
                CustomAvatar(
                  initials: 'AS',
                  size: 50,
                  backgroundColor: Colors.teal,
                ),
                CustomAvatar(
                  initials: 'MK',
                  size: 50,
                  backgroundColor: Colors.deepPurple,
                ),
                CustomAvatar(
                  initials: 'LW',
                  size: 50,
                  backgroundColor: Colors.pink,
                ),
                CustomAvatar(
                  initials: 'RP',
                  size: 50,
                  backgroundColor: Colors.cyan,
                ),
              ],
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('More Chips'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                CustomChip(
                  label: 'Technology',
                  backgroundColor: Colors.deepOrange,
                  icon: Icons.computer,
                ),
                CustomChip(
                  label: 'Design',
                  backgroundColor: Colors.pink,
                  icon: Icons.design_services,
                ),
                CustomChip(
                  label: 'Development',
                  backgroundColor: Colors.indigo,
                  icon: Icons.code,
                ),
                CustomChip(
                  label: 'Marketing',
                  backgroundColor: Colors.green,
                  icon: Icons.campaign,
                  onDeleted: () {},
                ),
                CustomChip(
                  label: 'Sales',
                  backgroundColor: Colors.amber,
                  icon: Icons.attach_money,
                ),
              ],
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('Loading States'),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                CustomLoading(
                  message: 'Small',
                  size: 20,
                ),
                CustomLoading(
                  message: 'Medium',
                  size: 30,
                ),
                CustomLoading(
                  message: 'Large',
                  size: 50,
                  color: Colors.purple,
                ),
              ],
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('Additional Text Fields'),
            const SizedBox(height: 12),
            const CustomTextField(
              label: 'Username',
              hint: 'Enter username',
              prefixIcon: Icons.person_outline,
            ),
            const SizedBox(height: 12),
            const CustomTextField(
              label: 'Phone Number',
              hint: '+1 (555) 000-0000',
              prefixIcon: Icons.phone,
            ),
            const SizedBox(height: 12),
            const CustomTextField(
              label: 'Website',
              hint: 'https://example.com',
              prefixIcon: Icons.language,
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
