
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tripfin/Block/Logic/EditExpense/EditExpenseCubit.dart';

import '../../Block/Logic/CategoryList/CategoryCubit.dart';
import '../../Block/Logic/CategoryList/CategoryState.dart';
import '../../Block/Logic/GetTrip/GetTripCubit.dart';
import '../../Block/Logic/UpdateExpence/UpdateExpenceCubit.dart';
import '../../Block/Logic/UpdateExpence/UpdateExpenceState.dart';

class EditExpenseScreen extends StatefulWidget {
  final String id;
  final String place;
  final String budget;

  const EditExpenseScreen({
    Key? key,
    required this.id,
    required this.place,
    required this.budget,
  }) : super(key: key);

  @override
  _EditExpenseScreenState createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  String? selectedCategory;
  String? selectedCategoryId;
  String paymentMode = 'Online';
  final TextEditingController amountController = TextEditingController(text: '300.00');
  final TextEditingController dateController = TextEditingController(text: '2025-04-18');
  final TextEditingController remarksController = TextEditingController(text: 'shopping dress');

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
      setState(() {
        dateController.text = formattedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff102A2C), // Updated to match new design
      appBar: AppBar(
        backgroundColor: const Color(0xff102A2C),
        elevation: 0,
        title: const Text(
          'Edit expense',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Travel Plan Section (Added from new design)
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

            // Travel Expenses Section
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
                  // Dynamic Category Dropdown
                  BlocBuilder<Categorycubit, Categorystate>(
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
                                  child: Row(
                                    children: [
                                      const Icon(Icons.local_drink, color: Colors.white70),
                                      const SizedBox(width: 8),
                                      Text(
                                        category.categoryName ?? "",
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    ],
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
                  ),
                  const SizedBox(height: 16),

                  // Amount Field
                  TextField(
                    controller: amountController,
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Amount',
                      hintStyle: const TextStyle(color: Colors.white70),
                      prefixIcon: const Icon(Icons.attach_money, color: Colors.white70),
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
                  ),
                  const SizedBox(height: 16),

                  // Spend Date Field
                  TextField(
                    controller: dateController,
                    style: const TextStyle(color: Colors.white),
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    decoration: InputDecoration(
                      hintText: 'When you Spent',
                      hintStyle: const TextStyle(color: Colors.white70),
                      prefixIcon: const Icon(Icons.calendar_today, color: Colors.white70),
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
                  ),
                  const SizedBox(height: 16),

                  // Remarks Field
                  TextField(
                    controller: remarksController,
                    style: const TextStyle(color: Colors.white),
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Remarks',
                      hintStyle: const TextStyle(color: Colors.white70),
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
                  ),
                  const SizedBox(height: 24),

                  // Payment Mode
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Payment Mode',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  Row(
                    children: [
                      Radio<String>(
                        value: 'Online',
                        groupValue: paymentMode,
                        activeColor: Colors.orangeAccent,
                        onChanged: (value) {
                          setState(() {
                            paymentMode = value!;
                          });
                        },
                      ),
                      const Text(
                        'Online',
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(width: 16),
                      Radio<String>(
                        value: 'Cash',
                        groupValue: paymentMode,
                        activeColor: Colors.orangeAccent,
                        onChanged: (value) {
                          setState(() {
                            paymentMode = value!;
                          });
                        },
                      ),
                      const Text(
                        'Cash',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Done Button with BlocConsumer
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
                  child: ElevatedButton(
                    onPressed: () {
                      final Map<String, dynamic> data = {
                        'expense': amountController.text,
                        'category': selectedCategoryId,
                        'date': dateController.text,
                        'note': remarksController.text,
                        'payment_method': paymentMode,
                        'trip': widget.id,
                      };
                      context.read<Editexpensecubit>().EditExpense(data);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE8B923), // Mustard yellow
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Done',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}