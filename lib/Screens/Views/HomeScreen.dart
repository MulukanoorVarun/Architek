import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tripfin/Block/Logic/GetTrip/GetTripCubit.dart';
import 'package:tripfin/Block/Logic/GetTrip/GetTripState.dart';
import 'package:tripfin/Block/Logic/Home/HomeState.dart';
import 'package:tripfin/Block/Logic/PostTrip/potTrip_state.dart';
import 'package:tripfin/Screens/Components/CustomSnackBar.dart';

import '../../Block/Logic/Home/HomeCubit.dart';
import '../../Block/Logic/PostTrip/postTrip_cubit.dart';
import '../../utils/color_constants.dart';
import '../Components/CustomAppButton.dart';
import '../Components/ShakeWidget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().fetchHomeData();
  }

  TextEditingController dateController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController budgetController = TextEditingController();
  File? _selectedImage;
  String? destinationError;
  String? dateError;
  String? budgetError;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    } else {}
  }

  bool _validateInputs() {
    bool isValid = true;
    setState(() {
      // Destination validation
      if (destinationController.text.trim().isEmpty) {
        destinationError = "Destination is required";
        isValid = false;
      } else if (destinationController.text.trim().length < 2) {
        destinationError = "Destination must be at least 2 characters";
        isValid = false;
      } else {
        destinationError = null;
      }

      // Date validation
      if (dateController.text.trim().isEmpty) {
        dateError = "Date is required";
        isValid = false;
      } else {
        dateError = null;
      }

      // Budget validation
      if (budgetController.text.trim().isEmpty) {
        budgetError = "Budget is required";
        isValid = false;
      } else {
        final budget = double.tryParse(budgetController.text.trim());
        if (budget == null || budget <= 0) {
          budgetError = "Enter a valid positive amount";
          isValid = false;
        } else {
          budgetError = null;
        }
      }
    });
    return isValid;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      dateController.text = formattedDate;
    }
  }

  Future<void> _onRefresh() async {
    await context.read<HomeCubit>().fetchHomeData();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is HomeLoaded) {
          return Scaffold(
            backgroundColor: const Color(0xFF0F292F),
            body: RefreshIndicator(
              onRefresh: _onRefresh,
              color: Color(0xFFF4A261),
              backgroundColor: Color(0xFF0F292F),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.05,
                    vertical: height * 0.02,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          InkResponse(
                            onTap: () {
                              context.push('/profile_screen');
                            },
                            child: CircleAvatar(
                              radius: width * 0.07,
                              backgroundImage: AssetImage("assets/profile.png"),
                            ),
                          ),
                          SizedBox(width: width * 0.03),
                          Text(
                            state.profileModel.data?.fullName ?? "Unknown",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: width * 0.06,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Mulish',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.03),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          "assets/figmaimages.png",
                          width: double.infinity,
                          height: height * 0.25,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: height * 0.03),
                      if (state.getTripModel.data == null ||
                          state.getTripModel.settings?.message ==
                              "No active and ongoing trips found.") ...[
                        Text(
                          "Travel Details",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: width * 0.055,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Mulish',
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        _buildTextField(
                          controller: destinationController,
                          hint: 'Where you travel',
                          errorText: destinationError,
                        ),
                        SizedBox(height: height * 0.015),
                        _buildTextField(
                          controller: dateController,
                          hint: 'Select date',
                          icon: Icons.calendar_today,
                          readOnly: true,
                          onTap: () => _selectDate(context),
                          errorText: dateError,
                        ),
                        SizedBox(height: height * 0.015),
                        _buildTextField(
                          controller: budgetController,
                          hint: 'Enter spend amount',
                          errorText: budgetError,
                        ),
                        SizedBox(height: height * 0.015),
                        _selectedImage == null
                            ? InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                  backgroundColor: primary,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SafeArea(
                                      child: Wrap(
                                        children: <Widget>[
                                          ListTile(
                                            leading: Icon(
                                              Icons.camera_alt,
                                              color: Colors.white,
                                            ),
                                            title: Text(
                                              'Upload Image for Trip',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Mullish',
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15,
                                              ),
                                            ),
                                            onTap: () {
                                              _pickImage(ImageSource.camera);
                                              context.pop();
                                            },
                                          ),
                                          ListTile(
                                            leading: Icon(
                                              Icons.photo_library,
                                              color: Colors.white,
                                            ),
                                            title: Text(
                                              'Choose from gallery',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Mullish',
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15,
                                              ),
                                            ),
                                            onTap: () {
                                              _pickImage(ImageSource.gallery);
                                              context.pop();
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                width: width,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade600,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  'Upload File',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Mullish',
                                  ),
                                ),
                              ),
                            )
                            : Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    _selectedImage!,
                                    height: 80,
                                    width: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedImage = null;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.6),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        SizedBox(height: height * 0.025),
                        BlocListener<postTripCubit, postTripState>(
                          listener: (context, state) {
                            if (state is PostTripSuccessState) {
                              context.read<HomeCubit>().fetchHomeData();
                            }
                          },
                          child: CustomAppButton1(
                            isLoading: state is PostTripLoading,
                            text: "Start Your Tour",
                            onPlusTap: () {
                              if (_validateInputs()) {
                                final Map<String, dynamic> data = {
                                  'destination': destinationController.text,
                                  'start_date': dateController.text,
                                  'budget': budgetController.text,
                                };
                                if (_selectedImage != null) {
                                  data['image'] = _selectedImage;
                                }
                                context.read<postTripCubit>().postTrip(data);
                              } else {
                                CustomSnackBar.show(
                                  context,
                                  'Please fix the errors in the form',
                                );
                              }
                            },
                          ),
                        ),
                        SizedBox(height: height * 0.035),
                      ],
                      Text(
                        "Current Tour",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: width * 0.053,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Mulish',
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      if (state.getTripModel.data == null ||
                          state.getTripModel.settings?.message ==
                              "No active and ongoing trips found.")
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(width * 0.04),
                          decoration: BoxDecoration(
                            color: Color(0xFF2C4748),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            "No current tour found",
                            style: TextStyle(
                              fontFamily: 'Mullish',
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        )
                      else
                        InkResponse(
                          onTap: () {
                            if (state.getTripModel.totalExpense > 0) {
                              context.push(
                                '/vacation?budget=${state.getTripModel.data?.budget?.toString() ?? "0.00"}',
                              );
                            } else {
                              context.push(
                                '/update_expensive?id=${state.getTripModel.data?.id ?? ''}&place=${state.getTripModel.data?.destination ?? ''}&budget=${state.getTripModel.data?.budget ?? ''}',
                              );
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(width * 0.035),
                            decoration: BoxDecoration(
                              color: Color(0xFF2C4748),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(4),
                                  color: Color(0xff53676833),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(14),
                                    child: Image.asset(
                                      "assets/figmaimages.png",
                                      width: width * 0.15,
                                      height: width * 0.15,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: width * 0.035),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        state.getTripModel.data?.destination ??
                                            "Unknown",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: width * 0.05,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Mulish',
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      SizedBox(height: 6),
                                      Text(
                                        state.getTripModel.data?.startDate ??
                                            "N/A",
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: width * 0.035,
                                          fontFamily: 'Mulish',
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      SizedBox(height: 6),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "Budget: ",
                                              style: TextStyle(
                                                color: Colors.white60,
                                                fontSize: width * 0.04,
                                                fontFamily: 'Mulish',
                                              ),
                                            ),
                                            TextSpan(
                                              text:
                                                  state
                                                      .getTripModel
                                                      .data
                                                      ?.budget
                                                      ?.toString() ??
                                                  "0.00",
                                              style: TextStyle(
                                                color: Colors.greenAccent,
                                                fontSize: width * 0.04,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Mulish',
                                              ),
                                            ),
                                          ],
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 50),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    context.push(
                                      '/update_expensive?id=${state.getTripModel.data?.id ?? ''}&place=${state.getTripModel.data?.destination ?? ''}&budget=${state.getTripModel.data?.budget ?? ''}',
                                    );
                                  },
                                  icon: Icon(
                                    Icons.add,
                                    color: Colors.black87,
                                    size: width * 0.045,
                                  ),
                                  label: Text(
                                    "Spends",
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: width * 0.04,
                                      fontFamily: 'Mulish',
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    visualDensity: VisualDensity.compact,
                                    backgroundColor: Color(0xFFF4A261),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.025,
                                      vertical: width * 0.035,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      SizedBox(height: height * 0.03),
                      Text(
                        "Previous Tours",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: width * 0.053,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Mulish',
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            if (state
                                    .getPrevousTripModel
                                    .previousTrips
                                    ?.length ==
                                0)
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(width * 0.04),
                                decoration: BoxDecoration(
                                  color: Color(0xFF2C4748),
                                  borderRadius: BorderRadius.circular(16),
                                ),

                                child: Text(
                                  "No Previous tour found.",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: width * 0.04,
                                    fontFamily: 'Mulish',
                                  ),
                                ),
                              )
                            else
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                child: ListView.builder(
                                  itemCount:
                                      state
                                          .getPrevousTripModel
                                          .previousTrips
                                          ?.length ??
                                      0,
                                  itemBuilder: (context, index) {
                                    final trip =
                                        state
                                            .getPrevousTripModel
                                            .previousTrips![index];
                                    return InkResponse(
                                      onTap: () {
                                        final trip =
                                            state
                                                .getPrevousTripModel
                                                .previousTrips?[index];
                                        if (trip != null) {
                                          context.push(
                                            '/vacation?budget=${trip.budget.toString() ?? "0.00"}&tripId=${trip.tripId ?? ""}',
                                          );
                                        }
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(
                                          bottom: width * 0.035,
                                        ),
                                        padding: EdgeInsets.all(width * 0.035),
                                        decoration: BoxDecoration(
                                          color: Color(0xFF2C4748),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              child: Image.asset(
                                                "assets/figmaimages.png",
                                                width: width * 0.18,
                                                height: width * 0.18,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            SizedBox(width: width * 0.035),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    trip.destination ?? "",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: width * 0.05,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Mulish',
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                  SizedBox(height: 6),
                                                  Text(
                                                    trip.startDate ?? "",
                                                    style: TextStyle(
                                                      color: Colors.white70,
                                                      fontSize: width * 0.035,
                                                      fontFamily: 'Mulish',
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                  SizedBox(height: 6),
                                                  RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: "Budget: ",
                                                          style: TextStyle(
                                                            color:
                                                                Colors.white60,
                                                            fontSize:
                                                                width * 0.04,
                                                            fontFamily:
                                                                'Mulish',
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text:
                                                              trip.budget
                                                                  .toString() ??
                                                              "",
                                                          style: TextStyle(
                                                            color:
                                                                Colors
                                                                    .greenAccent,
                                                            fontSize:
                                                                width * 0.04,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                'Mulish',
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: width * 0.02),
                                            SizedBox(
                                              width: width * 0.18,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    trip.totalExpense
                                                            .toString() ??
                                                        "",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: width * 0.045,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Mulish',
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                  Text(
                                                    "Spends",
                                                    style: TextStyle(
                                                      color: Colors.white70,
                                                      fontSize: width * 0.035,
                                                      fontFamily: 'Mulish',
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else if (state is HomeError) {
          return Center(
            child: Text(
              state.message,
              style: TextStyle(
                color: Colors.white,
                fontSize: width * 0.05,
                fontFamily: 'Mulish',
              ),
            ),
          );
        }
        return Center(
          child: Text(
            "No Data",
            style: TextStyle(
              color: Colors.white,
              fontSize: width * 0.05,
              fontFamily: 'Mulish',
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    IconData? icon,
    bool readOnly = false,
    VoidCallback? onTap,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          style: TextStyle(color: Colors.white, fontFamily: 'Mulish'),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white70),
            suffixIcon: icon != null ? Icon(icon, color: Colors.white70) : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.grey.shade600),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.grey.shade600),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: EdgeInsets.only(top: 4.0, left: 12.0),
            child: Text(
              errorText,
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 12.0,
                fontFamily: 'Mulish',
              ),
            ),
          ),
      ],
    );
  }
}
