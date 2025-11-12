import 'package:flutter/material.dart';
import 'widgets/custom_button.dart';
import 'widgets/custom_card.dart';
import 'widgets/custom_textfield.dart';
import 'widgets/custom_chip.dart';
import 'widgets/custom_avatar.dart';
import 'widgets/custom_loading.dart';
import 'widgets/custom_badge.dart';

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

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reusable Widgets Demo'),
        centerTitle: true,
        elevation: 2,
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
