import 'dart:async';
import 'package:flutter/material.dart';

typedef Future<List<T>> Suggestions<T>(String search);
typedef Widget ItemBuilder<T>(BuildContext context, T item);

abstract class ItemParser<T> {
  String asString(T item);
  T parse(String string);
}

class SimpleAutocompleteTextField<T> extends FormField<T> {
  final Key key;
  final int minSearchLength;
  final int maxSuggestions;
  final ItemBuilder<T> itemBuilder;
  final ItemParser<T> itemParser;
  final Suggestions<T> onSearch;
  final ValueChanged<T> onChanged;
  final IconData resetIcon;
  // TextFormField transient properties
  final FormFieldValidator<T> validator;
  final FormFieldSetter<T> onSaved;
  final ValueChanged<T> onFieldSubmitted;
  final TextEditingController controller;
  final FocusNode focusNode;
  final InputDecoration decoration;
  final TextInputType keyboardType;
  final TextStyle style;
  final TextAlign textAlign;
  final T initialValue;
  final bool autofocus;
  final bool obscureText;
  final bool autocorrect;
  final bool maxLengthEnforced;
  final int maxLines;
  final int maxLength;
  final List<dynamic> inputFormatters; //TextInputFormatter
  final enabled;

  SimpleAutocompleteTextField(
      {this.key,
      this.minSearchLength: 1,
      this.maxSuggestions: 3,
      @required this.itemBuilder,
      @required this.onSearch,
      this.itemParser,
      this.onChanged,

      /// If not null, the TextField [decoration]'s suffixIcon will be
      /// overridden to reset the input using the icon defined here.
      this.resetIcon: Icons.close,
      Builder itemContainerBuilder,
      bool autovalidate: false,
      this.validator,
      this.onFieldSubmitted,
      this.onSaved,

      // TextFormField properties
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
      this.inputFormatters //TextInputFormatter
      })
      : controller = controller ??
            TextEditingController(text: _toString<T>(initialValue, itemParser)),
        focusNode = focusNode ?? FocusNode(),
        super(
            key: key,
            autovalidate: autovalidate,
            validator: validator,
            onSaved: onSaved,
            builder: (FormFieldState<T> field) {
              // final _SimpleAutocompleteTextFieldState<T> state = field;
            });

  @override
  _SimpleAutocompleteTextFieldState<T> createState() =>
      _SimpleAutocompleteTextFieldState<T>(this);
}

class _SimpleAutocompleteTextFieldState<T> extends FormFieldState<T> {
  final SimpleAutocompleteTextField<T> parent;
  List<T> suggestions;
  bool showSuggestions = false;
  bool showResetIcon = false;

  _SimpleAutocompleteTextFieldState(this.parent) {
    parent.controller.addListener(() {
      // debugPrint('Setting state...');
      setState(() {
        showSuggestions =
            parent.controller.text.trim().length >= parent.minSearchLength;
        if (parent.resetIcon != null &&
            parent.controller.text.isEmpty == showResetIcon) {
          showResetIcon = !showResetIcon;
        }
      });
    });
    parent.focusNode.addListener(() {
      if (!parent.focusNode.hasFocus) {
        // debugPrint('Setting state...');
        setState(() => showSuggestions = false);
      }
    });
  }

  @override
  void setValue(T value) {
    super.setValue(value);
    if (parent.onChanged != null) parent.onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      TextFormField(
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
        onFieldSubmitted: (value) {
          if (parent.onFieldSubmitted != null) {
            return parent
                .onFieldSubmitted(_toObject<T>(value, parent.itemParser));
          }
        },
        validator: (value) {
          if (parent.validator != null) {
            return parent.validator(_toObject<T>(value, parent.itemParser));
          }
        },
        onSaved: (value) {
          if (parent.onSaved != null) {
            return parent.onSaved(_toObject<T>(value, parent.itemParser));
          }
        },
      ),
      showSuggestions
          ? FutureBuilder<List<Widget>>(
              future: _buildSuggestions(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: snapshot.data,
                  );
                } else if (snapshot.hasError) {
                  return new Text('${snapshot.error}');
                }
                return Center(child: CircularProgressIndicator());
              },
            )
          : Container(height: 0.0, width: 0.0),
    ]);
  }

  Future<List<Widget>> _buildSuggestions() async {
    final list = List<Widget>();
    final suggestions = await parent.onSearch(parent.controller.text);
    suggestions
        ?.take(parent.maxSuggestions)
        ?.forEach((suggestion) => list.add(InkWell(
              child: parent.itemBuilder(context, suggestion),
              onTap: () {
                parent.controller.text = _toString(suggestion, parent.itemParser);
                parent.focusNode.unfocus();
                setValue(suggestion);
              },
            )));
    return list;
  }
}

String _toString<T>(T value, ItemParser parser) =>
    parser?.asString(value) ?? value?.toString() ?? '';

T _toObject<T>(String string, ItemParser parser) =>
    parser?.parse(string) ?? null;
