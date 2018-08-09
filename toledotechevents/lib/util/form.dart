import 'package:meta/meta.dart';

class Form {
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

  /// Calls [FormInput.onSaved()] on all of the [inputs].
  @mustCallSuper
  void save() {
    inputs.forEach((input) {
      if (input.onSaved != null) input.onSaved(input.value);
    });
  }

  /// Calls [FormInput.onSubmitted()] on all of the [inputs].
  @mustCallSuper
  void submit() {
    inputs.forEach((input) {
      if (input.onSubmitted != null) input.onSubmitted(input.value);
    });
  }

  /// Calls [FormInput.reset()] on all of the [inputs].
  @mustCallSuper
  void reset() => inputs.forEach((input) => input.reset());
}

class FormInput<T> {
  FormInput(
      {this.label,
      this.initialValue,
      this.helperText,
      bool hidden: false,
      this.validator,
      this.onChanged,
      this.onSaved,
      this.onSubmitted})
      : _value = initialValue,
        hidden = hidden ?? false;

  final StringResolver<T> label;
  final StringResolver<T> helperText;
  final T initialValue;
  final bool hidden;

  /// Returns `null` if validation succeeds. Otherwise returns an error string.
  final InputValidator<T> validator;
  final ValueHandler<T> onChanged;
  final ValueHandler<T> onSaved;
  final ValueHandler<T> onSubmitted;

  T _value;
  T get value => _value;
  void set value(T val) {
    _value = val;
    if (onChanged != null) onChanged(_value);
  }

  void reset() => value = initialValue;

  FormInput<T> clone() {
    final input = FormInput<T>(
      label: label,
      initialValue: initialValue,
      helperText: helperText,
      hidden: hidden,
      validator: validator,
      onChanged: onChanged,
      onSaved: onSaved,
      onSubmitted: onSubmitted,
    );
    input._value = _value;
    return input;
  }
}

typedef String StringResolver<T>([T value]);
typedef String InputValidator<T>(T value);
typedef void ValueHandler<T>(T value);

/// Runs [String.trim()] when setting [value].
class TrimmingFormInput extends FormInput<String> {
  TrimmingFormInput(
      {StringResolver<String> label,
      StringResolver<String> helperText,
      String initialValue,
      bool hidden: false,
      InputValidator<String> validator,
      ValueHandler<String> onChanged,
      ValueHandler<String> onSaved,
      ValueHandler<String> onSubmitted})
      : super(
            label: label,
            helperText: helperText,
            initialValue: initialValue,
            hidden: hidden,
            validator: validator,
            onChanged: onChanged,
            onSaved: onSaved,
            onSubmitted: onSubmitted);
  @override
  void set value(String val) => super.value = (val?.trim());
}
