import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimePickerTextFormField extends FormField<DateTime> {
  final DateFormat formatter;
  final String labelText;
  final String errorText;
  final DateTime initialDate, firstDate, lastDate;
  final bool showClearIcon;
  final IconData clearIcon;
  final TextEditingController controller;
  final FocusNode focusNode;
  final onSaved;
  DateTimePickerTextFormField(
      {String format: "MMMM d, yyyy 'at' h:mma",
      this.labelText: 'Date and time',
      this.errorText: 'Invalid date/time',
      this.showClearIcon: true,
      this.clearIcon: Icons.close,
      this.onSaved,
      TextEditingController controller,
      FocusNode focusNode,
      DateTime initialDate,
      DateTime firstDate,
      DateTime lastDate})
      : formatter = DateFormat(format),
        controller = controller ?? TextEditingController(),
        focusNode = focusNode ?? FocusNode(),
        initialDate = initialDate ?? DateTime.now(),
        firstDate =
            firstDate ?? DateTime.now().subtract(Duration(days: 365 * 2)),
        lastDate = lastDate ?? DateTime.now().add(Duration(days: 365 * 10)),
        super(builder: (FormFieldState<DateTime> field) {});

  @override
  _DateTimePickerTextFormFieldState createState() =>
      _DateTimePickerTextFormFieldState(this);
}

class _DateTimePickerTextFormFieldState extends FormFieldState<DateTime> {
  final parent;
  // DateTime dateTime;
  bool showClearIcon = false;

  _DateTimePickerTextFormFieldState(this.parent);

  @override
  void initState() {
    super.initState();
    parent.focusNode.addListener(inputChanged);
    parent.controller.addListener(inputChanged);
  }

  void inputChanged() {
    if (parent.controller.text.isEmpty && parent.focusNode.hasFocus) {
      getDateTimeInput(context).then((date) {
        parent.focusNode.unfocus();
        setState(() => parent.controller.text = parent.formatter.format(date));
      });
    } else if (parent.showClearIcon &&
        parent.controller.text.isEmpty == showClearIcon) {
      setState(() => showClearIcon = !showClearIcon);
    }
  }

  Future<DateTime> getDateTimeInput(BuildContext context) async {
    var date = await showDatePicker(
        context: context,
        firstDate: parent.firstDate,
        lastDate: parent.lastDate,
        initialDate: parent.initialDate);
    if (date != null) {
      date = startOfDay(date);
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: 12, minute: 0),
      );
      if (time != null) {
        date = date.add(Duration(hours: time.hour, minutes: time.minute));
      }
    }
    return date;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: parent.controller,
      decoration: InputDecoration(
        labelText: parent.labelText,
        suffixIcon: showClearIcon
            ? IconButton(
                icon: Icon(parent.clearIcon),
                onPressed: () {
                  parent.focusNode.unfocus();
                  parent.controller.clear();
                },
              )
            : Container(width: 0.0, height: 0.0),
      ),
      focusNode: parent.focusNode,
      validator: (value) {
        if (value.length < 4) return parent.errorText;
        try {
          parent.formatter.parse(value);
        } catch (e) {
          return parent.errorText;
        }
      },
      onSaved: (value) => parent.onSaved == null
          ? null
          : parent.onSaved(parent.formatter.parse(value)),
    );
  }

  DateTime startOfDay(DateTime dt) => dt
      .subtract(Duration(hours: dt.hour))
      .subtract(Duration(minutes: dt.minute))
      .subtract(Duration(seconds: dt.second))
      .subtract(Duration(milliseconds: dt.millisecond));
}
