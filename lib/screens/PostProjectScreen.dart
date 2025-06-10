import 'package:arkitek_app/bloc/add_edit_post/add_edit_post_cubit.dart';
import 'package:arkitek_app/bloc/add_edit_post/add_edit_post_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../utils/Validator.dart';

class AddEditProjectScreen extends StatefulWidget {
  final Map<String, dynamic>? post;

  const AddEditProjectScreen({super.key, this.post});

  @override
  _PostProjectScreenState createState() => _PostProjectScreenState();
}

class _PostProjectScreenState extends State<AddEditProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _validator = Validator();
  final _customerNameController = TextEditingController();
  final _customerEmailController = TextEditingController();
  final _customerPhoneController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _projectLocationController = TextEditingController();
  final _budgetController = TextEditingController();
  final _timelineStartController = TextEditingController();
  final _timelineEndController = TextEditingController();
  final _customerLocationController = TextEditingController();
  final _specializationController = TextEditingController();
  String? _urgency;
  final List<String> _requiredSkills = [];

  // Available skills for multi-select
  final List<String> _availableSkills = [
    'AutoCAD',
    'SketchUp',
    'Vastu',
    'Revit',
    '3ds Max',
    'Lumion'
  ];

  @override
  void initState() {
    super.initState();
    // Prefill fields if editing
    if (widget.post != null) {
      _customerNameController.text = widget.post!['customer_name'] ?? '';
      _customerEmailController.text = widget.post!['customer_email'] ?? '';
      _customerPhoneController.text = widget.post!['customer_phone'] ?? '';
      _titleController.text = widget.post!['title'] ?? '';
      _descriptionController.text = widget.post!['description'] ?? '';
      _projectLocationController.text = widget.post!['project_location'] ?? '';
      _budgetController.text = widget.post!['budget'] ?? '';
      _timelineStartController.text = widget.post!['timeline_start'] ?? '';
      _timelineEndController.text = widget.post!['timeline_end'] ?? '';
      _urgency = widget.post!['urgency'];
      _customerLocationController.text =
          widget.post!['customer_location'] ?? '';
      _specializationController.text = widget.post!['specialization'] ?? '';
      final skills = widget.post!['required_skills']?.split(',') ?? [];
      _requiredSkills.addAll(skills.map((s) => s.trim()));
    }
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _customerEmailController.dispose();
    _customerPhoneController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _projectLocationController.dispose();
    _budgetController.dispose();
    _timelineStartController.dispose();
    _timelineEndController.dispose();
    _customerLocationController.dispose();
    _specializationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future<void> _submitForm() async {
    final isFormValid = _formKey.currentState!.validate();
    final hasSelectedSkills = _requiredSkills.isNotEmpty;

    if (!isFormValid || !hasSelectedSkills) {
      if (!hasSelectedSkills) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select at least one required skill'),
          ),
        );
      }
      return; // Stop execution if any validation fails
    }

    // Proceed only if both form and skills are valid
    Map<String, dynamic> data = {
      'customer_name': _customerNameController.text.trim(),
      'customer_email': _customerEmailController.text.trim(),
      'customer_phone': _customerPhoneController.text.trim(),
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'project_location': _projectLocationController.text.trim(),
      'budget': _budgetController.text.trim(),
      'timeline_start': _timelineStartController.text.trim(),
      'timeline_end': _timelineEndController.text.trim(),
      'urgency': _urgency!,
      'customer_location': _customerLocationController.text.trim(),
      'specialization': _specializationController.text.trim(),
      'required_skills': _requiredSkills.join(','),
    };
    (widget.post != null)
        ? context.read<AddEditPostCubit>().addPost(data)
        : context.read<AddEditPostCubit>().editPost(data, "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post == null ? 'Create Project' : 'Edit Project'),
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
                Text(
                  widget.post == null ? 'Post a New Project' : 'Edit Project',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.post == null
                      ? 'Fill in the details to post your project'
                      : 'Update the project details',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _customerNameController,
                  decoration: const InputDecoration(
                    labelText: 'Customer Name',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: _validator.validateName,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _customerEmailController,
                  decoration: const InputDecoration(
                    labelText: 'Customer Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: _validator.validateEmail,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _customerPhoneController,
                  decoration: const InputDecoration(
                    labelText: 'Customer Phone',
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: _validator.validatePhone,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Project Title',
                    prefixIcon: Icon(Icons.title),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a project title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Project Description',
                    prefixIcon: Icon(Icons.description),
                  ),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _projectLocationController,
                  decoration: const InputDecoration(
                    labelText: 'Project Location',
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a location';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _budgetController,
                  decoration: const InputDecoration(
                    labelText: 'Budget (INR)',
                    prefixIcon: Icon(Icons.money),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a budget';
                    }
                    final num? budget = num.tryParse(value);
                    if (budget == null || budget <= 0) {
                      return 'Please enter a valid budget amount';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _timelineStartController,
                  decoration: const InputDecoration(
                    labelText: 'Timeline Start',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () => _selectDate(context, _timelineStartController),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please select a start date';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _timelineEndController,
                  decoration: const InputDecoration(
                    labelText: 'Timeline End',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () => _selectDate(context, _timelineEndController),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please select an end date';
                    }
                    // Optional: validate that end date is after start date
                    final start =
                        DateTime.tryParse(_timelineStartController.text);
                    final end = DateTime.tryParse(value);
                    if (start != null && end != null && end.isBefore(start)) {
                      return 'End date must be after start date';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _urgency,
                  decoration: InputDecoration(
                    labelText: 'Urgency',
                    prefixIcon: const Icon(Icons.priority_high),
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  items: ['Low', 'Medium', 'High']
                      .map((urgency) => DropdownMenuItem(
                            value: urgency.toLowerCase(),
                            child: Text(urgency),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _urgency = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select urgency';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _customerLocationController,
                  decoration: const InputDecoration(
                    labelText: 'Customer Location',
                    prefixIcon: Icon(Icons.location_city),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter customer location';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _specializationController,
                  decoration: const InputDecoration(
                    labelText: 'Specialization',
                    prefixIcon: Icon(Icons.work),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter specialization';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Required Skills',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: _availableSkills.map((skill) {
                    final isSelected = _requiredSkills.contains(skill);
                    return FilterChip(
                      label: Text(skill),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _requiredSkills.add(skill);
                          } else {
                            _requiredSkills.remove(skill);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: BlocConsumer<AddEditPostCubit, AddEditPostState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: state is AddEditPostLoading
                            ? CircularProgressIndicator(
                                color: Colors.white,
                          strokeWidth: 1,
                              )
                            : Text(
                                widget.post == null
                                    ? 'Create Post'
                                    : 'Update Post',
                                style: const TextStyle(fontSize: 16),
                              ),
                      );
                    },
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
