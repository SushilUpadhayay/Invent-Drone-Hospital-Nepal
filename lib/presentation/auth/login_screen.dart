// lib/presentation/auth/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../routes/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    HapticFeedback.lightImpact();

    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    if (_passwordController.text.length >= 6) {
      await Hive.box('settings').put('isLoggedIn', true);
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.home, (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Invalid credentials"), backgroundColor: Colors.red),
      );
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.sp),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            theme.colorScheme.primary.withOpacity(0.2),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/logo.png',
                          height: 60.sp,
                          width: 60.sp,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: theme.colorScheme.primary.withOpacity(0.15),
                            child: Icon(Icons.flight_takeoff,
                                size: 30.sp, color: theme.colorScheme.primary),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 1.5.h),
                    Text(
                      "Invent",
                      style: TextStyle(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    Text(
                      "Drone Hospital Nepal",
                      style: TextStyle(
                          fontSize: 12.sp,
                          color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),

                SizedBox(height: 5.h),

                Card(
                  elevation: 12,
                  shadowColor: theme.colorScheme.primary.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: EdgeInsets.all(6.w),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Email
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: "Email",
                              prefixIcon: const Icon(Icons.email_outlined),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14)),
                            ),
                            validator: (v) => v?.isEmpty ?? true
                                ? "Enter email"
                                : !v!.contains("@")
                                    ? "Invalid email"
                                    : null,
                          ),
                          SizedBox(height: 2.h),

                          // Password
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: "Password",
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(_obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onPressed: () => setState(
                                    () => _obscurePassword = !_obscurePassword),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14)),
                            ),
                            validator: (v) => v?.isEmpty ?? true
                                ? "Enter password"
                                : v!.length < 6
                                    ? "Min 6 characters"
                                    : null,
                          ),

                          SizedBox(height: 1.5.h),

                          // Remember + Forgot
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: _rememberMe,
                                    onChanged: (v) =>
                                        setState(() => _rememberMe = v!),
                                    activeColor: theme.colorScheme.primary,
                                  ),
                                  Text("Remember me",
                                      style: TextStyle(fontSize: 11.sp)),
                                ],
                              ),
                              TextButton(
                                onPressed: () =>
                                    ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Coming soon")),
                                ),
                                child: Text("Forgot?",
                                    style: TextStyle(
                                        color: theme.colorScheme.primary)),
                              ),
                            ],
                          ),

                          SizedBox(height: 3.h),

                          // Login Button
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.primary,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14)),
                                elevation: 6,
                              ),
                              child: _isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white)
                                  : Text("Sign In",
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                            ),
                          ),

                          SizedBox(height: 2.5.h),

                          // OR
                          Row(children: [
                            Expanded(
                                child: Divider(color: Colors.grey.shade400)),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 3.w),
                                child: Text("OR",
                                    style: TextStyle(
                                        color: Colors.grey.shade600))),
                            Expanded(
                                child: Divider(color: Colors.grey.shade400)),
                          ]),

                          SizedBox(height: 2.h),

                          // Google Button
                          OutlinedButton.icon(
                            onPressed: () =>
                                ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Google Sign-In coming soon")),
                            ),
                            icon: Image.asset('assets/icons/google.png',
                                height: 20, width: 20),
                            label: const Text("Continue with Google"),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                            ),
                          ),

                          SizedBox(height: 2.h),

                          // Demo Hint
                          Text(
                            "Demo: Any email + password (6+ chars)",
                            style: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.grey.shade600,
                                fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 3.h),

                // Footer
                Text(
                  "© 2025 Invent • Sushil Upadhayay",
                  style: TextStyle(
                      fontSize: 10.sp, color: theme.colorScheme.outline),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
