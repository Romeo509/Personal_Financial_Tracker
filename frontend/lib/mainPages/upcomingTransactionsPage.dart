import 'package:flutter/material.dart';
import 'package:frontend/lists.dart';

class UpcomingTransactionsPage extends StatefulWidget {
  const UpcomingTransactionsPage({super.key});

  @override
  State<UpcomingTransactionsPage> createState() => _UpcomingTransactionsPageState();
}

class _UpcomingTransactionsPageState extends State<UpcomingTransactionsPage> {
  List<Transaction> upcomingTransactions = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getTransactions();
  }

  Future<void> getTransactions() async {
    setState(() {
      isLoading = true;
    });
    try {
      final transactions = await TransactionService.fetchTransactions();
      final splitTransactions = TransactionService.splitTransactions(transactions);
      upcomingTransactions = splitTransactions[0];
      setState(() {
        isLoading = false;
      });
    } catch (err) {
      isLoading = false;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator())
      : ListView.builder(
        itemCount: upcomingTransactions.length,
        itemBuilder: (context, index) {
        final transaction = upcomingTransactions[index];
        return ListTile(
          title: Text(transaction.transaction),
          subtitle: Text('Amount: ${transaction.amount}'),
        );
      },
      ),
    );
  }
}
