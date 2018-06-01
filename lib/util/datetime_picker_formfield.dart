import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimePickerFormField extends FormField<DateTime> {
  final DateFormat format;
  final DateTime initialDate, firstDate, lastDate;
  final IconData resetIcon;
  final FormFieldValidator<DateTime> validator;
  final FormFieldSetter<DateTime> onSaved;
  final ValueChanged<DateTime> onFieldSubmitted;
  final TextEditingController controller;
  final FocusNode focusNode;
  final InputDecoration decoration;

  final TextInputType keyboardType;
  final TextStyle style;
  final TextAlign textAlign;
  final DateTime initialValue;
  final bool autofocus;
  final bool obscureText;
  final bool autocorrect;
  final bool maxLengthEnforced;
  final int maxLines;
  final int maxLength;
  final List<dynamic> inputFormatters; //TextInputFormatter
  final enabled;
  DateTimePickerFormField({
    Key key,

    /// For representing the date as a string e.g. `DateFormat("MMMM d, yyyy 'at' h:mma")`
    @required this.format,

    /// If not null, the TextField [decoration]'s suffixIcon will be
    /// overridden to reset the input using the icon defined here.
    this.resetIcon: Icons.close,

    /// Where the calendar will start when shown. Defaults to the current date.
    DateTime initialDate,

    /// The earliest choosable date. Defaults to 1900.
    DateTime firstDate,

    /// The latest choosable date. Defaults to 2100.
    DateTime lastDate,

    /// The value will be `null` if parsing the DateTime fails.
    this.validator,

    /// The value will be `null` if parsing the DateTime fails.
    this.onSaved,

    /// The value will be `null` if parsing the DateTime fails.
    this.onFieldSubmitted,
    bool autovalidate: false,

    // TextField properties
    TextEditingController controller,
    FocusNode focusNode,
    this.initialValue,
    this.decoration: const InputDecoration(),
    this.keyboardType: TextInputType.text,
    this.style,
    this.textAlign: TextAlign.start,
    this.autofocus: false,
    this.obscureText: false,
    this.autocorrect: true,
    this.maxLengthEnforced: true,
    this.enabled,
    this.maxLines: 1,
    this.maxLength,
    this.inputFormatters, //TextInputFormatter
  })  : controller = controller ??
            TextEditingController(text: _toString(initialValue, format)),
        focusNode = focusNode ?? FocusNode(),
        initialDate = initialDate ?? DateTime.now(),
        firstDate = firstDate ?? DateTime(1900),
        lastDate = lastDate ?? DateTime(2100),
        super(
            key: key,
            autovalidate: autovalidate,
            validator: (value) {
              if (validator != null) {
                return validator(_toDate(controller.text, format));
              }
            },
            onSaved: (value) {
              if (onSaved != null) {
                return onSaved(_toDate(controller.text, format));
              }
            },
            builder: (FormFieldState<DateTime> field) {
              final _DateTimePickerTextFormFieldState state = field;
              print('building textfield. $focusNode');
              // return TextField(
              //     controller: controller,
              //     focusNode: focusNode,
              //     decoration: resetIcon == null
              //         ? decoration
              //         : decoration.copyWith(
              //             suffixIcon: state.showResetIcon
              //                 ? IconButton(
              //                     icon: Icon(resetIcon),
              //                     onPressed: () {
              //                       focusNode.unfocus();
              //                       state._previousValue = '';
              //                       controller.clear();
              //                     },
              //                   )
              //                 : Container(width: 0.0, height: 0.0),
              //           ),
              //     keyboardType: keyboardType,
              //     style: style,
              //     textAlign: textAlign,
              //     autofocus: autofocus,
              //     obscureText: obscureText,
              //     autocorrect: autocorrect,
              //     maxLengthEnforced: maxLengthEnforced,
              //     maxLines: maxLines,
              //     maxLength: maxLength,
              //     inputFormatters: inputFormatters,
              //     enabled: enabled,
              //     onSubmitted: (value) {
              //       if (onFieldSubmitted != null) {
              //         try {
              //           return onFieldSubmitted(format.parse(controller.text));
              //         } catch (e) {
              //           return onFieldSubmitted(null);
              //         }
              //       }
              //     });
            });

  @override
  _DateTimePickerTextFormFieldState createState() =>
      _DateTimePickerTextFormFieldState(this);
}

class _DateTimePickerTextFormFieldState extends FormFieldState<DateTime> {
  final DateTimePickerFormField parent;
  bool showResetIcon = false;
  String _previousValue = '';

  _DateTimePickerTextFormFieldState(this.parent);

  @override
  void initState() {
    super.initState();
    print('Initializing datepicker state, ${parent.focusNode}');
    parent.focusNode.addListener(inputChanged);
    parent.controller.addListener(inputChanged);
  }

  @override
  void dispose() {
    print('Disposing datepicker.');
    parent.controller.removeListener(inputChanged);
    parent.focusNode.removeListener(inputChanged);
    super.dispose();
  }

  void inputChanged() {
    // print('input changed ${parent.controller.text}, $_previousValue');
    if (parent.controller.text.isEmpty &&
        _previousValue.isEmpty &&
        parent.focusNode.hasFocus) {
      getDateTimeInput(context).then((date) {
        parent.focusNode.unfocus();
        setState(() => parent.controller.text = parent.format.format(date));
      });
    } else if (parent.resetIcon != null &&
        parent.controller.text.isEmpty == showResetIcon) {
      setState(() => showResetIcon = !showResetIcon);
      // parent.focusNode.unfocus();
    }
    _previousValue = parent.controller.text;
  }

  Future<DateTime> getDateTimeInput(BuildContext context) async {
    var date = await showDatePicker(
        context: context,
        firstDate: parent.firstDate,
        lastDate: parent.lastDate,
        initialDate: parent.initialDate);
    if (date != null) {
      date = _startOfDay(date);
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
    return TextField(
        controller: parent.controller,
        focusNode: parent.focusNode,
        decoration: parent.resetIcon == null
            ? parent.decoration
            : parent.decoration.copyWith(
                suffixIcon: showResetIcon
                    ? IconButton(
                        icon: Icon(parent.resetIcon),
                        onPressed: () {
                          parent.focusNode.unfocus();
                          _previousValue = '';
                          parent.controller.clear();
                        },
                      )
                    : Container(width: 0.0, height: 0.0),
              ),
        keyboardType: parent.keyboardType,
        style: parent.style,
        textAlign: parent.textAlign,
        autofocus: parent.autofocus,
        obscureText: parent.obscureText,
        autocorrect: parent.autocorrect,
        maxLengthEnforced: parent.maxLengthEnforced,
        maxLines: parent.maxLines,
        maxLength: parent.maxLength,
        inputFormatters: parent.inputFormatters,
        enabled: parent.enabled,
        onSubmitted: (value) {
          if (parent.onFieldSubmitted != null) {
            return parent.onFieldSubmitted(
                _toDate(parent.controller.text, parent.format));
          }
        });
  }
}

String _toString(DateTime date, DateFormat formatter) {
  try {
    return formatter.format(date);
  } catch (e) {
    return '';
  }
}

DateTime _toDate(String string, DateFormat formatter) {
  try {
    return formatter.parse(string);
  } catch (e) {
    return null;
  }
}

DateTime _startOfDay(DateTime dt) => dt
    .subtract(Duration(hours: dt.hour))
    .subtract(Duration(minutes: dt.minute))
    .subtract(Duration(seconds: dt.second))
    .subtract(Duration(milliseconds: dt.millisecond))
    .subtract(Duration(microseconds: dt.microsecond));