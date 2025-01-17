import 'package:flutter/material.dart';
import 'package:miniproject/Firebaseshit.dart';
import 'package:flutter/material.dart';
import 'package:miniproject/Firebaseshit.dart';
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

  // Define custom colors
  final baseColor = const Color.fromARGB(255, 28, 28, 60);
  final lighterShade1 = const Color.fromARGB(255, 38, 38, 80);
  final lighterShade2 = const Color.fromARGB(255, 48, 48, 100);
  final accentColor = const Color.fromARGB(255, 68, 68, 140);

  @override
  void initState() {
    super.initState();
    _startDate = DateTime(2020, 1, 1);
    _endDate = DateTime.now();
    _firebaseService.listenToAllTransactions();
  }

  @override
  void dispose() {
    _firebaseService.dispose();
    super.dispose();
  }

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

  Future<void> _pickDateRange() async {
    DateTime? tempStartDate = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: accentColor,
              onPrimary: Colors.white,
              surface: lighterShade2,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: lighterShade1,
          ),
          child: child!,
        );
      },
    );

    if (tempStartDate != null) {
      DateTime? tempEndDate = await showDatePicker(
        context: context,
        initialDate: _endDate,
        firstDate: tempStartDate,
        lastDate: DateTime.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.dark(
                primary: accentColor,
                onPrimary: Colors.white,
                surface: lighterShade2,
                onSurface: Colors.white,
              ),
              dialogBackgroundColor: lighterShade1,
            ),
            child: child!,
          );
        },
      );

      if (tempEndDate != null) {
        setState(() {
          _startDate = tempStartDate;
          _endDate = tempEndDate;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: baseColor,
      appBar: AppBar(
        title: Text(
          'Transactions for ${widget.category}',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: lighterShade1,
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range, color: Colors.white),
            onPressed: _pickDateRange,
          ),
        ],
      ),
      body: ValueListenableBuilder<List<List<Map<String, dynamic>>>>(
        valueListenable: _firebaseService.transactionsNotifier,
        builder: (context, categoriesTransactions, child) {
          final transactions = _firebaseService.getTransactionsByCategoryAndDateRange(
            category: widget.category,
            startDate: _startDate,
            endDate: _endDate,
          );

          if (transactions.isEmpty) {
            return Center(
              child: Text(
                'No transactions found.',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          return ListView.builder(
  itemCount: transactions.length,
  itemBuilder: (context, index) {
    final transaction = transactions[index];
    final note = transaction['note'] ?? 'No note provided';
    final date = formatDate(transaction['date']);
    final amount = transaction['amount'] ?? 0;
    final type = transaction['type'] ?? 'Unknown';

    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9, // Consistent width (90% of screen)
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[850],
          border: Border(
            bottom: BorderSide(
              color: const Color.fromARGB(255, 75, 72, 72).withOpacity(0.8),
              width: 4.0,
            ),
            right: BorderSide(
              color: const Color.fromARGB(255, 75, 72, 72).withOpacity(0.8),
              width: 4.0,
            ),
          ),
          borderRadius: BorderRadius.circular(16), // Increased rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Amount: \$${amount.toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.white70),
                  ),
                  Text(
                    'Type: $type',
                    style: TextStyle(color: Colors.white70),
                  ),
                  Text(
                    'Date: $date',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ],
          ),
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