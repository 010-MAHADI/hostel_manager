import 'package:flutter/material.dart';
import '../db/db_helper.dart';
import '../models/member_model.dart';

class MealScreen extends StatefulWidget {
  @override
  _MealScreenState createState() => _MealScreenState();
}

class _MealScreenState extends State<MealScreen> {
  List<Member> _members = [];
  Map<int, Map<String, bool>> _mealData = {};

  @override
  void initState() {
    super.initState();
    _loadMembers();
  }

  void _loadMembers() async {
    final db = await DBHelper().database;
    final result = await db.query('members');
    final List<Member> members = result.map((e) => Member.fromMap(e)).toList();

    setState(() {
      _members = members;
      for (var member in members) {
        _mealData[member.id!] = {'breakfast': false, 'lunch': false, 'dinner': false};
      }
    });
  }

  void _toggleMeal(int memberId, String mealType) {
    setState(() {
      _mealData[memberId]![mealType] = !_mealData[memberId]![mealType]!;
    });
  }

  void _saveMeals() async {
    final db = await DBHelper().database;
    String today = DateTime.now().toIso8601String().split("T")[0];

    for (var member in _members) {
      await db.insert(
        'meals',
        {
          'member_id': member.id,
          'date': today,
          'breakfast': _mealData[member.id]!['breakfast']! ? 1 : 0,
          'lunch': _mealData[member.id]!['lunch']! ? 1 : 0,
          'dinner': _mealData[member.id]!['dinner']! ? 1 : 0,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Meals saved!")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Meal Tracker")),
      body: ListView.builder(
        itemCount: _members.length,
        itemBuilder: (context, index) {
          final member = _members[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(member.name),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Checkbox(
                    value: _mealData[member.id]!['breakfast'],
                    onChanged: (value) => _toggleMeal(member.id!, 'breakfast'),
                  ),
                  Checkbox(
                    value: _mealData[member.id]!['lunch'],
                    onChanged: (value) => _toggleMeal(member.id!, 'lunch'),
                  ),
                  Checkbox(
                    value: _mealData[member.id]!['dinner'],
                    onChanged: (value) => _toggleMeal(member.id!, 'dinner'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveMeals,
        child: Icon(Icons.save),
      ),
    );
  }
}
