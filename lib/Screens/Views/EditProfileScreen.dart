import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tripfin/Block/Logic/UpdateProfile/UpdateProfileState.dart';

import '../../Block/Logic/CombinedProfile/CombinedProfileCubit.dart';
import '../../Block/Logic/Home/HomeCubit.dart';
import '../../Block/Logic/Profiledetails/Profile_cubit.dart';
import '../../Block/Logic/Profiledetails/Profile_state.dart';
import '../../Block/Logic/UpdateProfile/UpdateProfileCubit.dart';
import '../../utils/color_constants.dart';
import '../Components/CustomAppButton.dart';
import '../Components/CutomAppBar.dart';

class Editprofilescreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();

   }
class _EditProfileScreenState extends State<Editprofilescreen> {

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  File? _image;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().GetProfile();
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          print('Image selected: ${_image!.path}');
        });
      } else {
        print('No image selected from gallery');
      }
    } catch (e) {
      print('Error picking image from gallery: $e');
    }
  }

  Future<void> _takePhoto() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          print('Image captured: ${_image!.path}');
        });
      } else {
        print('No image captured from camera');
      }
    } catch (e) {
      print('Error taking photo: $e');
    }
  }

  Future<void> _updateProfile() async {
    try {
      final Map<String, dynamic> data = {
        "full_name": _nameController.text,
        "email": _emailController.text,
        "status": "Active",
        "mobile": _phoneController.text,
        "image": _image,
      };

      data.removeWhere((key, value) => value == null);
      context.read<UpdateProfileCubit>().updateProfile(data);
    } catch (e) {
      print('Error preparing FormData: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return BlocBuilder<ProfileCubit, GetProfileState>(
      builder: (context, profileState) {
        if (profileState is GetProfileLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (profileState is GetProfileLoaded) {
          _nameController.text =
              profileState.getprofileModel.data?.fullName ?? "";
          _emailController.text =
              profileState.getprofileModel.data?.email ?? "";
          _phoneController.text =
              profileState.getprofileModel.data?.mobile ?? "";

          final String? profileImageUrl =
              profileState.getprofileModel.data?.image;
          return Scaffold(
            backgroundColor: primary,
            appBar: CustomAppBar(title: 'Edit Profile', actions: []),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          ClipOval(
                            child: _image != null
                                ? Image.file(
                              _image!,
                              width:150,
                              height: 150,
                              fit: BoxFit.cover,
                            )
                                : CachedNetworkImage(
                              imageUrl: profileState.getprofileModel.data?.image??"",
                              width:120,
                              height: 120,
                              fit: BoxFit.cover,
                              imageBuilder: (context, imageProvider) => CircleAvatar(
                                radius: width * 15, // Matches width/height for circular shape
                                backgroundImage: imageProvider,
                                backgroundColor: Colors.white,
                              ),
                              placeholder: (context, url) => CircleAvatar(
                                radius: width * 0.15,
                                backgroundColor: Colors.white,
                                child: const Center(
                                  child: CircularProgressIndicator(), // From old code
                                ),
                              ),
                            ),
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
                                            leading: const Icon(
                                              Icons.photo_library,
                                            ),
                                            title: const Text('Gallery'),
                                            onTap: () {
                                              Navigator.pop(context);
                                              _pickImageFromGallery();
                                            },
                                          ),


                                          ListTile(
                                            leading: const Icon(
                                              Icons.camera_alt,
                                            ),
                                            title: const Text('Camera'),
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
                              child: const CircleAvatar(
                                radius: 20,
                                backgroundColor: Color(0xFFF4A261),
                                child: Icon(Icons.edit, color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildTextField("Name", _nameController),
                    const SizedBox(height: 20),
                    _buildTextField("Email", _emailController),
                    const SizedBox(height: 20),
                    _buildTextField("Mobile Number", _phoneController),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            bottomNavigationBar:
                BlocConsumer<UpdateProfileCubit, UpdateProfileState>(
                  listener: (context, state) {
                    if (state is UpdateProfileSuccessState) {
                       context.read<HomeCubit>().fetchHomeData();
                       context.read<CombinedProfileCubit>().fetchCombinedProfile();
                      context.pop();
                    }
                  },
                  builder: (context, state) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 80,
                      ),
                      child: CustomAppButton1(
                        isLoading: state is UpdateProfileLoading,
                        height: 56,
                        text: 'Save Changes',
                        onPlusTap: _updateProfile,
                      ),
                    );
                  },
                ),
          );
        } else if (profileState is GetProfileError) {
          return Center(child: Text(profileState.message));
        }
        return const Center(child: Text("No Data"));
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      cursorColor: const Color(0xff898989),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Color(0xff898989),
          fontFamily: 'Mullish',
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xff898989), width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xff898989), width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

}
