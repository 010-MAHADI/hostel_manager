class Member {
  int? id;
  String name;
  double balance;

  Member({this.id, required this.name, this.balance = 0});

  // Map থেকে Member object তৈরি
  factory Member.fromMap(Map<String, dynamic> map) {
    return Member(
      id: map['id'],
      name: map['name'],
      balance: map['balance'],
    );
  }

  // Member object থেকে Map তৈরি
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'balance': balance,
    };
  }
}
