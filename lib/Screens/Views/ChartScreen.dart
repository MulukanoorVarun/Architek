import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

// Assuming these are the correct paths in your project
import '../../Block/Logic/PiechartdataScreen/PiechartCubit.dart';
import '../../Block/Logic/PiechartdataScreen/PiechartState.dart';
// Import the EditExpenseScreen


class Chartscreen extends StatefulWidget {
  final String place;
  final String budget;

  const Chartscreen({super.key, required this.place, required this.budget});

  static const Map<String, Color> categoryColors = {
    'Emergency': Colors.red,
    'Miscellaneous': Colors.green,
    'Transportation': Colors.blue,
    'Food': Colors.yellow,
    'Shopping': Colors.purple,
    'Sightseeing': Colors.white,
    'Activities': Colors.black,
    'Accommodation': Colors.pink,
    'Entertainment': Colors.orange,
    'Health': Colors.cyan,
  };

  static const Map<String, List<Color>> categoryGradients = {
    'Emergency': [Colors.red, Colors.redAccent],
    'Miscellaneous': [Colors.green, Colors.greenAccent],
    'Transportation': [Colors.blue, Colors.blueAccent],
    'Food': [Colors.yellow, Color(0xFFFFD740)],
    'Shopping': [Colors.purple, Colors.purpleAccent],
    'Sightseeing': [Colors.white],
    'Activities': [Colors.black],
    'Accommodation': [Colors.pink, Colors.pinkAccent],
    'Entertainment': [Colors.orange, Colors.orangeAccent],
    'Health': [Colors.cyan, Colors.cyanAccent],
  };

  static const Map<String, IconData> categoryIcons = {
    'Emergency': Icons.warning_rounded,
    'Miscellaneous': Icons.category_rounded,
    'Transportation': Icons.directions_car_rounded,
    'Food': Icons.fastfood_rounded,
    'Shopping': Icons.shopping_bag_rounded,
    'Sightseeing': Icons.visibility_rounded,
    'Activities': Icons.sports_rounded,
    'Accommodation': Icons.hotel_rounded,
    'Entertainment': Icons.theater_comedy_rounded,
    'Health': Icons.local_hospital_rounded,
  };

  @override
  State<Chartscreen> createState() => _ChartscreenState();
}

class _ChartscreenState extends State<Chartscreen> {
  @override
  void initState() {
    super.initState();
    context.read<PiechartCubit>().fetchPieChartData();
  }

  void _deleteExpense(dynamic expense) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Deleted expense: ${expense.categoryName}')),
    );
  }

  void _editExpense(dynamic expense) {
    // Navigate to EditExpenseScreen with trip ID and expense details
    context.push(
      '/edit-expense',
      extra: {
        'id': expense.trip, // Assuming expense has a trip field
        'place': widget.place,
        'budget': widget.budget,
        'expense': expense, // Pass the entire expense object
      },
    );
  }

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
          actions: [
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Finish Trip"),
                    content: const Text("Are you sure you want to end this trip?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: const Text("Confirm", style: TextStyle(color: Colors.redAccent)),
                      ),
                    ],
                  ),
                );
              },
              child: const Text(
                "Finish Trip",
                style: TextStyle(
                  color: Color(0xFFFFA726),
                  fontSize: 16,
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
              final expenses = state.response?.data?.expenses ?? [];
              final totalExpense = state.response?.data?.totalExpense ?? 0.0;

              final categoryTotals = <String, double>{};
              for (var expense in expenses) {
                final category = expense.categoryName ?? 'Miscellaneous';
                categoryTotals[category] =
                    (categoryTotals[category] ?? 0.0) + (expense.expense ?? 0.0);
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
                        dataMap: categoryTotals.isNotEmpty
                            ? categoryTotals
                            : {'No Expenses': 1.0},
                        colorList: categoryTotals.isNotEmpty
                            ? categoryTotals.keys
                            .map((key) => Chartscreen.categoryColors[key] ?? Colors.grey)
                            .toList()
                            : [Colors.grey],
                        gradientList: categoryTotals.isNotEmpty
                            ? categoryTotals.keys
                            .map((key) => Chartscreen.categoryGradients[key] ?? [Colors.grey, Colors.grey])
                            .toList()
                            : null,
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
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Add expense functionality to be implemented')),
                            );
                          },
                          icon: const Icon(Icons.add, color: Color(0xFFFFA726)),
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
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.white70, size: 20),
              const SizedBox(width: 8),
              const Text(
                "Place : ",
                style: TextStyle(color: Colors.white70),
              ),
              Text(
                widget.place,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.currency_rupee, color: Colors.white70, size: 20),
              const SizedBox(width: 8),
              const Text(
                "Budget : ",
                style: TextStyle(color: Colors.white70),
              ),
              Text(
                widget.budget,
                style: const TextStyle(
                  color: Colors.greenAccent,
                ),
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

    // Group expenses by date
    final Map<String, List<dynamic>> groupedExpenses = {};
    for (var expense in expenses) {
      final date = expense.date != null
          ? (expense.date is DateTime
          ? dateFormat.format(expense.date)
          : dateFormat.format(DateTime.parse(expense.date)))
          : dateFormat.format(DateTime.now());
      if (!groupedExpenses.containsKey(date)) {
        groupedExpenses[date] = [];
      }
      groupedExpenses[date]!.add(expense);
    }

    // Sort dates in descending order
    final sortedDates = groupedExpenses.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    for (var date in sortedDates) {
      expenseWidgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                width: 120,
                height: 40,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/date patch.png'),
                    fit: BoxFit.cover,
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
        final category = expense.categoryName ?? 'Miscellaneous';
        final amount = expense.expense?.toDouble() ?? 0.0;

        expenseWidgets.add(
          Dismissible(
            key: Key(category + amount.toString() + date),
            background: Container(
              color: Colors.redAccent,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            secondaryBackground: Container(
              color: Colors.greenAccent,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.edit, color: Colors.white),
            ),
            onDismissed: (direction) {
              if (direction == DismissDirection.startToEnd) {
                _deleteExpense(expense);
              }
            },
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.endToStart) {
                _editExpense(expense);
                return false; // Prevent dismissing the item after navigating
              }
              return true;
            },
            child: expensesItem(
              category,
              "-${amount.toStringAsFixed(0)}",
              Chartscreen.categoryIcons[category] ?? Icons.category,
              Chartscreen.categoryColors[category] ?? Colors.grey,
            ),
          ),
        );
      }
    }

    return expenseWidgets;
  }

  Widget expensesItem(String title, String amount, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF223436),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          Text(
            amount,
            style: const TextStyle(
              color: Colors.redAccent,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.edit,
            color: Colors.white30,
            size: 20,
          ),
        ],
      ),
    );
  }
}