import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tripfin/Block/Logic/CategoryList/CategoryCubit.dart';
import 'package:tripfin/Block/Logic/CategoryList/CategoryState.dart';
import 'package:tripfin/Block/Logic/GetTrip/GetTripCubit.dart';
import 'package:tripfin/Block/Logic/UpdateExpence/UpdateExpenceCubit.dart';
import 'package:tripfin/Block/Logic/UpdateExpence/UpdateExpenceState.dart';
import '../Components/CustomAppButton.dart';
import '../Components/CutomAppBar.dart';

class UpdateExpense extends StatefulWidget {
  final String id;
  final String place;
  final String budget;

  const UpdateExpense({
    Key? key,
    required this.id,
    required this.place,
    required this.budget,
  }) : super(key: key);

  @override
  State<UpdateExpense> createState() => _UpdateExpenseState();
}

class _UpdateExpenseState extends State<UpdateExpense> {
  String? selectedCategory;
  String paymentMode = "Online";
  String? selectedCategoryId;
  TextEditingController amountController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController remarksController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<Categorycubit>().GetCategory();
  }

  // Function to show date picker and format selected date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      dateController.text = formattedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff102A2C),
      appBar: CustomAppBar(title: 'Vacation', actions: []),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Travel Plan',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xff1D3A3C),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.place, color: Colors.white),
                      const SizedBox(width: 8),
                      const Text(
                        'Place : ',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Text(
                        widget.place,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: "Mullish",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.grey, height: 24),
                  Row(

                    children: [
                      const Icon(Icons.currency_rupee, color: Colors.white),
                      const SizedBox(width: 8),
                      const Text(
                        'Budget : ',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Text(
                        widget.budget,
                        style: const TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),


                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Travel Expenses',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xff1D3A3C),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildDropdownField(),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: amountController,
                    hint: 'Amount',
                    icon: Icons.attach_money,
                    inputType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: dateController,
                    hint: 'When you Spent',
                    icon: Icons.calendar_today,
                    readOnly: true, // Prevent manual input
                    onTap: () => _selectDate(context), // Open date picker on tap
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: remarksController,
                    hint: 'Remarks',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Payment Mode',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  Row(
                    children: [
                      Radio(
                        value: "Online",
                        groupValue: paymentMode,
                        activeColor: Colors.orangeAccent,
                        onChanged: (val) {
                          setState(() {
                            paymentMode = val.toString();
                          });
                        },
                      ),
                      const Text(
                        'Online',
                        style: TextStyle(color: Colors.white),
                      ),
                      Radio(
                        value: "Cash",
                        groupValue: paymentMode,
                        activeColor: Colors.orangeAccent,
                        onChanged: (val) {
                          setState(() {
                            paymentMode = val.toString();
                          });
                        },
                      ),
                      const Text('Cash', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            BlocConsumer<UpdateExpenseCubit, UpdateExpenseState>(
              listener: (context, state) {
                if (state is UpdateExpenseSuccessState) {
                  context.push('/piechart');
                  context.read<GetTripCubit>().GetTrip();
                }
              },
              builder: (context, state) {
                return SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: CustomAppButton1(
                    text: 'Done',
                    // isLoading: state is UpdateExpenseLoading,
                    onPlusTap: () {
                      final Map<String, dynamic> data = {
                        'expense': amountController.text,
                        'category': selectedCategoryId,
                        'date': dateController.text, // Use formatted date
                        'remarks': remarksController.text,
                        'payment_mode': paymentMode,
                        'trip': widget.id,
                      };
                      context.read<UpdateExpenseCubit>().addExpense(data);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField() {
    return BlocBuilder<Categorycubit, Categorystate>(
      builder: (context, state) {
        if (state is CategoryLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CategoryLoaded) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade600),
              borderRadius: BorderRadius.circular(30),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                dropdownColor: const Color(0xff1D3A3C),
                value: selectedCategoryId,
                isExpanded: true,
                hint: const Text(
                  'Select Category',
                  style: TextStyle(color: Colors.white70),
                ),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                items: state.categoryresponsemodel.data?.map((category) {
                  return DropdownMenuItem<String>(
                    value: category.id,
                    child: Text(
                      category.categoryName ?? "",
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    selectedCategoryId = val;
                    final catName = state.categoryresponsemodel.data
                        ?.firstWhere((element) => element.id == val);
                    selectedCategory = catName?.categoryName ?? "";
                  });
                },
              ),
            ),
          );
        } else if (state is CategoryError) {
          return Center(child: Text(state.message));
        }
        return const Center(child: Text("No Data"));
      },
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
}