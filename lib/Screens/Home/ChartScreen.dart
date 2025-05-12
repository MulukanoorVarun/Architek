import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Chartscreen extends StatelessWidget {
  const Chartscreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF102226),
      appBar: AppBar(
        backgroundColor: const Color(0xFF102226),
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.white),
        title: const Text("Vacation", style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text("Finish Trip", style: TextStyle(color: Colors.orange)),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            travelPlanCard(),
            const SizedBox(height: 24),
            expensesChart(),
            const SizedBox(height: 24),
            const Text(
              "Travel Expenses",
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            expensesItem("Transportation", "-2000", Icons.directions_car, Colors.purpleAccent),
            expensesItem("Food", "-2000", Icons.fastfood, Colors.tealAccent),
            expensesItem("Shopping", "-2000", Icons.shopping_bag, Colors.lightBlueAccent),
            expensesItem("Sightseeing & Activities", "-2000", Icons.map, Colors.pinkAccent),
          ],
        ),
      ),
    );
  }

  Widget travelPlanCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF223436),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: const [
              Icon(Icons.location_on, color: Colors.white),
              SizedBox(width: 8),
              Text("Place : ", style: TextStyle(color: Colors.white)),
              Text("Bangalore", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              Icon(Icons.currency_rupee, color: Colors.white),
              SizedBox(width: 8),
              Text("Budget : ", style: TextStyle(color: Colors.white)),
              Text("50,000", style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget expensesChart() {
    return SizedBox(
      height: 240,
      child: PieChart(
        PieChartData(
          centerSpaceRadius: 60,
          sectionsSpace: 2,
          startDegreeOffset: 270,
          sections: [
            PieChartSectionData(
              color: Colors.cyanAccent,
              value: 35,
              radius: 30,
              title: '',
            ),
            PieChartSectionData(
              color: Colors.pinkAccent,
              value: 25,
              radius: 30,
              title: '',
            ),
            PieChartSectionData(
              color: Colors.blueAccent,
              value: 20,
              radius: 30,
              title: '',
            ),
            PieChartSectionData(
              color: Colors.tealAccent,
              value: 20,
              radius: 30,
              title: '',
            ),
          ],
        ),
      ),
    );
  }

  Widget expensesItem(String title, String amount, IconData icon, Color iconColor) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF223436),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: iconColor,
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          Text(
            amount,
            style: const TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
