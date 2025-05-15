import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tripfin/Block/Logic/RegisterBloc/Register_cubit.dart';
import 'package:tripfin/Block/Logic/RegisterBloc/Register_state.dart';
import 'package:tripfin/Screens/Components/CustomSnackBar.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Form key and controllers
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();

  // State variables
  bool _obscurePassword = true;
  String? _selectedCurrency;
  final List<String> _currencies = ['USD', 'EUR', 'INR', 'JPY'];

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // Validation functions
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*#?&]{8,}$')
        .hasMatch(value)) {
      return 'Password must contain letters and numbers';
    }
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? _validateMobile(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your mobile number';
    }
    final mobileRegex = RegExp(r'^\+?[1-9]\d{9,14}$');
    if (!mobileRegex.hasMatch(value)) {
      return 'Please enter a valid mobile number';
    }
    return null;
  }

  void _handleRegistration(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      if (_selectedCurrency == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a currency'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final registerData = {
        'full_name': _nameController.text.trim(),
        'mobile': _mobileController.text.trim(),
        'password': _passwordController.text,
        'confirm_password': _passwordController.text,
        'email': _emailController.text.trim(),
        'currency': _selectedCurrency,
      };

      context.read<RegisterCubit>().postRegister(registerData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C3132),
      body: SafeArea(
        child: BlocConsumer<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Registration successful!'),
                  backgroundColor: Colors.green,
                ),
              );
              // Navigate to next screen
            } else if (state is RegisterError) {
         CustomSnackBar.show(context, state.message);
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            'Create Account',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontFamily: 'Mullish',
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Name Field
                        _buildLabel('Full Name'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          hint: 'Enter your full name',
                          controller: _nameController,
                          validator: _validateName,
                          icon: Icons.person_outline,
                        ),

                        const SizedBox(height: 16),

                        // Mobile Field
                        _buildLabel('Mobile Number'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          hint: 'Enter your mobile number',
                          controller: _mobileController,
                          inputType: TextInputType.phone,
                          validator: _validateMobile,
                          icon: Icons.phone_outlined,
                        ),

                        const SizedBox(height: 16),

                        // Email Field
                        _buildLabel('Email Address'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          hint: 'Enter your email',
                          controller: _emailController,
                          inputType: TextInputType.emailAddress,
                          validator: _validateEmail,
                          icon: Icons.email_outlined,
                        ),

                        const SizedBox(height: 16),

                        // Password Field
                        _buildLabel('Password'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          hint: 'Enter your password',
                          controller: _passwordController,
                          validator: _validatePassword,
                          obscureText: _obscurePassword,
                          icon: Icons.lock_outline,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.white70,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Currency Selection
                        _buildLabel('Preferred Currency'),
                        const SizedBox(height: 8),
                        _buildCurrencyDropdown(),

                        const SizedBox(height: 32),

                        // Register Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF4A261),
                              foregroundColor: const Color(0xFF1C3132),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              elevation: 2,
                            ),
                            onPressed:
                            state is RegisterLoading ? null : () => _handleRegistration(context),
                            child: state is RegisterLoading
                                ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Color(0xFF1C3132),
                                strokeWidth: 2,
                              ),
                            )
                                : const Text(
                              'Register',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Mullish',
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Login Link
                        Center(
                          child: TextButton(
                            onPressed: () {
                              context.push('/login_mobile');
                            },
                            child: const Text(
                              'Already have an account? Login',
                              style: TextStyle(
                                color: Color(0xFFF4A261),
                                fontFamily: 'Mullish',
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        fontFamily: 'Mullish',
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required TextEditingController controller,
    TextInputType inputType = TextInputType.text,
    String? Function(String?)? validator,
    bool obscureText = false,
    IconData? icon,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      obscureText: obscureText,
      style: const TextStyle(
        color: Colors.white,
        fontFamily: 'Mullish',
        fontSize: 14,
      ),
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Color(0xFFB0B0B0),
          fontFamily: 'Mullish',
        ),
        prefixIcon: icon != null
            ? Icon(
          icon,
          color: Colors.white70,
          size: 20,
        )
            : null,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0x1AFFFFFF),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: Colors.white54, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: Color(0xFFF4A261), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }

  Widget _buildCurrencyDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white54),
        color: const Color(0x1AFFFFFF),
      ),
      child: DropdownButton<String>(
        value: _selectedCurrency,
        hint: const Text(
          'Select Currency',
          style: TextStyle(
            color: Color(0xFFB0B0B0),
            fontFamily: 'Mullish',
            fontSize: 14,
          ),
        ),
        dropdownColor: const Color(0xFF2A3E3F),
        isExpanded: true,
        underline: const SizedBox(),
        icon: const Icon(
          Icons.arrow_drop_down,
          color: Colors.white70,
        ),
        style: const TextStyle(
          color: Colors.white,
          fontFamily: 'Mullish',
          fontSize: 14,
        ),
        items: _currencies.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedCurrency = value;
          });
        },
      ),
    );
  }
}