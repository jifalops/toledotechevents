import 'package:meta/meta.dart';

// TODO document
abstract class Form {
  const Form(this.inputs);
  final List<FormInput> inputs;

  dynamic getValue(FormInput input) => inputs[inputs.indexOf(input)];

  Map<FormInput, dynamic> getValues() => Map.fromIterable(inputs,
      key: (input) => input, value: (input) => input.value);

  /// Returns a list of errors if validation fails or an empty list on success.
  ///
  /// Subclasses should call `super.validate()` first to get a list of errors
  /// from the individual [inputs]. Then proceed to add inter-input errors.
  @mustCallSuper
  List<String> validate() {
    final errors = List<String>();
    inputs.forEach((input) {
      if (input.validator != null) {
        final error = input.validator(input.value);
        if (error != null) errors.add(error);
      }
    });
    return errors;
  }

  /// Calls [FormInput.reset()] on all of the [inputs].
  @mustCallSuper
  void reset() => inputs.forEach((input) => input.reset());

  /// Submit this [Form].
  void submit();
}

// TODO document
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
