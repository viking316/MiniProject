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
  final Firebaseshit _firebaseService = Firebaseshit();
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

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

 void _showCustomDatePicker() {
  showDialog(
    context: context,
    builder: (context) {
      DateTime tempStartDate = _startDate;
      DateTime tempEndDate = _endDate;

      return AlertDialog(
        backgroundColor: lighterShade1,
        title: Text('Select Date Range', style: TextStyle(color: Colors.white)),
        content: StatefulBuilder(
          builder: (context, setDialogState) {
            return Container(
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DatePickerField(
                    label: 'Start Date',
                    date: tempStartDate,
                    onDateSelected: (date) {
                      setDialogState(() {
                        tempStartDate = date;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  DatePickerField(
                    label: 'End Date',
                    date: tempEndDate,
                    onDateSelected: (date) {
                      setDialogState(() {
                        tempEndDate = date;
                      });
                    },
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          TextButton(
            child: Text('Clear', style: TextStyle(color: Colors.red)),
            onPressed: () {
              setState(() {
                _startDate = DateTime(2020, 1, 1);
                _endDate = DateTime.now();
              });
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text('Cancel', style: TextStyle(color: Colors.white70)),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('OK', style: TextStyle(color: accentColor)),
            onPressed: () {
              if (tempStartDate.isAfter(tempEndDate)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Start date must be before end date.'),
                    backgroundColor: Colors.red,
                  ),
                );
              } else {
                setState(() {
                  _startDate = tempStartDate;
                  _endDate = tempEndDate;
                });
                Navigator.pop(context);
              }
            },
          ),
        ],
      );
    },
  );
}


  String formatDate(dynamic date) {
    if (date is String) {
      return date;
    } else if (date is DateTime) {
      return '${_dateFormat.format(date)}\n${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else if (date is int) {
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(date * 1000);
      return _dateFormat.format(dateTime);
    }
    return 'No date';
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
            onPressed: _showCustomDatePicker,
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
                  width: MediaQuery.of(context).size.width * 0.9,
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
                    borderRadius: BorderRadius.circular(16),
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

class DatePickerField extends StatelessWidget {
  final String label;
  final DateTime date;
  final Function(DateTime) onDateSelected;

  const DatePickerField({
    required this.label,
    required this.date,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
    final accentColor = const Color.fromARGB(255, 68, 68, 140);
    final lighterShade2 = const Color.fromARGB(255, 48, 48, 100);

    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: date,
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
                dialogBackgroundColor: lighterShade2,
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          onDateSelected(picked);
        }
      },
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: lighterShade2,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(color: Colors.white70),
            ),
            Row(
              children: [
                Text(
                  _dateFormat.format(date),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(width: 8),
                Icon(Icons.calendar_today, color: Colors.white70),
              ],
            ),
          ],
        ),
      ),
    );
  }
}