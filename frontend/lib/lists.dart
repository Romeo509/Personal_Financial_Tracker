import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';


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
      final response = await Dio().get('http://192.168.1.118:8000/transactions/list/');
      if (response.statusCode == 200) {
        final data = response.data as List<dynamic>;
        print(data);
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


class User {
  final String username;
  final String phone;
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final DateTime createdAt;
  final int balance;
  
  const User({
    required this.username,
    required this.phone,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.createdAt,
    required this.balance,
  });
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        username: json['username'] as String,
        phone: json['phone'],
        email: json['email'],
        password: json['password'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        createdAt: json['created_at'],
        balance: json['balance'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'phone': phone,
      'email': email,
      'password': password,
      'first_name': firstName,
      'last_name': lastName,
      'created_at': createdAt,
      'balance': balance
    };
  }
}

class UserApiServices {
  static Future<User?> getUser(phone) async {
    const apiUrl = 'http://192.168.1.118:8000/user/get/?phone=';
    try {
      final response = await Dio().get('$apiUrl$phone');
      if (response.statusCode == 200) {
        final userData = response.data as Map<String, dynamic>;
        return User.fromJson(userData);
      }
    } catch (err) {
      rethrow;
    }
    return null;
  }

  static Future<User?> loginUser(String phone, String password) async {
      final response = await Dio().post('http://192.168.1.118:8000/login/user/',
          data: {
            'phone': phone,
            'password': password,
          }
      );
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return User.fromJson(data);
      }
      return null;
  }

  static Future<User> logoutUser(String phone) async {
    try {
      final response = await Dio().post('http://192.168.1.118:8000/logout/user/',
      data: {
        'phone': phone.toString(),
      });
      if (response.statusCode == 200) {
      } else {
        throw Exception('Logout failed');
      }
    } catch (err) {
      rethrow;
    }
    throw Exception('Failed');
  }
}
class UserDataService {
  static const String userKey = 'user';
  static const String phoneKeyNumber = 'phoneNumber';

  static Future<void> saveUser(user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user);
    await prefs.setString(userKey, userJson);
  }

  static Future<User?> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(userKey);
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  static Future<void> savePhoneNumber(String phoneNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(phoneNumber, phoneNumber);
  }

  static Future<String?> getPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(phoneKeyNumber);
  }
}