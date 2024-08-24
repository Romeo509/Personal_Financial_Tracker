import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';


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

  Future<List<Transaction>> retrieveTransactions(String apiUrl) async {
    final response = await Dio().get(apiUrl);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.data) as List<dynamic>;
      return data.map((transactionData) => Transaction.fromJson(transactionData)).toList();
    } else {
      throw Exception('Failed to load transactions: ${response.statusCode}');
    }
  }

  Future<void> getTransactions() async {
    final apiUrl = 'http://192.168.100.33:8000/transactions/list/';
    final transactions = await retrieveTransactions(apiUrl);
    for (final transaction in transactions) {
      print(transaction.toJson());
    }
  }
}

List upcomingTransactions = [
  [
    const Icon(
      Icons.diamond,
      color: Colors.red,
      size: 40,
    ),
    "-\$150.52",
    DateTime(2022, 10, 16),
    "Luxury"
  ],
  [
    const Icon(
      Icons.logo_dev,
      color: Colors.blue,
      size: 40,
    ),
    "-\$180.01",
    DateTime(2022, 10, 17),
    "Software"
  ],
  [
    const Icon(
      Icons.polymer,
      color: Colors.blue,
      size: 40,
    ),
    "-\$10.32",
    DateTime(2022, 10, 18),
    "Tooling"
  ],
  [
    const Icon(
      Icons.anchor,
      size: 40,
      color: Colors.green,
    ),
    "-\$19.39",
    DateTime(2022, 10, 22),
    "Vacation/Travel"
  ],
  [
    const Icon(
      Icons.music_note,
      color: Colors.purple,
      size: 40,
    ),
    "-\$90.19",
    DateTime(2022, 10, 23),
    "Education"
  ],
  [
    const Icon(
      Icons.fitness_center,
      color: Colors.purple,
      size: 40,
    ),
    "-\$89.32",
    DateTime(2022, 10, 24),
    "Fitness"
  ],
  [
    const Icon(
      Icons.music_note,
      color: Colors.purple,
      size: 40,
    ),
    "-\$90.19",
    DateTime(2022, 10, 23),
    "Education"
  ],
];

List pastTransactions = [
  [
    const Icon(
      Icons.diamond,
      color: Colors.pink,
      size: 40,
    ),
    "-\$150.52",
    DateTime(2022, 9, 16),
    "Jewlery"
  ],
  [
    const Icon(
      Icons.home,
      color: Colors.green,
      size: 40,
    ),
    "-\$180.32",
    DateTime(2022, 9, 13),
    "Gardening"
  ],
  [
    const Icon(
      Icons.branding_watermark,
      color: Colors.blue,
      size: 40,
    ),
    "-\$112.39",
    DateTime(2022, 9, 11),
    "Software"
  ],
  [
    const Icon(
      Icons.polymer,
      color: Colors.orange,
      size: 40,
    ),
    "-\$170.19",
    DateTime(2022, 9, 10),
    "Materials"
  ],
  [
    const Icon(
      Icons.fitness_center,
      color: Colors.blue,
      size: 40,
    ),
    "-\$250.12",
    DateTime(2022, 9, 9),
    "Fitness"
  ],
];
