import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tripfin/Block/Logic/UpdateProfile/Updateprofile_cubit.dart';
import 'package:tripfin/Block/Logic/UpdateProfile/Updateprofile_state.dart';


import '../../Block/Logic/Profiledetails/Profile_cubit.dart';
import '../../Block/Logic/Profiledetails/Profile_state.dart';
import '../Components/CustomAppButton.dart'; // Adjust import for CustomAppButton1
class Editprofilescreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<Editprofilescreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().GetProfile();
  }

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  File? _image;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _takePhoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }
  Future<void> profileUpdate() async {
    final formData = FormData.fromMap({
      "full_name": _nameController.text,
      "email": _emailController.text,
      "status": "Active",
      "mobile": _phoneController.text,
      if (_image != null)
        "image": await MultipartFile.fromFile(
          _image!.path,
          filename: _image!.path.split('/').last,
        ),
    });
    print('FormData files: ${formData.files}');
    if (_image != null) {
      print('Image path: ${_image!.path}');
      if (await _image!.exists()) {
        print('Image file exists');
      } else {
        print('Image file does not exist');
      }
    }
    print('Calling UpdateprofileCubit with FormData');
    context.read<UpdateprofileCubit>().Updateprofile(formData);
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UpdateprofileCubit, UpdateprofileState>(
      listener: (context, updateState) {
        if (updateState is UpdateProfileSuccessState) {
          print('UI: Showing success - ${updateState.message}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(updateState.message)),
          );
        } else if (updateState is UpdateProfileError) {
          print('UI: Showing error - ${updateState.message}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(updateState.message)),
          );
        }
      },
      builder: (context, updateState) {
        return BlocBuilder<ProfileCubit, GetProfileState>(
          builder: (context, profileState) {
            if (profileState is GetProfileLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (profileState is GetProfileLoaded) {
              _nameController.text = profileState.getprofileModel.data?.fullName ?? "";
              _emailController.text = profileState.getprofileModel.data?.email ?? "";
              _phoneController.text = profileState.getprofileModel.data?.mobile ?? "";
              return Scaffold(
                backgroundColor: Color(0xff304546),
                appBar: AppBar(
                  backgroundColor: Color(0xff304546),
                  title: Text('Edit Profile'),
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Profile Picture
                        Center(
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundImage: _image != null
                                    ? FileImage(_image!)
                                    : AssetImage('assets/profile_placeholder.png') as ImageProvider,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (_) {
                                        return Container(
                                          color: Colors.white,
                                          height: 120,
                                          child: Column(
                                            children: [
                                              ListTile(
                                                leading: Icon(Icons.photo_library),
                                                title: Text('Gallery'),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  _pickImageFromGallery();
                                                },
                                              ),
                                              ListTile(
                                                leading: Icon(Icons.camera_alt),
                                                title: Text('Camera'),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  _takePhoto();
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.amber,
                                    child: Icon(Icons.edit, color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        // Name Field
                        _buildTextField("Name", _nameController),
                        SizedBox(height: 20),
                        // Email Field
                        _buildTextField("Email", _emailController),
                        SizedBox(height: 20),
                        // Phone Field
                        _buildTextField("Mobile Number", _phoneController),
                        SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
                bottomNavigationBar: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 80),
                  child: CustomAppButton1(
                    height: 56,
                    text: 'Save Changes',
                    onPlusTap: updateState is UpdateProfileLoading
                        ? null
                        : () {
                      profileUpdate();
                    },
                  ),
                ),
              );
            } else if (profileState is GetProfileError) {
              return Center(child: Text(profileState.message));
            }
            return Center(child: Text("No Data"));
          },
        );
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      cursorColor: Color(0xff898989),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Color(0xff898989), fontFamily: 'Mullish'),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xff898989), width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xff898989), width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}