import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_touch_ripple/flutter_touch_ripple.dart';
import 'package:go_router/go_router.dart';
import 'package:tripfin/Block/Logic/CombinedProfile/CombinedProfileCubit.dart';
import 'package:tripfin/Block/Logic/CombinedProfile/CombinedProfileState.dart';
import 'package:tripfin/Screens/Components/CustomAppButton.dart';
import 'package:tripfin/Screens/Components/CutomAppBar.dart';
import 'package:tripfin/utils/color_constants.dart';

import '../../utils/Preferances.dart';
import '../../utils/spinkittsLoader.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CombinedProfileCubit>().fetchCombinedProfile();
  }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return Scaffold(
      backgroundColor: primary,
      appBar: CustomAppBar(title: 'Profile', actions: []),
      body: BlocBuilder<CombinedProfileCubit, CombinedProfileState>(
        builder: (context, state) {
          {
            if (state is CombinedProfileLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is CombinedProfileLoaded) {
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: state.profileModel.data?.image ?? '',
                            width: width * 0.15,
                            height: width * 0.15,
                            fit: BoxFit.cover,
                            imageBuilder:
                                (context, imageProvider) => CircleAvatar(
                                  radius: width * 0.05,
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
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 4),
                                        Text(
                                          state.profileModel.data?.fullName ??
                                              "",
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontFamily: "Mullish",
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 6),
                                        Text(
                                          state.profileModel.data?.mobile ?? "",
                                          style: TextStyle(
                                            color: Color(0xffFEFEFE),
                                            fontFamily: "Mullish",
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    visualDensity: VisualDensity.compact,
                                    onPressed: () {
                                      context.push('/edit_profile_screen');
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  TouchRipple(
                                    onTap: () {
                                      context.push('/edit_profile_screen');
                                    },
                                    child: Text(
                                      'Edit',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: "Mullish",
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '',
                                    style: TextStyle(
                                      fontFamily: "Mullish",
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 40),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color(0xff304546),
                        border: Border.all(color: Color(0xff898989), width: 1),
                      ),
                      child: Row(
                        children: [
                          Image.asset('assets/tripTree.png', scale: 3),
                          SizedBox(width: 10),
                          Text(
                            'Your Trips',
                            style: TextStyle(
                              color: Color(0xffB9B9B9),
                              fontFamily: 'Mullish',
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                          Spacer(),
                          Text(
                            state.tripSummaryModel.data.totalPreviousTrips
                                    .toString() ??
                                "",
                            style: TextStyle(
                              color: Color(0xffFEFEFE),
                              fontFamily: 'Mullish',
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color(0xff304546),
                        border: Border.all(color: Color(0xff898989), width: 1),
                      ),
                      child: Row(
                        children: [
                          Image.asset('assets/Money.png', scale: 3),
                          SizedBox(width: 10),
                          Text(
                            'Total Spends',
                            style: TextStyle(
                              color: Color(0xffB9B9B9),
                              fontFamily: 'Mullish',
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                          Spacer(),
                          Text(
                            state.tripSummaryModel.data.totalExpenses
                                    .toString() ??
                                "",
                            style: TextStyle(
                              color: Color(0xffFEFEFE),
                              fontFamily: 'Mullish',
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is CombinedProfileError) {
              return Center(child: Text(state.message));
            }
            return Center(child: Text("No Data"));
          }
        },
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 80),
        child: CustomAppButton1(
          height: 56,
          text: 'Log Out',
          onPlusTap: () {
            _showLogoutConfirmationDialog(context);
          },
        ),
      ),
    );
  }
}

void _showLogoutConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        elevation: 4.0,
        insetPadding: EdgeInsets.symmetric(horizontal: 14.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: SizedBox(
          width: 300.0,
          height: 200.0,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: -35.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  width: 70.0,
                  height: 70.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(width: 6.0, color: Colors.white),
                    shape: BoxShape.circle,
                    color: Colors.red.shade100,
                  ),
                  child: Icon(
                    Icons.power_settings_new,
                    size: 40.0,
                    color: Colors.red,
                  ),
                ),
              ),
              Positioned.fill(
                top: 30.0,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 15.0),
                      Text(
                        "Logout",
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w600,
                          color: primary,
                          fontFamily: "Poppins",
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        "Are you sure you want to logout?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black54,
                          fontFamily: "Poppins",
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 100,
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: primary,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                              ),
                              child: Text(
                                "No",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  fontFamily: "Poppins",
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            child: OutlinedButton(
                              onPressed: () async {
                                await PreferenceService().remove(
                                  "access_token",
                                );
                                context.go("/login_mobile");
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: primary,
                                side: BorderSide(color: primary),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                              ),
                              child: Text(
                                "Yes",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  fontFamily: "Poppins",
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
