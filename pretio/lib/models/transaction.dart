class Transaction {
  final String id;
  String title;
  double amount;
  String emotion;
  String necessity;
  DateTime date;
  String category;
  bool isFavorite;
  String? note; // New field
  String? logoUrl; // For custom subscription icons
  String type; // 'expense' or 'income'

  Transaction({
    String? id,
    required this.title,
    required this.amount,
    required this.emotion,
    required this.necessity,
    required this.date,
    this.category = 'General',
    this.isFavorite = false,
    this.note,
    this.logoUrl,
    this.type = 'expense',
  }) : id = id ?? DateTime.now().microsecondsSinceEpoch.toString();

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'amount': amount,
    'emotion': emotion,
    'necessity': necessity,
    'date': date.toIso8601String(),
    'category': category,
    'isFavorite': isFavorite,
    'note': note,
    'logoUrl': logoUrl,
    'type': type,
  };

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      title: json['title'],
      amount: (json['amount'] as num).toDouble(),
      emotion: json['emotion'] ?? 'none',
      necessity: json['necessity'] ?? 'none',
      date: DateTime.parse(json['date']),
      category: json['category'] ?? 'General',
      isFavorite: json['isFavorite'] ?? false,
      note: json['note'],
      logoUrl: json['logoUrl'],
      type: json['type'] ?? 'expense',
    );
  }
}

class ShadowTransaction {
  String title;
  double amount;
  String emotion;
  DateTime date;
  String category;
  bool isFavorite;

  ShadowTransaction({
    required this.title,
    required this.amount,
    required this.emotion,
    required this.date,
    this.category = 'General',
    this.isFavorite = false,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'amount': amount,
    'emotion': emotion,
    'date': date.toIso8601String(),
    'category': category,
    'isFavorite': isFavorite,
  };

  factory ShadowTransaction.fromJson(Map<String, dynamic> json) {
    return ShadowTransaction(
      title: json['title'],
      amount: (json['amount'] as num).toDouble(),
      emotion: json['emotion'],
      date: DateTime.parse(json['date']),
      category: json['category'] ?? 'General',
      isFavorite: json['isFavorite'] ?? false,
    );
  }
}
