import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tripfin/Block/Logic/CategoryList/CategoryState.dart';
import 'package:tripfin/Block/Logic/GetTrip/GetTripCubit.dart';
import 'package:tripfin/Block/Logic/Home/HomeCubit.dart';
import 'package:tripfin/Screens/Components/CustomSnackBar.dart';
import '../../Block/Logic/CategoryList/CategoryCubit.dart';
import '../../Block/Logic/ExpenseDetails/ExpenseDetailsCubit.dart';
import '../../Block/Logic/ExpenseDetails/ExpenseDetailsState.dart';
import '../../Block/Logic/PiechartdataScreen/PiechartCubit.dart';
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
  final TextEditingController amountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();

  @override
  void initState() {
    super.initState();

    context.read<Categorycubit>().GetCategory();

    context.read<Categorycubit>().stream.listen((state) {
      if (state is CategoryLoaded && state.categoryresponsemodel.data != null) {
        if (selectedCategoryId == null) {
          setState(() {
            selectedCategoryId = state.categoryresponsemodel.data!.first.id;
            selectedCategory =
                state.categoryresponsemodel.data!.first.categoryName;
          });
        }
      }
    });
    if (widget.expenseId.isNotEmpty) {
      context.read<GetExpenseDetailCubit>().GetExpenseDetails(widget.expenseId);
    }

    // Listen to GetExpenseDetailCubit state changes
    context.read<GetExpenseDetailCubit>().stream.listen((state) {
      if (state is GetExpenseDetailLoaded) {
        final expenseData = state.expenseDetailModel.data;
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
      body: BlocConsumer<GetExpenseDetailCubit, GetExpenseDetailsState>(
        listener: (context, state) {
          if (state is ExpenceDetailSuccess) {
            CustomSnackBar.show(
              context,
              widget.expenseId.isEmpty
                  ? 'Expense added successfully!'
                  : 'Expense updated successfully!',
            );
            Future.microtask(() {
              context.pushReplacement(
                '/vacation?budget=${widget.budget}&place=${widget.place}',
              );
              context.read<PiechartCubit>().fetchPieChartData("");
              context.read<HomeCubit>().fetchHomeData();
            });
          } else if (state is GetExpenseDetailError) {
            CustomSnackBar.show(context, state.message);
          }
        },
        builder: (context, expenseState) {
          if (expenseState is GetExpenseDetailLoading ||
              expenseState is SaveExpenseDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (expenseState is GetExpenseDetailLoaded ||
              expenseState is ExpenceDetailSuccess ||
              widget.expenseId.isEmpty) {
            return _buildForm(context);
          } else if (expenseState is GetExpenseDetailError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    expenseState.message,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (widget.expenseId.isNotEmpty) {
                        context.read<GetExpenseDetailCubit>().GetExpenseDetails(
                          widget.expenseId,
                        );
                      }
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const Center(
            child: Text(
              "Loading data...",
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Travel Plan'),
          const SizedBox(height: 12),
          _buildTravelPlanCard(),
          const SizedBox(height: 24),
          _buildSectionTitle('Travel Expenses'),
          const SizedBox(height: 12),
          _buildExpenseForm(),
          const SizedBox(height: 32),
          _buildSubmitButton(context),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildTravelPlanCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff1D3A3C),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildInfoRow(Icons.place, 'Place: ', widget.place),
          const Divider(color: Colors.grey, height: 24),
          _buildInfoRow(
            Icons.currency_rupee,
            'Budget: ',
            widget.budget,
            textColor: Colors.greenAccent,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    Color? textColor,
    FontWeight? fontWeight,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 16)),
        Text(
          value,
          style: TextStyle(
            color: textColor ?? Colors.white,
            fontFamily: "Mullish",
            fontSize: 16,
            fontWeight: fontWeight ?? FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildExpenseForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff1D3A3C),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildCategoryDropdown(),
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
          _buildPaymentModeSelector(),
        ],
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return BlocBuilder<Categorycubit, Categorystate>(
      builder: (context, categoryState) {
        if (categoryState is CategoryLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (categoryState is CategoryLoaded &&
            categoryState.categoryresponsemodel.data != null) {
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
                items:
                    categoryState.categoryresponsemodel.data!.map((category) {
                      return DropdownMenuItem<String>(
                        value: category.id,
                        child: Text(
                          category.categoryName ?? "",
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      selectedCategoryId = val;
                      final catName = categoryState.categoryresponsemodel.data!
                          .firstWhere((element) => element.id == val);
                      selectedCategory = catName.categoryName ?? "";
                    });
                  }
                },
              ),
            ),
          );
        } else if (categoryState is CategoryError) {
          return Center(
            child: Text(
              categoryState.message,
              style: const TextStyle(color: Colors.white),
            ),
          );
        }
        return const Center(
          child: Text(
            "No Categories Available",
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  Widget _buildPaymentModeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Mode',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        Row(
          children: [
            Radio<String>(
              value: "Online",
              groupValue: paymentMode,
              activeColor: Colors.orangeAccent,
              onChanged: (val) {
                if (val != null) {
                  setState(() => paymentMode = val);
                }
              },
            ),
            const Text('Online', style: TextStyle(color: Colors.white)),
            Radio<String>(
              value: "Cash",
              groupValue: paymentMode,
              activeColor: Colors.orangeAccent,
              onChanged: (val) {
                if (val != null) {
                  setState(() => paymentMode = val);
                }
              },
            ),
            const Text('Cash', style: TextStyle(color: Colors.white)),
          ],
        ),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return BlocBuilder<GetExpenseDetailCubit, GetExpenseDetailsState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          height: 50,
          child: CustomAppButton1(
            text: widget.expenseId.isEmpty ? 'Add Expense' : 'Update Expense',
            isLoading: state is SaveExpenseDetailLoading,
            onPlusTap: () {
              if (!_validateForm()) {
                CustomSnackBar.show(context, 'Please fill all required fields');
                return;
              }
              final Map<String, dynamic> data = {
                'expense': amountController.text,
                'category': selectedCategoryId,
                'date': dateController.text,
                'remarks': remarksController.text,
                'payment_mode': paymentMode,
                'trip': widget.id,
              };
              if (widget.expenseId.isNotEmpty) {
                context.read<GetExpenseDetailCubit>().updateExpenseDetails(
                  data,
                  widget.expenseId,
                );
              } else {
                context.read<GetExpenseDetailCubit>().addExpense(data);
              }
            },
          ),
        );
      },
    );
  }

  bool _validateForm() {
    return selectedCategoryId != null &&
        amountController.text.isNotEmpty &&
        dateController.text.isNotEmpty &&
        double.tryParse(amountController.text) != null;
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
          borderSide: BorderSide(color: Colors.orangeAccent),
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
