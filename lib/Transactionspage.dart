import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:miniproject/Firebaseshit.dart';

class TransactionsPage extends StatefulWidget {
  final String category;

  const TransactionsPage({super.key, required this.category});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  late DateTime _startDate;
  late DateTime _endDate;
  late Future<List<Map<String, dynamic>>> _transactionsFuture;

  @override
  void initState() {
    super.initState();
    // Initialize default date range (last 30 days)
    _startDate = DateTime(2020, 1, 1);
    _endDate = DateTime.now();
    _transactionsFuture = _fetchTransactions();
  }

  // Fetch transactions from Firestore based on category and date range
  Future<List<Map<String, dynamic>>> _fetchTransactions() {
    return Firebaseshit.fetchTransactionsByCategoryAndDateRange(
      category: widget.category,
      startDate: _startDate,
      endDate: _endDate,
    );
  }

  // Format the date for display
  String formatDate(dynamic date) {
    if (date is String) {
      return date; // Already formatted string
    } else if (date is DateTime) {
      return '${date.day}/${date.month}/${date.year}'; // Format DateTime
    } else if (date is int) {
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(date * 1000);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}'; // Format Unix timestamp
    } else {
      return 'No date';
    }
  }

  // Allow the user to pick a date range
  Future<void> _pickDateRange() async {
    final dateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
    );

    if (dateRange != null) {
      setState(() {
        _startDate = dateRange.start;
        _endDate = dateRange.end;
        _transactionsFuture = _fetchTransactions(); // Refresh transactions based on new date range
      });
    }
  }

  




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions for ${widget.category}'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(Icons.date_range),
            onPressed: _pickDateRange, // Trigger date range picker
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _transactionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No transactions found.'));
          }

          final transactions = snapshot.data!;
          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              final note = transaction['note'] ?? 'No note provided';
              final date = formatDate(transaction['date']);
              final amount = transaction['amount'] ?? 0;
              final type = transaction['type'] ?? 'Unknown'; // Income or Expense

              return ListTile(
                title: Text(note), // Display the note
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Amount: \$${amount.toStringAsFixed(2)}'), // Display the amount
                    Text('Type: $type'), // Display the transaction type
                  ],
                ),
                trailing: Text(date), // Display the formatted date
              );
            },
          );
        },
      ),
    );
  }
}



