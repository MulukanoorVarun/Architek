import 'dart:io';
import 'package:flutter_touch_ripple/flutter_touch_ripple.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tripfin/Block/Logic/GetTrip/GetTripCubit.dart';
import 'package:tripfin/Block/Logic/GetTrip/GetTripState.dart';
import 'package:tripfin/Block/Logic/Home/HomeState.dart';
import 'package:tripfin/Block/Logic/PostTrip/potTrip_state.dart';
import 'package:tripfin/Screens/Components/CustomSnackBar.dart';
import 'package:tripfin/Screens/Components/FilteringDate.dart';

import '../../Block/Logic/Home/HomeCubit.dart';
import '../../Block/Logic/Internet/internet_status_bloc.dart';
import '../../Block/Logic/Internet/internet_status_state.dart';
import '../../Block/Logic/PostTrip/postTrip_cubit.dart';
import '../../utils/color_constants.dart';
import '../../utils/spinkittsLoader.dart';
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
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
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
    return BlocListener<InternetStatusBloc, InternetStatusState>(
      listener: (context, state) {
        if (state is InternetStatusLostState) {
          context.push('/no_internet');
        } else {
          context.pop();
        }
      },
      child: BlocBuilder<HomeCubit, HomeState>(
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                context.push('/profile_screen');
                              },
                              borderRadius: BorderRadius.circular(
                                width * 0.05,
                              ), // Match CircleAvatar radius
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl:
                                      state.profileModel.data?.image ?? '',
                                  width: width * 0.1, // Set consistent width
                                  height: width * 0.1, // Set consistent height
                                  fit: BoxFit.cover,
                                  imageBuilder:
                                      (context, imageProvider) => CircleAvatar(
                                        radius:
                                            width * 0.05, // Consistent radius
                                        backgroundImage: imageProvider,
                                      ),
                                  placeholder:
                                      (context, url) => CircleAvatar(
                                        radius: width * 0.05,
                                        child: Center(
                                          child:
                                              spinkits
                                                  .getSpinningLinespinkit(), // Ensure spinner fits
                                        ),
                                      ),
                                  errorWidget:
                                      (context, url, error) => CircleAvatar(
                                        radius: width * 0.05,
                                        backgroundImage: const AssetImage(
                                          'assets/placeholder.png',
                                        ),
                                      ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Text(
                                "Hey ${state.profileModel.data?.fullName ?? "Unknown"}",
                                style: TextStyle(
                                  color: Color(0xffFEFEFE),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Mullish',
                                ),
                                overflow:
                                    TextOverflow
                                        .ellipsis, // Prevent text overflow
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
                              color: Color(0xffFFFFFF),
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Mullish',
                            ),
                          ),
                          SizedBox(height: height * 0.02),
                          _buildTextField(
                            image: 'assets/NavigationArrow.png',
                            controller: destinationController,
                            hint: 'Enter destination',
                            errorText: destinationError,
                          ),
                          SizedBox(height: height * 0.015),
                          _buildTextField(
                            controller: dateController,
                            hint: 'Start date',
                            image: 'assets/CalendarDots.png',
                            readOnly: true,
                            onTap: () => _selectDate(context),
                            errorText: dateError,
                          ),
                          SizedBox(height: height * 0.015),
                          _buildTextField(
                            image: 'assets/CurrencyInr.png',
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            keyboardType: TextInputType.numberWithOptions(
                              decimal: false,
                              signed: false,
                            ),
                            controller: budgetController,
                            hint: 'Enter spend amount',
                            errorText: budgetError,
                          ),
                          // SizedBox(height: height * 0.015),
                          // _selectedImage == null
                          //     ? InkWell(
                          //       onTap: () {
                          //         showModalBottomSheet(
                          //           backgroundColor: primary,
                          //           context: context,
                          //           builder: (BuildContext context) {
                          //             return SafeArea(
                          //               child: Wrap(
                          //                 children: <Widget>[
                          //                   ListTile(
                          //                     leading: Icon(
                          //                       Icons.camera_alt,
                          //                       color: Colors.white,
                          //                     ),
                          //                     title: Text(
                          //                       'Upload Image for Trip',
                          //                       style: TextStyle(
                          //                         color: Colors.white,
                          //                         fontFamily: 'Mullish',
                          //                         fontWeight: FontWeight.w400,
                          //                         fontSize: 15,
                          //                       ),
                          //                     ),
                          //                     onTap: () {
                          //                       _pickImage(ImageSource.camera);
                          //                       context.pop();
                          //                     },
                          //                   ),
                          //                   ListTile(
                          //                     leading: Icon(
                          //                       Icons.photo_library,
                          //                       color: Colors.white,
                          //                     ),
                          //                     title: Text(
                          //                       'Choose from gallery',
                          //                       style: TextStyle(
                          //                         color: Colors.white,
                          //                         fontFamily: 'Mullish',
                          //                         fontWeight: FontWeight.w400,
                          //                         fontSize: 15,
                          //                       ),
                          //                     ),
                          //                     onTap: () {
                          //                       _pickImage(ImageSource.gallery);
                          //                       context.pop();
                          //                     },
                          //                   ),
                          //                 ],
                          //               ),
                          //             );
                          //           },
                          //         );
                          //       },
                          //       child: Container(
                          //         width: width,
                          //         padding: EdgeInsets.symmetric(
                          //           horizontal: 12.0,
                          //           vertical: 14,
                          //         ),
                          //         decoration: BoxDecoration(
                          //           border: Border.all(
                          //             color: Colors.grey.shade600,
                          //             width: 1.0,
                          //           ),
                          //           borderRadius: BorderRadius.circular(30),
                          //         ),
                          //         child: Text(
                          //           'Upload File',
                          //           style: TextStyle(
                          //             color: Colors.white70,
                          //             fontSize: 16.0,
                          //             fontWeight: FontWeight.w500,
                          //             fontFamily: 'Mullish',
                          //           ),
                          //         ),
                          //       ),
                          //     )
                          //     : Stack(
                          //       children: [
                          //         ClipRRect(
                          //           borderRadius: BorderRadius.circular(8),
                          //           child: Image.file(
                          //             _selectedImage!,
                          //             height: 80,
                          //             width: 80,
                          //             fit: BoxFit.cover,
                          //           ),
                          //         ),
                          //         Positioned(
                          //           top: 0,
                          //           right: 0,
                          //           child: GestureDetector(
                          //             onTap: () {
                          //               setState(() {
                          //                 _selectedImage = null;
                          //               });
                          //             },
                          //             child: Container(
                          //               decoration: BoxDecoration(
                          //                 color: Colors.black.withOpacity(0.6),
                          //                 shape: BoxShape.circle,
                          //               ),
                          //               child: Icon(
                          //                 Icons.close,
                          //                 color: Colors.white,
                          //                 size: 18,
                          //               ),
                          //             ),
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          SizedBox(height: height * 0.025),
                          BlocConsumer<postTripCubit, postTripState>(
                            listener: (context, state) {
                              if (state is PostTripSuccessState) {
                                destinationController.clear();
                                dateController.clear();
                                budgetController.clear();
                                context.read<HomeCubit>().fetchHomeData();
                              }
                            },
                            builder: (context, state) {
                              return CustomAppButton1(
                                isLoading: state is PostTripLoading,
                                text: "Start Your Trip",
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
                                    context.read<postTripCubit>().postTrip(
                                      data,
                                    );
                                  } else {
                                    CustomSnackBar.show(
                                      context,
                                      'Please fix the errors in the form',
                                    );
                                  }
                                },
                              );
                            },
                          ),
                          SizedBox(height: height * 0.035),
                        ],
                        Text(
                          "Current Tour",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Mullish',
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
                          Dismissible(
                            key: Key(
                              state.getTripModel.data?.id ?? '',
                            ), // Use a consistent key
                            background: Container(
                              color: Colors.blue,
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: 20),
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            secondaryBackground: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(right: 20),
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            confirmDismiss: (direction) async {
                              final tripId = state.getTripModel.data?.id ?? '';
                              if (direction == DismissDirection.startToEnd) {
                                context.push(
                                  '/UpdateCurrentTrip?tripId=$tripId',
                                );
                                return false;
                              } else if (direction ==
                                  DismissDirection.endToStart) {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder:
                                      (context) => AlertDialog(
                                        title: Text('Delete Trip'),
                                        content: Text(
                                          'Are you sure you want to delete this trip?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => context.pop(false),
                                            child: Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              context.pop(true);
                                            },
                                            child: Text('Delete'),
                                          ),
                                        ],
                                      ),
                                );

                                if (confirm == true) {
                                  try {
                                    await context
                                        .read<postTripCubit>()
                                        .deleteTrip(tripId);
                                    await context
                                        .read<HomeCubit>()
                                        .fetchHomeData();
                                    return true;
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Failed to delete trip: $e',
                                        ),
                                      ),
                                    );
                                    return false;
                                  }
                                }

                                return false;
                              }

                              return false;
                            },
                            child: TouchRipple(
                              onTap: () {
                                final trip = state.getTripModel.data;
                                final budget =
                                    trip?.budget?.toString() ?? "0.00";

                                if (state.getTripModel.totalExpense > 0) {
                                  context.push('/vacation?budget=$budget');
                                } else {
                                  context.push(
                                    '/update_expensive?id=${trip?.id ?? ''}&place=${trip?.destination ?? ''}&budget=$budget',
                                  );
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Color(0xFF304546),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
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
                                            capitalize(
                                              state
                                                      .getTripModel
                                                      .data
                                                      ?.destination ??
                                                  "Unknown",
                                            ),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Mullish',
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          SizedBox(height: 6),
                                          Text(
                                            state
                                                    .getTripModel
                                                    .data
                                                    ?.startDate ??
                                                "N/A",
                                            style: TextStyle(
                                              color: Color(0xffDADADA),
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Mullish',
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 6),
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: "Budget: ",
                                                  style: TextStyle(
                                                    color: Color(0xffB8B8B8),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: 'Mullish',
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      '₹ ${state.getTripModel.data?.budget?.toString() ?? "0.00"}',
                                                  style: TextStyle(
                                                    color: Color(0xff00AB03),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: 'Mullish',
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
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        final trip = state.getTripModel.data;
                                        context.push(
                                          '/update_expensive?id=${trip?.id ?? ''}&place=${trip?.destination ?? ''}&budget=${trip?.budget ?? ''}',
                                        );
                                      },
                                      icon: Icon(
                                        Icons.add,
                                        color: Colors.black87,
                                        size: 16,
                                      ),
                                      label: Text(
                                        "Spend",
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: width * 0.04,
                                          fontFamily: 'Mullish',
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        visualDensity: VisualDensity.compact,
                                        backgroundColor: Color(0xFFDDA25F),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        SizedBox(height: height * 0.03),
                        Text(
                          "Previous Tours",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Mullish',
                          ),
                        ),
                        SizedBox(height: 12),
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
                                      fontFamily: 'Mullish',
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
                                    itemBuilder: (context, index) {final trip = state.getPrevousTripModel.previousTrips![index];
                                      return TouchRipple(
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
                                            bottom: 16,
                                          ),
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Color(0xFF304546),
                                            borderRadius: BorderRadius.circular(
                                              12,
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
                                                      capitalize(
                                                        trip.destination ?? "",
                                                      ),

                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontFamily: 'Mullish',
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ),
                                                    SizedBox(height: 6),
                                                    Text(
                                                      trip.startDate ?? "",
                                                      style: TextStyle(
                                                        color: Color(
                                                          0xffDADADA,
                                                        ),
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontFamily: 'Mullish',
                                                      ),
                                                    ),
                                                    SizedBox(height: 6),
                                                    RichText(
                                                      text: TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text: "Budget: ",
                                                            style: TextStyle(
                                                              color: Color(
                                                                0xffB8B8B8,
                                                              ),
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontFamily:
                                                                  'Mullish',
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text:
                                                                '₹ ' +
                                                                    trip.budget
                                                                        .toString() ??
                                                                "",
                                                            style: TextStyle(
                                                              color: Color(
                                                                0xff00AB03,
                                                              ),
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontFamily:
                                                                  'Mullish',
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
                                                width: width * 0.25,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      textAlign:
                                                          TextAlign.center,
                                                      '₹ ' +
                                                              trip.totalExpense
                                                                  .toString() ??
                                                          "",
                                                      style: TextStyle(
                                                        color: Color(
                                                          0xffb0b0b0,
                                                        ),
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontFamily: 'Mullish',
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
                                                        fontFamily: 'Mullish',
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
                  fontFamily: 'Mullish',
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
                fontFamily: 'Mullish',
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    IconData? icon,
    String? image,
    bool readOnly = false,
    VoidCallback? onTap,
    String? errorText,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          style: const TextStyle(color: Colors.white, fontFamily: 'Mullish'),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 20,
            ),
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF676767)),
            // Only one of suffixIcon or icon should be used
            suffixIcon:
                image != null
                    ? Padding(
                      padding: const EdgeInsets.all(
                        12.0,
                      ), // Add padding for better appearance
                      child: Image.asset(
                        image,
                        color: Color(0xFFD6D6D6),
                        height: 24,
                        width: 24,
                        fit: BoxFit.cover,
                      ),
                    )
                    : (icon != null ? Icon(icon, color: Colors.white70) : null),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32),
              borderSide: const BorderSide(
                color: Color(0xFF575757),
                width: 0.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32),
              borderSide: const BorderSide(
                color: Color(0xFF575757),
                width: 0.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32),
              borderSide: const BorderSide(color: Colors.white, width: 1),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32),
              borderSide: const BorderSide(color: Colors.redAccent, width: 0.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1),
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 12.0),
            child: Text(
              errorText,
              style: const TextStyle(
                color: Colors.redAccent,
                fontSize: 12.0,
                fontFamily: 'Mullish', // Fixed typo in fontFamily
              ),
            ),
          ),
      ],
    );
  }
}
