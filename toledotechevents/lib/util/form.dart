import 'dart:collection' show UnmodifiableListView;
import 'package:meta/meta.dart';

export 'dart:collection' show UnmodifiableListView;

class Form {
  Form(this.inputs);
  final UnmodifiableListView<FormInput> inputs;

  List<dynamic> get values => inputs.map((input) => input.value);

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
      this.validator,
      this.onChanged,
      this.onSaved,
      this.onSubmitted});
  final String label;

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
