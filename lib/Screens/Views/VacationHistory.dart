import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:tripfin/Block/Logic/EditProfileScreen/TripcountState.dart';
import 'package:tripfin/Block/Logic/ExpenseDetails/ExpenseDetailsCubit.dart';
import 'package:tripfin/Block/Logic/TripFinish/TripFinishCubit.dart';
import 'package:tripfin/Block/Logic/TripFinish/TripFinishState.dart';
import 'package:tripfin/Screens/Components/CustomSnackBar.dart';

import '../../Block/Logic/PiechartdataScreen/PiechartCubit.dart';
import '../../Block/Logic/PiechartdataScreen/PiechartState.dart';
import '../../utils/color_constants.dart';

class VacationHistory extends StatefulWidget {
  final String place;
  final String budget;

  const VacationHistory({super.key, required this.place, required this.budget});

  @override
  State<VacationHistory> createState() => _VacationHistoryState();
}

class _VacationHistoryState extends State<VacationHistory> {
  @override
  void initState() {
    super.initState();
    context.read<PiechartCubit>().fetchPieChartData();
  }

  String? tripId;
  String? finishTripText;
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
          titleLarge: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
          titleMedium: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          bodySmall: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          labelLarge: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        dialogTheme: const DialogTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          contentTextStyle: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        snackBarTheme: const SnackBarThemeData(
          contentTextStyle: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF1C3132),
        appBar: AppBar(
          backgroundColor: const Color(0xFF1C3132),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text("Vacation"),

          actions:
              finishTripText == "No active trip found."
                  ? []
                  : [
                BlocListener<TripFinishCubit, TripFinishState>(
                  listener: (context, state) {
                    if (state is FinishTripSuccessState) {
                      final budgetStr = state.finishTripModel.data?.budget;
                      final totalExpenseStr =
                          state.finishTripModel.data?.totalExpense;

                      if (budgetStr != null && totalExpenseStr != null) {
                        final budget = double.tryParse(budgetStr);
                        final totalExpense = double.tryParse(
                          totalExpenseStr,
                        );

                        if (budget != null && totalExpense != null) {
                          if (budget == totalExpense) {
                            context.pushReplacement("/perfect_screen");
                          } else if (budget < totalExpense) {
                            context.pushReplacement("/out_of_theBudget");
                          } else if (budget > totalExpense) {
                            context.pushReplacement("/below_of_theBudget");
                          }
                        } else {
                          context.pushReplacement("/error_screen");
                        }
                      } else {
                        context.pushReplacement("/error_screen");
                      }
                    }
                  },
                  child: TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                          title: const Text("Finish Trip"),
                          content: const Text(
                            "Are you sure you want to end this trip?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                context.pop();
                              },
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                final Map<String, dynamic> data = {
                                  "is_completed": "true",
                                };
                                context
                                    .read<TripFinishCubit>()
                                    .finishTrip(data);
                              },
                              child: const Text(
                                "Confirm",
                                style: TextStyle(
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    child:  Text(
                      "Finish Trip",
                      style: TextStyle(
                        color: Color(0xFFFFA726),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
        ),
        body: BlocBuilder<PiechartCubit, PiechartState>(
          builder: (context, state) {
            if (state is PiechartLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PiechartSuccess) {
              tripId = state.response.data?.tripId ?? '';
              finishTripText = state.message ?? "";
              final expenses = state.response.data?.expenseData ?? [];
              final totalExpense =
                  state.response.data?.totalExpense?.toDouble() ?? 0.0;
              final categoryTotals = <String, double>{};
              final categoryColorMap = <String, Color>{};
              final categoryGradientMap = <String, List<Color>>{};

              // Aggregate expenses by category and map colors from colorCode
              for (var expense in expenses) {
                final category = expense.categoryName ?? 'Miscellaneous';
                categoryTotals[category] =
                    (categoryTotals[category] ?? 0.0) +
                    (expense.totalExpense?.toDouble() ?? 0.0);

                // Parse colorCode (assuming it's a hex string like '#FF0000' or 'FF0000')
                try {
                  if (expense.colorCode != null &&
                      expense.colorCode!.isNotEmpty) {
                    final hexColor = expense.colorCode!.replaceAll('#', '');
                    final color = Color(int.parse('FF$hexColor', radix: 16));
                    categoryColorMap[category] = color;
                    categoryGradientMap[category] = [
                      color,
                      color.withOpacity(0.7),
                    ];
                  } else {
                    categoryColorMap[category] = Colors.grey;
                    categoryGradientMap[category] = [
                      Colors.grey,
                      Colors.grey.withOpacity(0.7),
                    ];
                  }
                } catch (e) {
                  categoryColorMap[category] = Colors.grey;
                  categoryGradientMap[category] = [
                    Colors.grey,
                    Colors.grey.withOpacity(0.7),
                  ];
                }
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<PiechartCubit>().fetchPieChartData();
                },
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    travelPlanCard(),
                    const SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.1),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: PieChart(
                        dataMap:
                            categoryTotals.isNotEmpty
                                ? categoryTotals
                                : {'No Expenses': 1.0},
                        colorList:
                            categoryTotals.isNotEmpty
                                ? categoryTotals.keys
                                    .map(
                                      (key) =>
                                          categoryColorMap[key] ?? Colors.grey,
                                    )
                                    .toList()
                                : [Colors.grey],
                        gradientList:
                            categoryTotals.isNotEmpty
                                ? categoryTotals.keys
                                    .map(
                                      (key) =>
                                          categoryGradientMap[key] ??
                                          [Colors.grey, Colors.grey],
                                    )
                                    .toList()
                                : [
                                  [Colors.grey, Colors.grey],
                                ],
                        animationDuration: const Duration(milliseconds: 1200),
                        chartLegendSpacing: 32,
                        chartRadius: MediaQuery.of(context).size.width / 1.8,
                        initialAngleInDegree: 270,
                        chartType: ChartType.ring,
                        ringStrokeWidth: 30,
                        centerWidget: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Expenses",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              totalExpense.toStringAsFixed(0),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                shadows: [
                                  Shadow(
                                    color: Colors.white24,
                                    blurRadius: 10,
                                    offset: Offset(0, 0),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        legendOptions: const LegendOptions(showLegends: false),
                        chartValuesOptions: const ChartValuesOptions(
                          showChartValues: false,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Travel Expenses",
                          style: TextStyle(
                            color: Color(0xffFBFBFB),
                            fontSize: 20,
                            fontFamily: 'Mullish',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        FilledButton(
                          style: ButtonStyle(
                            visualDensity: VisualDensity.compact,
                            backgroundColor: MaterialStateProperty.all(
                              buttonBgColor,
                            ),
                          ),
                          onPressed: () {
                            context.push(
                              '/update_expensive?id=${state.response.data?.tripId ?? ''}&place=${widget.place}&budget=${widget.budget}',
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Add',
                                style: TextStyle(
                                  color: Color(0xff1C3132),
                                  fontSize: 14,
                                  fontFamily: 'Lexend',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 2),
                              Icon(
                                Icons.add,
                                color: const Color(0xff1C3132),
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ..._buildExpenseList(expenses),
                  ],
                ),
              );
            } else if (state is PiechartError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.redAccent,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message ?? 'An error occurred while loading data',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFA726),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        context.read<PiechartCubit>().fetchPieChartData();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            return const Center(
              child: Text(
                "No Data Available",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget travelPlanCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF223436),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Travel Plan",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.white70, size: 20),
              const SizedBox(width: 8),
              const Text("Place : ", style: TextStyle(color: Colors.white70)),
              Text(widget.place, style: const TextStyle(color: Colors.white)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.currency_rupee, color: Colors.white70, size: 20),
              const SizedBox(width: 8),
              const Text("Budget : ", style: TextStyle(color: Colors.white70)),
              Text(
                widget.budget,
                style: const TextStyle(color: Colors.greenAccent),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildExpenseList(List<dynamic> expenses) {
    final List<Widget> expenseWidgets = [];
    final dateFormat = DateFormat('dd.MM.yyyy');

    final Map<String, List<dynamic>> groupedExpenses = {};
    for (var expense in expenses) {
      final date =
          expense.date != null
              ? dateFormat.format(DateTime.parse(expense.date))
              : dateFormat.format(DateTime.now());
      if (!groupedExpenses.containsKey(date)) {
        groupedExpenses[date] = [];
      }
      groupedExpenses[date]!.add(expense);
    }
    final sortedDates =
        groupedExpenses.keys.toList()..sort((a, b) => b.compareTo(a));

    for (var date in sortedDates) {
      expenseWidgets.add(
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            children: [
              Container(
                width: 120,
                height: 40,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/date patch.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Center(
                  child: Text(
                    date,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
      final dateExpenses = groupedExpenses[date]!;
      for (var expense in dateExpenses) {
        final w = MediaQuery.of(context).size.width;
        final category = expense.categoryName ?? 'Miscellaneous';
        final expenseId = expense.expenseId ?? '';
        final amount = expense.totalExpense?.toDouble() ?? 0.0;

        expenseWidgets.add(
          Dismissible(
            key: ValueKey(expenseId),
            background: Container(
              color: Colors.blue,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 20),
              child: const Row(
                children: [
                  Icon(Icons.edit, color: Colors.white, size: 30),
                  SizedBox(width: 10),
                  Text(
                    'Edit',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            secondaryBackground: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Delete',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.delete, color: Colors.white, size: 30),
                ],
              ),
            ),
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.endToStart) {
                HapticFeedback.mediumImpact();
                return await showDialog<bool>(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text('Confirm Delete'),
                        content: const Text(
                          'Are you sure you want to delete this expense?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              try {
                                await context
                                    .read<GetExpenseDetailCubit>()
                                    .deleteExpenseDetails(expenseId);
                                CustomSnackBar.show(
                                  context,
                                  'Expense deleted successfully',
                                );
                                context
                                    .read<PiechartCubit>()
                                    .fetchPieChartData();
                                context.pop();
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Failed to delete expense: $e',
                                    ),
                                    backgroundColor: Colors.red,
                                    duration: const Duration(seconds: 3),
                                  ),
                                );
                                Navigator.of(context).pop(false);
                              }
                            },
                            child: const Text(
                              'Delete',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                );
              } else if (direction == DismissDirection.startToEnd) {
                HapticFeedback.lightImpact();
                print("TRipId:${tripId}");
                context.push(
                  '/update_expensive?id=${tripId}&place=${widget.place}&budget=${widget.budget}&expenseId=$expenseId',
                );
                return false;
              }
              return false;
            },
            // Removed onDismissed to prevent redundant deletion
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF223436),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: w * 0.65,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Mullish',
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          category, // Replaced remarks with categoryName
                          style: const TextStyle(
                            color: Color(0xffDBDBDB),
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'Mullish',
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "-${amount.toStringAsFixed(0)}",
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }

    return expenseWidgets;
  }
}
