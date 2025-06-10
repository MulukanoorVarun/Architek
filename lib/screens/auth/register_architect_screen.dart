import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:arkitek_app/blocs/auth/auth_bloc.dart';
import 'package:arkitek_app/theme/colors.dart';
import 'package:arkitek_app/theme/spacing.dart';

class RegisterArchitectScreen extends StatefulWidget {
  const RegisterArchitectScreen({super.key});

  @override
  State<RegisterArchitectScreen> createState() => _RegisterArchitectScreenState();
}

class _RegisterArchitectScreenState extends State<RegisterArchitectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final List<String> _selectedSpecializations = [];
  
  final List<String> _specializations = [
    'Residential',
    'Commercial',
    'Industrial',
    'Landscape',
    'Interior',
    'Sustainable',
    'Urban Planning'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register as Architect'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Join our network and grow your business',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
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
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Specializations',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: _specializations.map((spec) {
                  final isSelected = _selectedSpecializations.contains(spec);
                  return FilterChip(
                    label: Text(spec),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedSpecializations.add(spec);
                        } else {
                          _selectedSpecializations.remove(spec);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.xl),
              ElevatedButton(
                onPressed: _register,
                child: const Text('Create Account'),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'By registering, you agree to our Terms of Service and Privacy Policy',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      if (_selectedSpecializations.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select at least one specialization'),
          ),
        );
        return;
      }

      context.read<AuthBloc>().add(
        SignUp(
          name: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          userType: 'architect',
        ),
      );
    }
  }
}