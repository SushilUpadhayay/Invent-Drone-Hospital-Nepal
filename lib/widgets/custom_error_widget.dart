// lib/widgets/custom_error_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../core/app_export.dart';
// Import your routes

class CustomErrorWidget extends StatelessWidget {
  final FlutterErrorDetails? errorDetails;
  final String? errorMessage;

  const CustomErrorWidget({
    super.key,
    this.errorDetails,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/sad_face.svg',
                  height: 42,
                  width: 42,
                  color: const Color(0xFF525252),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Something went wrong",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF262626),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'We encountered an unexpected error while processing your request.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF525252),
                  ),
                ),
                const SizedBox(height: 32),

                // Fixed: Use AppRoutes.login instead of AppRoutes.initial
                ElevatedButton.icon(
                  onPressed: () {
                    bool canGoBack = Navigator.canPop(context);
                    if (canGoBack) {
                      Navigator.of(context).pop();
                    } else {
                      // Now goes to Login (home screen)
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.login, // Fixed here
                        (route) => false, // Clear all previous routes
                      );
                    }
                  },
                  icon: const Icon(Icons.arrow_back, size: 18),
                  label: const Text('Back to Home'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.lightTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
