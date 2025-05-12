import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tripfin/Block/Logic/GetTrip/GetTripCubit.dart';
import 'package:tripfin/Block/Logic/GetTrip/GetTripState.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GetTripCubit>().GetTrip();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return BlocBuilder<GetTripCubit, GetTripState>(
      builder: (context, state) {
        if (state is GetTripLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is GetTripLoaded) {
          return Scaffold(
            backgroundColor: const Color(0xFF0F292F),
            body: SafeArea(
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
                          "Hey Vikram",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: width * 0.06,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.03),

                    // Map Illustration
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

                    // Travel Details Heading
                    Text(
                      "Travel Details",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: width * 0.055,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: height * 0.02),

                    // Text Fields
                    _customTextField(
                      hint: "Enter Your Destination",
                      icon: Icons.location_city,
                      context: context,
                    ),
                    SizedBox(height: height * 0.015),

                    _customTextField(
                      hint: "Select Starting date",
                      icon: Icons.calendar_month,
                      context: context,
                    ),
                    SizedBox(height: height * 0.015),

                    _customTextField(
                      hint: "Budget",
                      icon: Icons.currency_rupee,
                      context: context,
                    ),
                    SizedBox(height: height * 0.025),

                    // Start Tour Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFF4A261),
                          padding: EdgeInsets.symmetric(
                            vertical: height * 0.02,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        child: Text(
                          "Start Your Tour",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: width * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.035),
                    Text(
                      "Current Tour",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: width * 0.053,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    Container(
                      padding: EdgeInsets.all(width * 0.035),
                      decoration: BoxDecoration(
                        color: Color(0xFF2C4748),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.getTripModel.getTripData?.destination ??
                                      "",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: width * 0.05,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  state.getTripModel.getTripData?.startDate ??
                                      "",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: width * 0.035,
                                  ),
                                ),
                                SizedBox(height: 6),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Budget : ",
                                        style: TextStyle(
                                          color: Colors.white60,
                                          fontSize: width * 0.04,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            state
                                                .getTripModel
                                                .getTripData
                                                ?.budget ??
                                            "",
                                        style: TextStyle(
                                          color: Colors.greenAccent,
                                          fontSize: width * 0.04,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {},
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

                    SizedBox(height: height * 0.03),

                    Text(
                      "Previous Tours",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: width * 0.053,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    Container(
                      margin: EdgeInsets.only(bottom: width * 0.035),
                      padding: EdgeInsets.all(width * 0.035),
                      decoration: BoxDecoration(
                        color: Color(0xFF2C4748),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Red Fort",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: width * 0.05,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "06 Apr 2025",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: width * 0.035,
                                  ),
                                ),
                                SizedBox(height: 6),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Budget : ",
                                        style: TextStyle(
                                          color: Colors.white60,
                                          fontSize: width * 0.04,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "50,000",
                                        style: TextStyle(
                                          color: Colors.greenAccent,
                                          fontSize: width * 0.04,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "30,000",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: width * 0.045,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Spends",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: width * 0.035,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: width * 0.035),
                      padding: EdgeInsets.all(width * 0.035),
                      decoration: BoxDecoration(
                        color: Color(0xFF2C4748),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Red Fort",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: width * 0.05,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "06 Apr 2025",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: width * 0.035,
                                  ),
                                ),
                                SizedBox(height: 6),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Budget : ",
                                        style: TextStyle(
                                          color: Colors.white60,
                                          fontSize: width * 0.04,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "50,000",
                                        style: TextStyle(
                                          color: Colors.greenAccent,
                                          fontSize: width * 0.04,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "30,000",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: width * 0.045,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Spends",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: width * 0.035,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: width * 0.035),
                      padding: EdgeInsets.all(width * 0.035),
                      decoration: BoxDecoration(
                        color: Color(0xFF2C4748),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Red Fort",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: width * 0.05,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "06 Apr 2025",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: width * 0.035,
                                  ),
                                ),
                                SizedBox(height: 6),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Budget : ",
                                        style: TextStyle(
                                          color: Colors.white60,
                                          fontSize: width * 0.04,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "50,000",
                                        style: TextStyle(
                                          color: Colors.greenAccent,
                                          fontSize: width * 0.04,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "30,000",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: width * 0.045,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Spends",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: width * 0.035,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (state is GetTripError) {
          return Center(child: Text(state.message));
        }
        return Center(child: Text("No Data"));
      },
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
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Color(0xFF7C9D9D)),
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
