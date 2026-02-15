import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:lidar_application/main.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignupPageState();
}

bool _isValidComEmail(String email) {
  final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.com$');
  return emailRegex.hasMatch(email);
}

class PhilippinesPhoneFormatter extends TextInputFormatter {
  static const String prefix = '(+63) ';

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Force prefix to always exist
    if (!newValue.text.startsWith(prefix)) {
      return TextEditingValue(
        text: prefix,
        selection: TextSelection.collapsed(offset: prefix.length),
      );
    }

    // Allow only digits AFTER prefix
    final digits = newValue.text
        .substring(prefix.length)
        .replaceAll(RegExp(r'\D'), '');

    // Limit to 10 digits (PH mobile)
    final limitedDigits = digits.length > 10 ? digits.substring(0, 10) : digits;

    final newText = prefix + limitedDigits;

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class _SignupPageState extends State<SignUpPage> {
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _isLoading = false;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _phoneController.text = '(+63) ';
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _signUp() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      _showSnack('Email is required');
      return;
    }

    if (!_isValidComEmail(email)) {
      _showSnack('Only emails ending with .com are allowed');
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      _showSnack('Passwords do not match');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: _passwordController.text.trim(),
      );

      final user = cred.user;
      if (user == null) throw Exception('User creation failed');

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'email': user.email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const AuthGate()),
          (route) => false,
        );
      }
            
    } on FirebaseAuthException catch (e) {
      String message = 'Signup failed';

      if (e.code == 'email-already-in-use') {
        message = 'This email is already registered. Please sign in.';
      }

      _showSnack(message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _inputField(
    String label, {
    TextEditingController? controller,
    bool isPassword = false,
    bool isPhone = false,
    required bool visible,
    required VoidCallback onToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),

        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white24, width: 1.2),
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword && !visible,
            cursorColor: Colors.white,
            keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
            inputFormatters: isPhone ? [PhilippinesPhoneFormatter()] : null,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF020B2E),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        visible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white70,
                        size: 20,
                      ),
                      onPressed: onToggle,
                    )
                  : null,
            ),
          ),
        ),

        const SizedBox(height: 18),
      ],
    );
  }

  Widget _createButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _signUp,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: Colors.black, width: 1.2),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              )
            : const Text(
                'Create Account',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
      ),
    );
  }

  Widget _signInAccountButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: _isLoading
            ? null
            : () {
                Navigator.of(context).pushNamed('/signin');
              },
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: Colors.white, width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          backgroundColor: const Color(0xFF020B2E),
        ),
        child: const Text(
          'Sign In',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF000B26), Color(0xFF000010)],
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: height * 0.88,
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              decoration: const BoxDecoration(
                color: Color(0xFF9EA2A8),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(42),
                  topRight: Radius.circular(42),
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        children: [
                          _inputField(
                            'First Name',
                            controller: _firstNameController,
                            isPassword: false,
                            visible: true,
                            onToggle: () {},
                          ),
                          _inputField(
                            'Last Name',
                            controller: _lastNameController,
                            isPassword: false,
                            visible: true,
                            onToggle: () {},
                          ),
                          _inputField(
                            'Email',
                            controller: _emailController,
                            isPassword: false,
                            visible: true,
                            onToggle: () {},
                          ),
                          _inputField(
                            'Phone Number',
                            controller: _phoneController,
                            isPhone: true,
                            isPassword: false,
                            visible: true,
                            onToggle: () {},
                          ),
                          _inputField(
                            'Password',
                            controller: _passwordController,
                            isPassword: true,
                            visible: _passwordVisible,
                            onToggle: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),

                          _inputField(
                            'Confirm Password',
                            controller: _confirmPasswordController,
                            isPassword: true,
                            visible: _confirmPasswordVisible,
                            onToggle: () {
                              setState(() {
                                _confirmPasswordVisible =
                                    !_confirmPasswordVisible;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: _createButton(),
                  ),

                  _signInAccountButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
