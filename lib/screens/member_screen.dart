import 'package:flutter/material.dart';
import '../db/member_service.dart';
import '../models/member_model.dart';

class MemberScreen extends StatefulWidget {
  @override
  _MemberScreenState createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {
  final MemberService _memberService = MemberService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _balanceController = TextEditingController();
  List<Member> _members = [];

  @override
  void initState() {
    super.initState();
    _loadMembers();
  }

  void _loadMembers() async {
    final members = await _memberService.getMembers();
    setState(() {
      _members = members;
    });
  }

  void _addOrUpdateMember({Member? member}) async {
    if (_nameController.text.isEmpty || _balanceController.text.isEmpty) return;
    
    final name = _nameController.text;
    final balance = double.parse(_balanceController.text);
    
    if (member == null) {
      await _memberService.addMember(Member(name: name, balance: balance));
    } else {
      await _memberService.updateMember(Member(id: member.id, name: name, balance: balance));
    }
    
    _nameController.clear();
    _balanceController.clear();
    _loadMembers();
    Navigator.pop(context);
  }

  void _deleteMember(int id) async {
    await _memberService.deleteMember(id);
    _loadMembers();
  }

  void _showMemberDialog({Member? member}) {
    if (member != null) {
      _nameController.text = member.name;
      _balanceController.text = member.balance.toString();
    } else {
      _nameController.clear();
      _balanceController.clear();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(member == null ? "Add Member" : "Edit Member"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _nameController, decoration: InputDecoration(labelText: "Name")),
            TextField(controller: _balanceController, decoration: InputDecoration(labelText: "Balance"), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          TextButton(onPressed: () => _addOrUpdateMember(member: member), child: Text("Save")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Members")),
      body: ListView.builder(
        itemCount: _members.length,
        itemBuilder: (context, index) {
          final member = _members[index];
          return ListTile(
            title: Text(member.name),
            subtitle: Text("Balance: ${member.balance.toStringAsFixed(2)}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(icon: Icon(Icons.edit), onPressed: () => _showMemberDialog(member: member)),
                IconButton(icon: Icon(Icons.delete), onPressed: () => _deleteMember(member.id!)),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showMemberDialog(),
        child: Icon(Icons.add),
      ),
    );
  }
}
