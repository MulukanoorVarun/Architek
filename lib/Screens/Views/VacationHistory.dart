import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

// Assuming these are the correct paths in your project
import '../../Block/Logic/PiechartdataScreen/PiechartCubit.dart';
import '../../Block/Logic/PiechartdataScreen/PiechartState.dart';
import '../../utils/color_constants.dart';

class VacationHistory extends StatefulWidget {
  final String place;
  final String budget;

  const VacationHistory({super.key, required this.place, required this.budget});

  static Map<String, Color> categoryColors = {
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

  @override
  State<VacationHistory> createState() => _VacationHistoryState();
}

class _VacationHistoryState extends State<VacationHistory> {
  @override
  void initState() {
    super.initState();
    context.read<PiechartCubit>().fetchPieChartData();
  }

  void _editExpense(dynamic expense) {
    context.push(
      '/edit-expense',
      extra: {
        'id': expense.trip,
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
                  builder:
                      (context) => AlertDialog(
                        title: const Text("Finish Trip"),
                        content: const Text(
                          "Are you sure you want to end this trip?",
                        ),
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
                            child: const Text(
                              "Confirm",
                              style: TextStyle(color: Colors.redAccent),
                            ),
                          ),
                        ],
                      ),
                );
              },
              child: const Text(
                "Finish Trip",
                style: TextStyle(color: Color(0xFFFFA726), fontSize: 16),
              ),
            ),
          ],
        ),
        body: BlocBuilder<PiechartCubit, PiechartState>(
          builder: (context, state) {
            if (state is PiechartLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PiechartSuccess) {
              final expenses = state.response.data?.expenses ?? [];
              final totalExpense = state.response.data?.totalExpense ?? 0.0;
              final categoryTotals = <String, double>{};
              for (var expense in expenses) {
                final category = expense.categoryName ?? 'Miscellaneous';
                categoryTotals[category] =
                    (categoryTotals[category] ?? 0.0) +
                    (expense.expense ?? 0.0);
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
                                          VacationHistory.categoryColors[key] ??
                                          Colors.grey,
                                    )
                                    .toList()
                                : [Colors.grey],
                        gradientList:
                            categoryTotals.isNotEmpty
                                ? categoryTotals.keys
                                    .map(
                                      (key) =>
                                          VacationHistory
                                              .categoryGradients[key] ??
                                          [Colors.grey, Colors.grey],
                                    )
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
                    SizedBox(height: 24),
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
                              '/update_expensive?id=${state.response.data?.expenses![0].tripId ?? ''}&place=${widget.place}&budget=${widget.budget}',
                            );
                          },
                          child: Row(
                            spacing: 2,
                            children: [
                              Text(
                                'Add',
                                style: TextStyle(
                                  color: Color(0xff1C3132),
                                  fontSize: 14,
                                  fontFamily: 'Lexend',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Icon(Icons.add, color: Color(0xff1C3132)),
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
              ? (expense.date is DateTime
                  ? dateFormat.format(expense.date)
                  : dateFormat.format(DateTime.parse(expense.date)))
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
          padding: EdgeInsets.only(top: 8),
          child: Row(
            children: [
              Container(
                width: 120,
                height: 40,
                decoration: BoxDecoration(
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
        final w = MediaQuery.of(context).size.width;
        final category = expense.categoryName ?? 'Miscellaneous';
        final remarks = expense.remarks ?? '';
        final expenceId = expense.expenseId?? '';
        final amount = expense.expense?.toDouble() ?? 0.0;

        expenseWidgets.add(
          Dismissible(
            key: Key(category),
            background: Container(
              color: Colors.blue,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 20),
              child: const Icon(Icons.edit, color: Colors.white, size: 30),
            ),
            secondaryBackground: Container(
              color: Colors.red, // Background for swipe-right (delete)
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete, color: Colors.white, size: 30),
            ),
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.endToStart) {
                return await showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text('Confirm Delete'),
                        content: const Text(
                          'Are you sure you want to delete this item?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                );
              } else if (direction == DismissDirection.startToEnd) {
                context.push(
                  '/update_expensive?place=${widget.place}&budget=${widget.budget}&expenseId=${expenceId}',
                );
                return false;
              }
              return false;
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF223436),
                borderRadius: BorderRadius.circular(12),
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
                          remarks,
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
