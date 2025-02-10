import 'package:flutter/material.dart';
import 'member_screen.dart';
import 'meal_screen.dart';
import 'market_screen.dart';
import 'summary_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hostel Manager")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MemberScreen()),
              ),
              child: Text("Manage Members"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MealScreen()),
              ),
              child: Text("Track Meals"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MarketScreen()),
              ),
              child: Text("Market List"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SummaryScreen()),
              ),
              child: Text("View Summary"),
            ),
          ],
        ),
      ),
    );
  }
}
