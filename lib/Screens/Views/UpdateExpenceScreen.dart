import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tripfin/Block/Logic/CategoryList/CategoryState.dart';
import 'package:tripfin/Block/Logic/GetTrip/GetTripCubit.dart';
import 'package:tripfin/Screens/Components/CustomSnackBar.dart';
import '../../Block/Logic/CategoryList/CategoryCubit.dart';
import '../../Block/Logic/ExpenseDetails/ExpenseDetailsCubit.dart';
import '../../Block/Logic/ExpenseDetails/ExpenseDetailsState.dart';
import '../Components/CustomAppButton.dart';
import '../Components/CutomAppBar.dart';

class UpdateExpense extends StatefulWidget {
  final String id;
  final String place;
  final String budget;
  final String expenseId;

  const UpdateExpense({
    Key? key,
    required this.id,
    required this.place,
    required this.budget,
    required this.expenseId,
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
    context.read<Categorycubit>().stream.listen((state) {
      print('CategoryCubit State: $state'); // Debug state
    });
    if (widget.expenseId.isNotEmpty) {
      context.read<GetExpenseDetailCubit>().GetExpenseDetails(widget.expenseId);
    }
    context.read<GetExpenseDetailCubit>().stream.listen((state) {
      print('GetExpenseDetailCubit State: $state'); // Debug state
      if (state is GetExpenseDetailLoaded) {
        final expenseData = state.expenseDetailModel.data;
        print('Expense Data: $expenseData'); // Debug data
        setState(() {
          selectedCategoryId = expenseData?.category ?? "";
          selectedCategory = expenseData?.categoryName ?? "";
          paymentMode = expenseData?.paymentMode ?? "Online";
          amountController.text = expenseData?.expense.toString() ?? "";
          dateController.text = expenseData?.date ?? "";
          remarksController.text = expenseData?.remarks ?? "";
        });
      }
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff102A2C),
      appBar: CustomAppBar(title: 'Vacation', actions: []),
      body: BlocBuilder<GetExpenseDetailCubit, GetExpenseDetailsState>(
        builder: (context, state) {
          if (state is GetExpenseDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetExpenseDetailLoaded) {
            return SingleChildScrollView(
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
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
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
                            const Icon(
                              Icons.currency_rupee,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Budget : ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
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
                        BlocBuilder<Categorycubit, Categorystate>(
                          builder: (context, state) {
                            if (state is CategoryLoaded) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade600,
                                  ),
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
                                    icon: const Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.white,
                                    ),
                                    items:
                                        state.categoryresponsemodel.data?.map((
                                          category,
                                        ) {
                                          return DropdownMenuItem<String>(
                                            value: category.id,
                                            child: Text(
                                              category.categoryName ?? "",
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                    onChanged: (val) {
                                      if (val != null) {
                                        setState(() {
                                          selectedCategoryId = val;
                                          final catName = state
                                              .categoryresponsemodel
                                              .data
                                              ?.firstWhere(
                                                (element) => element.id == val,
                                              );
                                          selectedCategory =
                                              catName?.categoryName ?? "";
                                        });
                                      }
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
                        _buildTextField(
                          controller: amountController,
                          hint: 'Amount',
                          icon: Icons.currency_rupee,
                          inputType: TextInputType.number,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: dateController,
                          hint: 'When you Spent',
                          icon: Icons.calendar_today,
                          readOnly: true,
                          onTap: () => _selectDate(context),
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
                            Radio<String>(
                              value: "Online",
                              groupValue: paymentMode,
                              activeColor: Colors.orangeAccent,
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() {
                                    paymentMode = val;
                                  });
                                }
                              },
                            ),
                            const Text(
                              'Online',
                              style: TextStyle(color: Colors.white),
                            ),
                            Radio<String>(
                              value: "Cash",
                              groupValue: paymentMode,
                              activeColor: Colors.orangeAccent,
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() {
                                    paymentMode = val;
                                  });
                                }
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
                  BlocConsumer<GetExpenseDetailCubit, GetExpenseDetailsState>(
                    listener: (context, state) {
                      if (state is ExpenceDetailSuccess) {
                        context.push(
                          '/vacation?budget=${widget.budget}&place=${widget.place}',
                        );
                        context.read<GetTripCubit>().GetTrip();
                      } else if (state is GetExpenseDetailError) {
                        CustomSnackBar.show(context, state.message);
                      }
                    },
                    builder: (context, state) {
                      return SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: CustomAppButton1(
                          text: 'Done',
                          isLoading: state is GetExpenseDetailError,
                          onPlusTap: () {
                            if (selectedCategoryId == null ||
                                amountController.text.isEmpty ||
                                dateController.text.isEmpty) {
                              return;
                            }
                            final Map<String, dynamic> data = {
                              'expense': amountController.text,
                              'category': selectedCategoryId,
                              'date': dateController.text,
                              'remarks': remarksController.text,
                              'payment_mode': paymentMode,
                              'trip': widget.expenseId != "" ? widget.expenseId : widget.id,
                            };
                            if (widget.expenseId != "") {
                              context.read<GetExpenseDetailCubit>().updateExpenseDetails(data);
                            } else {
                              context.read<GetExpenseDetailCubit>().addExpense(data);
                            }
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          } else if (state is GetExpenseDetailError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text("No Data"));
        },
      ),
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

  @override
  void dispose() {
    amountController.dispose();
    dateController.dispose();
    remarksController.dispose();
    super.dispose();
  }
}
