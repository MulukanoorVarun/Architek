import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tripfin/Block/Logic/GetTrip/GetTripCubit.dart';
import 'package:tripfin/Block/Logic/GetTrip/GetTripState.dart';
import 'package:tripfin/Block/Logic/Home/HomeState.dart';

import '../../Block/Logic/Home/HomeCubit.dart';
import '../../Block/Logic/PostTrip/postTrip_cubit.dart';
import '../Components/CustomAppButton.dart';

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
  File? selectedImage;
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
                      if (state.getTripModel.getTripData == null ||
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
                        ),
                        SizedBox(height: height * 0.015),
                        _buildTextField(
                          controller: dateController,
                          hint: 'Select date',
                          icon: Icons.calendar_today,
                          readOnly: true,
                          onTap: () => _selectDate(context),
                        ),
                        SizedBox(height: height * 0.015),
                        _buildTextField(
                          controller: budgetController,
                          hint: 'enter spend amount',
                        ),
                        SizedBox(height: height * 0.015),

                        selectedImage != null
                            ? Container(
                          height: height * 0.2,
                          width: width * 0.9,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: FileImage(selectedImage!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                            : Container(
                          height: height * 0.2,
                          width: width * 0.9,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade800,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              "No image selected",
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                        ),

                        SizedBox(height: height * 0.025),
                        CustomAppButton1(text: "Start Your Tour", onPlusTap: (){

                          final Map<String, dynamic> data = {
                            'destination': destinationController.text,
                            'start_date': dateController.text,
                            'budget': budgetController.text,
                            'image':  selectedImage!.path,

                          };
                          context.read<postTripCubit>().postTrip(data);

                        }),
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
                      if (state.getTripModel.getTripData==null || state.getTripModel.settings?.message ==
                              "No active and ongoing trips found.")
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(width * 0.04),
                          decoration: BoxDecoration(
                            color: Color(0xFF2C4748),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text( "No current tour found",style: TextStyle(fontFamily: 'Mullish',fontWeight: FontWeight.w500,fontSize: 16,color: Colors.white),),
                        )
                      else
                        InkResponse(
                          onTap: () {
                            context.push(
                              '/vacation?budget=${state.getTripModel.getTripData?.budget?.toString() ?? "0.00"}&place=${state.getTripModel.getTripData?.destination ?? "Unknown"}',
                            );
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
                                        state
                                                .getTripModel
                                                .getTripData
                                                ?.destination ??
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
                                        state
                                                .getTripModel
                                                .getTripData
                                                ?.startDate ??
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
                                                      .getTripData
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
                                SizedBox(width: width * 0.02),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    context.push(
                                      '/update_expensive?id=${state.getTripModel.getTripData?.id ??''}&place=${state.getTripModel.getTripData?.destination ?? ''}&budget=${state.getTripModel.getTripData?.budget ?? ''}',
                                    );
                                  },
                                  icon: Icon(
                                    Icons.add,
                                    color: Colors.black87,
                                    size: width * 0.045,
                                  ),
                                  label: Text(
                                    "Add Spends",
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

                                child:     noDataWidget(context, "No previous tours found."),
                                // Text(
                                //   "No Previous tour found.",
                                //   style: TextStyle(
                                //     color: Colors.white70,
                                //     fontSize: width * 0.04,
                                //     fontFamily: 'Mulish',
                                //   ),
                                // ),
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
                                    return Container(
                                      margin: EdgeInsets.only(
                                        bottom: width * 0.035,
                                      ),
                                      padding: EdgeInsets.all(width * 0.035),
                                      decoration: BoxDecoration(
                                        color: Color(0xFF2C4748),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
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
                                                    fontWeight: FontWeight.bold,
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
                                                          color: Colors.white60,
                                                          fontSize:
                                                              width * 0.04,
                                                          fontFamily: 'Mulish',
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
                                                          fontFamily: 'Mulish',
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
                                                    fontWeight: FontWeight.bold,
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
  Widget noDataWidget(BuildContext context, String message) {
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Image.asset(
          "assets/nodata_image.png",
          width: width * 0.5,
        ),
        SizedBox(height: 12),
        Text(
          message,
          style: TextStyle(
            color: Colors.white70,
            fontSize: width * 0.045,
            fontFamily: 'Mulish',
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    IconData? icon,
    TextInputType inputType = TextInputType.text,
    int maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      maxLines: maxLines,
      readOnly: readOnly,
      onTap: onTap,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white70),
        prefixIcon: icon != null ? Icon(icon, color: Colors.white70) : null,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade600),
          borderRadius: BorderRadius.circular(30),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.orangeAccent),
          borderRadius: BorderRadius.circular(30),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
  Widget _customTextField({
    required String hint,
    required IconData icon,
    required BuildContext context,
  }) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF0F292F),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Color(0xFF3E5C5C)),
      ),
      child: TextField(
        style: TextStyle(color: Colors.white, fontFamily: 'Mulish'),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Color(0xFF7C9D9D), fontFamily: 'Mulish'),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: width * 0.05,
            vertical: 18,
          ),
          suffixIcon: Icon(icon, color: Color(0xFF7C9D9D)),
        ),
      ),
    );
  }
}
