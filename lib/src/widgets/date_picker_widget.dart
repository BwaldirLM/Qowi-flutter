import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class DatePickerWidget extends StatefulWidget {
  const DatePickerWidget({Key? key}) : super(key: key);

  @override
  DatePickerWidgetState createState() => DatePickerWidgetState();
}

class DatePickerWidgetState extends State<DatePickerWidget> {
  late DateTime _currentDate;
  late DateFormat formatter;

  @override
  void initState() {
    super.initState();
    _currentDate = DateTime.now();
    formatter = DateFormat('dd-MM-yyyy');
  }

  DateTime get currentDate => _currentDate;

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2020),
        lastDate: DateTime.now());
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        _currentDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(formatter.format(currentDate)),
        IconButton(
            onPressed: () => _selectDate(context), icon: Icon(Icons.date_range))
      ],
    );
  }
}
