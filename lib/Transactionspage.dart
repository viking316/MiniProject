import 'package:flutter/material.dart';
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
  final Firebaseshit _firebaseService = Firebaseshit();

  @override
  void initState() {
    super.initState();
    // Initialize default date range
    _startDate = DateTime(2020, 1, 1);
    _endDate = DateTime.now();

    // Start listening to transactions
    _firebaseService.listenToAllTransactions();
  }

  @override
  void dispose() {
    _firebaseService.dispose();
    super.dispose();
  }

  // Format the date for display
  String formatDate(dynamic date) {
    if (date is String) {
      return date;
    } else if (date is DateTime) {
      return '${date.day}/${date.month}/${date.year} \n ${date.hour}:${date.minute}';
    } else if (date is int) {
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(date * 1000);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
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
            icon: const Icon(Icons.date_range),
            onPressed: _pickDateRange,
          ),
        ],
      ),
      body: ValueListenableBuilder<List<List<Map<String, dynamic>>>>(
        valueListenable: _firebaseService.transactionsNotifier,
        builder: (context, categoriesTransactions, child) {
          // Filter transactions for this category and date range
          final transactions =
              _firebaseService.getTransactionsByCategoryAndDateRange(
            category: widget.category,
            startDate: _startDate,
            endDate: _endDate,
          );

          if (transactions.isEmpty) {
            return const Center(child: Text('No transactions found.'));
          }

          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              final note = transaction['note'] ?? 'No note provided';
              final date = formatDate(transaction['date']);
              final amount = transaction['amount'] ?? 0;
              final type = transaction['type'] ?? 'Unknown';

              return Card(
  elevation: 4,
  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
  child: Padding(
    padding: const EdgeInsets.all(10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left section: Transaction details
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text('Amount: \$${amount.toStringAsFixed(2)}'),
            Text('Type: $type'),
            Text('Date: $date'),
          ],
        ),
        // Right section: Points display
        Row(
          // children: [
          //   Text(
          //     '${transaction['points'] ?? 0}', // Fetch points from the transaction
          //     style: const TextStyle(
          //       fontSize: 14,
          //       fontWeight: FontWeight.bold,
          //       color: Colors.black87,
          //     ),
          //   ),
          //   const SizedBox(width: 5),
          //   const Icon(
          //     Icons.star, // Star icon for points
          //     color: Colors.amber,
          //     size: 20,
          //   ),
          // ],
        ),
      ],
    ),
  ),
);

            },
          );
        },
      ),
    );
  }
}
