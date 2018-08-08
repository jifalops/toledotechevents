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
}

class FormInput<T> {
  FormInput(
      {this.label,
      this.helperText,
      this.hidden: false,
      this.validator,
      this.onChanged,
      this.onSaved,
      this.onSubmitted});

  FormInput.clone(FormInput<T> other)
      : label = other.label,
        helperText = other.helperText,
        hidden = other.hidden,
        validator = other.validator,
        onChanged = other.onChanged,
        onSaved = other.onSaved,
        onSubmitted = other.onSubmitted;

  final String label;
  final String helperText;
  final bool hidden;

  /// Returns `null` if validation succeeds. Otherwise returns an error string.
  final String Function(T value) validator;
  final void Function(T value) onChanged;
  final void Function(T value) onSaved;
  final void Function(T value) onSubmitted;

  T _value;
  T get value => _value;
  void set value(val) {
    _value = val;
    if (onChanged != null) onChanged(_value);
  }
}
