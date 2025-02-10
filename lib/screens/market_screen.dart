import 'package:flutter/material.dart';
import '../db/db_helper.dart';

class MarketScreen extends StatefulWidget {
  @override
  _MarketScreenState createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  List<Map<String, dynamic>> _marketList = [];

  @override
  void initState() {
    super.initState();
    _loadMarketData();
  }

  void _loadMarketData() async {
    final db = await DBHelper().database;
    final result = await db.query('market');
    setState(() {
      _marketList = result;
    });
  }

  void _addMarketItem() async {
    if (_itemController.text.isEmpty || _amountController.text.isEmpty) return;
    
    final db = await DBHelper().database;
    await db.insert(
      'market',
      {
        'item': _itemController.text,
        'amount': double.parse(_amountController.text),
        'date': DateTime.now().toIso8601String().split("T")[0],
      },
    );

    _itemController.clear();
    _amountController.clear();
    _loadMarketData();
    Navigator.pop(context);
  }

  void _deleteMarketItem(int id) async {
    final db = await DBHelper().database;
    await db.delete('market', where: "id = ?", whereArgs: [id]);
    _loadMarketData();
  }

  void _showMarketDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Market Item"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _itemController, decoration: InputDecoration(labelText: "Item Name")),
            TextField(controller: _amountController, decoration: InputDecoration(labelText: "Amount"), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          TextButton(onPressed: _addMarketItem, child: Text("Save")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Market List")),
      body: ListView.builder(
        itemCount: _marketList.length,
        itemBuilder: (context, index) {
          final item = _marketList[index];
          return ListTile(
            title: Text(item['item']),
            subtitle: Text("৳${item['amount']} - ${item['date']}"),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteMarketItem(item['id']),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showMarketDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
