import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:firebase_core/firebase_core.dart';  // Temporarily disabled
// import 'package:sentry_flutter/sentry_flutter.dart';  // Temporarily disabled
import 'src/app.dart';
import 'src/core/services/service_locator.dart';
// import 'src/core/config/firebase_options.dart';  // Temporarily disabled

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables (optional for web)
  try {
    await dotenv.load(fileName: ".env.local");
  } catch (e) {
    print('Warning: Could not load .env.local file: $e');
    // Continue without environment variables for web development
  }
  
  // Initialize services
  await ServiceLocator.init();
  
  // Run app directly (Firebase and Sentry temporarily disabled)
  runApp(const GyanAIApp());
}
