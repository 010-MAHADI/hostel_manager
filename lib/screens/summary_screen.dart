import 'package:flutter/material.dart';
import '../db/db_helper.dart';

class SummaryScreen extends StatefulWidget {
  @override
  _SummaryScreenState createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  double _totalMarketExpense = 0;
  double _remainingBalance = 0;
  double _mealRate = 0;
  int _totalMeals = 0;

  @override
  void initState() {
    super.initState();
    _calculateSummary();
  }

  void _calculateSummary() async {
    final db = await DBHelper().database;

    // মোট বাজার খরচ বের করা
    final marketResult = await db.rawQuery("SELECT SUM(amount) AS total FROM market");
    _totalMarketExpense = marketResult.first['total'] ?? 0;

    // মোট সদস্যের ব্যালেন্স বের করা
    final balanceResult = await db.rawQuery("SELECT SUM(balance) AS total FROM members");
    double totalBalance = balanceResult.first['total'] ?? 0;

    // মোট মিল গণনা করা
    final mealResult = await db.rawQuery("SELECT SUM(breakfast + lunch + dinner) AS total FROM meals");
    _totalMeals = mealResult.first['total'] ?? 0;

    // প্রতি মিলের রেট গণনা করা
    if (_totalMeals > 0) {
      _mealRate = _totalMarketExpense / _totalMeals;
    }

    // অবশিষ্ট টাকা নির্ণয় করা
    _remainingBalance = totalBalance - _totalMarketExpense;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Summary")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Total Market Expense: ৳${_totalMarketExpense.toStringAsFixed(2)}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Remaining Balance: ৳${_remainingBalance.toStringAsFixed(2)}", style: TextStyle(fontSize: 18, color: Colors.green)),
            SizedBox(height: 10),
            Text("Total Meals: $_totalMeals", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Meal Rate Per Meal: ৳${_mealRate.toStringAsFixed(2)}", style: TextStyle(fontSize: 18, color: Colors.blue)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _calculateSummary,
        child: Icon(Icons.refresh),
      ),
    );
  }
}
