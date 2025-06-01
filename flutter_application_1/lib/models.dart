import 'package:flutter/material.dart';

class WalletData {
  final int balance;
  final int dailyLimit;
  final int todaySpent;
  final String cardNumber;

  WalletData({
    required this.balance,
    required this.dailyLimit,
    required this.todaySpent,
    required this.cardNumber,
  });

  factory WalletData.fromJson(Map<String, dynamic> json) {
    return WalletData(
      balance: json['balance'],
      dailyLimit: json['dailyLimit'],
      todaySpent: json['todaySpent'],
      cardNumber: json['cardNumber'],
    );
  }
}

class Transaction {
  final String label;
  final int amount;
  final String type;
  final DateTime date;

  Transaction({
    required this.label,
    required this.amount,
    required this.type,
    required this.date,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      label: json['label'] ?? json['title'] ?? 'Unknown',
      amount: json['amount'] is int
          ? json['amount']
          : (json['amount'] is String ? int.tryParse(json['amount']) ?? 0 : 0),
      type: json['type'] ?? (json['amount'] < 0 ? 'WITHDRAW' : 'DEPOSIT'),
      date:
          DateTime.tryParse(json['date'] ?? json['createdAt'] ?? '')?.toUtc() ??
          DateTime.now().toUtc(),
    );
  }

  IconData get icon {
    if (label.toLowerCase().contains('goal')) return Icons.arrow_downward;
    if (label.toLowerCase().contains('spent')) return Icons.arrow_upward;
    if (label.toLowerCase().contains('reward')) return Icons.stars;
    if (label.toLowerCase().contains('parent'))
      return Icons.account_balance_wallet_outlined;
    return amount < 0 ? Icons.arrow_upward : Icons.arrow_downward;
  }

  String get displayDate {
    final now = DateTime.now().toUtc();
    final txDate = DateTime(date.year, date.month, date.day);
    final nowDate = DateTime(now.year, now.month, now.day);
    final diff = nowDate.difference(txDate).inDays;

    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    if (diff > 1) return '$diff days ago';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
