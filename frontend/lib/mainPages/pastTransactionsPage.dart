import 'package:flutter/material.dart';
import 'package:frontend/data.dart';


class PastTransactionPage extends StatefulWidget {
  const PastTransactionPage({super.key});

  @override
  State<PastTransactionPage> createState() => _PastTransactionPageState();
}

class _PastTransactionPageState extends State<PastTransactionPage> {
  List<Transaction> pastTransactions = [];
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
      pastTransactions = splitTransactions[1];
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
        itemCount: pastTransactions.length,
        itemBuilder: (context, index) {
          final transaction = pastTransactions[index];
          return ListTile(
            title: Text(transaction.transaction),
            subtitle: Text('Amount: ${transaction.amount}'),
          );
        },
      ),
    );
  }
}
