import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimePickerFormField extends FormField<DateTime> {
  final DateFormat format;
  final DateTime initialDate, firstDate, lastDate;
  final IconData resetIcon;
  final TextEditingController controller;
  final FocusNode focusNode;
  final FormFieldValidator<DateTime> validator;
  final FormFieldSetter<DateTime> onSaved;
  final ValueChanged<DateTime> onFieldSubmitted;

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
    String initialValue,
    InputDecoration decoration: const InputDecoration(),
    TextInputType keyboardType: TextInputType.text,
    TextStyle style,
    TextAlign textAlign: TextAlign.start,
    bool autofocus: false,
    bool obscureText: false,
    bool autocorrect: true,
    bool maxLengthEnforced: true,
    bool enabled,
    int maxLines: 1,
    int maxLength,
    List<dynamic> inputFormatters, //TextInputFormatter
  })  : controller = controller ?? TextEditingController(text: initialValue),
        focusNode = focusNode ?? FocusNode(),
        initialDate = initialDate ?? DateTime.now(),
        firstDate = firstDate ?? DateTime(1900),
        lastDate = lastDate ?? DateTime(2100),
        super(
            key: key,
            autovalidate: autovalidate,
            validator: (value) {
              try {
                return validator(format.parse(controller.text));
              } catch (e) {
                return validator(null);
              }
            },
            onSaved: (value) {
              try {
                return onSaved(format.parse(controller.text));
              } catch (e) {
                return onSaved(null);
              }
            },
            builder: (FormFieldState<DateTime> field) {
              final _DateTimePickerTextFormFieldState state = field;
              return new TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: resetIcon == null
                      ? decoration
                      : decoration.copyWith(
                          suffixIcon: state.showResetIcon
                              ? IconButton(
                                  icon: Icon(resetIcon),
                                  onPressed: () {
                                    focusNode.unfocus();
                                    state._previousValue = '';
                                    controller.clear();
                                  },
                                )
                              : Container(width: 0.0, height: 0.0),
                        ),
                  keyboardType: keyboardType,
                  style: style,
                  textAlign: textAlign,
                  autofocus: autofocus,
                  obscureText: obscureText,
                  autocorrect: autocorrect,
                  maxLengthEnforced: maxLengthEnforced,
                  maxLines: maxLines,
                  maxLength: maxLength,
                  inputFormatters: inputFormatters,
                  enabled: enabled,
                  onSubmitted: (value) {
                    try {
                      return onFieldSubmitted(format.parse(controller.text));
                    } catch (e) {
                      return onFieldSubmitted(null);
                    }
                  });
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
    parent.focusNode.addListener(inputChanged);
    parent.controller.addListener(inputChanged);
  }

  @override
  void dispose() {
    parent.controller?.removeListener(inputChanged);
    parent.focusNode?.removeListener(inputChanged);
    super.dispose();
  }

  void inputChanged() {
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
}

DateTime _startOfDay(DateTime dt) => dt
    .subtract(Duration(hours: dt.hour))
    .subtract(Duration(minutes: dt.minute))
    .subtract(Duration(seconds: dt.second))
    .subtract(Duration(milliseconds: dt.millisecond))
    .subtract(Duration(microseconds: dt.microsecond));
