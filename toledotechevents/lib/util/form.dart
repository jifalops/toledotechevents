import 'dart:async';

/// Forms hold the values of one or more [FormInputs] and has methods to reset,
/// validate, and submit the form.
///
/// To be able to add and remove this form's inputs dynamically, use
/// [DynamicForm].
abstract class Form {
  Form(Iterable<FormInput> inputs) : _inputs = inputs;
  final List<FormInput> _inputs;

  /// Returns a list of error strings, one from each [FormInput] in the form.
  /// If validation succeeds, the returned list will be empty.
  List<String> validate() {
    final errors = List<String>();
    _inputs.forEach((input) {
      if (input.validator != null) {
        final error = input.validator(input.value);
        if (error != null) errors.add(error);
      }
    });
    return errors;
  }

  /// Calls [FormInput.reset()] on all inputs, resetting them to their
  /// [FormInput.initialValue].
  void reset() => _inputs.forEach((input) => input.reset());

  /// Submit this [Form].
  Future submit();

  /// The number of [FormInputs] in this form.
  int get length => _inputs.length;

  /// Allow iterating over this form's inputs.
  Iterable<FormInput> iterate() => _inputs.getRange(0, _inputs.length);
}

/// Exposes its inputs using the [inputs] getter.
abstract class DynamicForm extends Form {
  DynamicForm([Iterable<FormInput> inputs]) : super(inputs ?? []);
  List<FormInput> get inputs => _inputs;
}

/// Defines an input for a [Form], including its value.
///
/// The default [FormInput.validator] accepts any value as valid.
/// [FormInput.onChanged] is added as the first value change listener if it is
/// non-null.
class FormInput<T> {
  FormInput(
      {this.label,
      this.initialValue,
      this.helperText,
      bool hidden: false,
      InputValidator<T> validator,
      this.filter,
      ValueHandler<T> onChanged})
      : _value = initialValue,
        validator = validator ?? _defaultValidator,
        hidden = hidden ?? false {
    if (onChanged != null) _listeners.add(onChanged);
  }

  final StringResolver<T> label;
  final StringResolver<T> helperText;
  final ValueFilter<T> filter;

  /// The [filter] is not applied to the initial value.
  final T initialValue;
  final bool hidden;

  /// Returns `null` if validation succeeds. Otherwise returns an error string.
  final InputValidator<T> validator;

  /// The default listener, called before other listeners when the value changes.
  final _listeners = List<ValueHandler<T>>();

  T _value;
  T get value => _value;
  void set value(T val) {
    _value = filter == null ? val : filter(val);
    _listeners.forEach((listener) => listener(_value));
  }

  /// Be notified whenever [value] changes.
  void addListener(ValueHandler listener) => _listeners.add(listener);
  bool removeListener(ValueHandler listener) => _listeners.remove(listener);

  void reset() => value = initialValue;

  FormInput<T> clone() {
    final input = FormInput<T>(
        label: label,
        initialValue: initialValue,
        helperText: helperText,
        hidden: hidden,
        validator: validator,
        filter: filter);
    input._value = _value;
    input._listeners.addAll(_listeners);
    return input;
  }
}

typedef T ValueFilter<T>(T value);
typedef String StringResolver<T>([T value]);
typedef String InputValidator<T>(T value);
typedef void ValueHandler<T>(T value);

String _defaultValidator<T>(T value) => null;

/// Runs [String.trim()] when setting [value].
class TrimmedStringInput extends FormInput<String> {
  TrimmedStringInput(
      {StringResolver<String> label,
      StringResolver<String> helperText,
      String initialValue,
      bool hidden: false,
      InputValidator<String> validator,
      ValueHandler<String> onChanged})
      : super(
            label: label,
            helperText: helperText,
            initialValue: initialValue,
            hidden: hidden,
            validator: validator,
            onChanged: onChanged,
            filter: (value) => value?.trim());
}
