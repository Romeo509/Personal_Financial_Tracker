import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';


class Transaction {
  final String transaction;
  final double amount;
  final DateTime createdAt;
  final DateTime deadline;
  final int remainingDays;

  const Transaction({
    required this.transaction,
    required this.amount,
    required this.createdAt,
    required this.deadline,
    required this.remainingDays,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      transaction: json['transaction'] as String,
      amount: json['amount'] as double,
      createdAt: DateTime.parse(json['created_at']),
      deadline: DateTime.parse(json['deadline']),
      remainingDays: json['remaining_days'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transaction': transaction,
      'amount': amount,
      'created_at': createdAt,
      'deadline': deadline,
      'remaining_days': remainingDays,
    };
  }
}


class TransactionService {
  static Future<List<Transaction>> fetchTransactions() async {
    try {
      final response = await Dio().get('http://192.168.100.33:8000/transactions/list/');
      if (response.statusCode == 200) {
        final data = response.data as List<dynamic>;
        return data.map((item) => Transaction.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load transactions');
      }
    } catch (err) {
      rethrow;
    }
  }

  static List<List<Transaction>> splitTransactions(List<Transaction> transactions) {
    final now = DateTime.now();
    final pastTransactions = <Transaction>[];
    final upcomingTransactions = <Transaction>[];

    for (final transaction in transactions) {
      final transactionDate = DateFormat('yyyy-MM-dd').parse(transaction.deadline as String);
      if (transactionDate.isBefore(now)) {
        pastTransactions.add(transaction);
      } else {
        upcomingTransactions.add(transaction);
      }
    }
    return [pastTransactions, upcomingTransactions];
  }
}
