import 'package:arkitek_app/bloc/register/register_cubit.dart';
import 'package:arkitek_app/bloc/register/register_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../utils/Validator.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _validator = Validator();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();
  final _licenseNumberController = TextEditingController();
  final _specializationController = TextEditingController();
  final _yearsOfExperienceController = TextEditingController();
  final _portfolioUrlController = TextEditingController();
  final _countryController = TextEditingController();
  final _officeLocationController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
    _licenseNumberController.dispose();
    _specializationController.dispose();
    _yearsOfExperienceController.dispose();
    _portfolioUrlController.dispose();
    _countryController.dispose();
    _officeLocationController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && mounted) {
      Map<String, dynamic> data = {
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'email': _emailController.text.trim(),
        'password': _passwordController.text,
        'password_confirmation': _passwordConfirmationController.text,
        'license_number': _licenseNumberController.text.trim(),
        'specialization': _specializationController.text.trim(),
        'years_of_experience': _yearsOfExperienceController.text.trim(),
        'portfolio_url': _portfolioUrlController.text.trim(),
        'country': _countryController.text.trim(),
        'office_location': _officeLocationController.text.trim(),
      };
      context.read<RegisterCubit>().registerAPi(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _nameController,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black,
                      ),
                  decoration: InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: _validator.validateName,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black,
                      ),
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: _validator.validatePhone,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black,
                      ),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: _validator.validateEmail,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black,
                      ),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: _validator.validatePassword,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _passwordConfirmationController,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black,
                      ),
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: (value) => _validator.validatePasswordConfirmation(
                      value, _passwordController.text),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _licenseNumberController,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black,
                      ),
                  decoration: InputDecoration(
                    labelText: 'License Number',
                    prefixIcon: Icon(Icons.badge),
                  ),
                  validator: _validator.validateLicenseNumber,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _specializationController,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black,
                      ),
                  decoration: InputDecoration(
                    labelText: 'Specialization',
                    prefixIcon: Icon(Icons.work),
                  ),
                  validator: _validator.validateSpecialization,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _yearsOfExperienceController,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black,
                      ),
                  decoration: InputDecoration(
                    labelText: 'Years of Experience',
                    prefixIcon: Icon(Icons.timer),
                  ),
                  keyboardType: TextInputType.number,
                  validator: _validator.validateYearsOfExperience,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _portfolioUrlController,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black,
                      ),
                  decoration: InputDecoration(
                    labelText: 'Portfolio URL',
                    prefixIcon: Icon(Icons.link),
                  ),
                  keyboardType: TextInputType.url,
                  validator: _validator.validatePortfolioUrl,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _countryController,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black,
                      ),
                  decoration: InputDecoration(
                    labelText: 'Country',
                    prefixIcon: Icon(Icons.flag),
                  ),
                  validator: _validator.validateCountry,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _officeLocationController,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black,
                      ),
                  decoration: InputDecoration(
                    labelText: 'Office Location',
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  validator: _validator.validateOfficeLocation,
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: BlocConsumer<RegisterCubit, RegisterState>(
                    listener: (context, state) {
                      if (state is RegisterLoaded &&
                          (state.successModel.status ?? false)) {
                        context.push("/login");
                      }
                    },
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: state is RegisterLoading
                            ? CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 1,
                              )
                            : Text(
                                'Register',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(
                                      color: Colors.white,
                                    ),
                              ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
