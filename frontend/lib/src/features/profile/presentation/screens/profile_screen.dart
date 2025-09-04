import 'package:flutter/material.dart';
import '../../../../core/theme/app_text_styles.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: const Center(
        child: Text(
          'Profile Screen\n(To be implemented)',
          style: AppTextStyles.h3,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
