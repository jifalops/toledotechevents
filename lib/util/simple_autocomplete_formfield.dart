import 'dart:async';
import 'package:flutter/material.dart';

typedef Future<List<T>> Suggestions<T>(String search);
typedef Widget ItemBuilder<T>(BuildContext context, T item);

typedef String ItemToString<T>(T item);
typedef T ItemFromString<T>(String string);

class ItemParser<T> {
  final ItemToString itemToString;
  final ItemFromString itemFromString;
  ItemParser({@required this.itemFromString, @required this.itemToString});
}

class SimpleAutocompleteFormField<T> extends FormField<T> {
  final Key key;
  final int minSearchLength;
  final int maxSuggestions;
  final ItemBuilder<T> itemBuilder;
  final ItemParser<T> itemParser;
  final Suggestions<T> onSearch;
  final ValueChanged<T> onChanged;
  final IconData resetIcon;
  final double suggestionsContainerHeight;
  // TextFormField properties
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

  SimpleAutocompleteFormField(
      {this.key,
      this.minSearchLength: 1,
      this.maxSuggestions: 3,
      @required this.itemBuilder,
      @required this.onSearch,
      this.itemParser,
      this.onChanged,
      this.suggestionsContainerHeight,

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
  _SimpleAutocompleteFormFieldState<T> createState() =>
      _SimpleAutocompleteFormFieldState<T>(this);
}

class _SimpleAutocompleteFormFieldState<T> extends FormFieldState<T> {
  final SimpleAutocompleteFormField<T> parent;
  List<T> suggestions;
  bool showSuggestions = false;
  bool showResetIcon = false;
  T tappedSuggestion;

  _SimpleAutocompleteFormFieldState(this.parent);

  @override
  void initState() {
    super.initState();
    parent.focusNode.addListener(inputChanged);
    parent.controller.addListener(inputChanged);
  }

  @override
  void dispose() {
    parent.controller.removeListener(inputChanged);
    parent.focusNode.removeListener(inputChanged);
    super.dispose();
  }

  void inputChanged() {
    if (parent.focusNode.hasFocus) {
      setState(() {
        showSuggestions =
            parent.controller.text.trim().length >= parent.minSearchLength;
        if (parent.resetIcon != null &&
            parent.controller.text.trim().isEmpty == showResetIcon) {
          showResetIcon = !showResetIcon;
        }
      });
    } else {
      setState(() => showSuggestions = false);
      setValue(_value);
    }
  }

  T get _value => _toString<T>(tappedSuggestion, parent.itemParser) ==
          parent.controller.text
      ? tappedSuggestion
      : _toObject<T>(parent.controller.text, parent.itemParser);

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
            return parent.onFieldSubmitted(_value);
          }
        },
        validator: (value) {
          if (parent.validator != null) {
            return parent.validator(_value);
          }
        },
        onSaved: (value) {
          if (parent.onSaved != null) {
            return parent.onSaved(_value);
          }
        },
      ),
      showSuggestions
          ? FutureBuilder<List<Widget>>(
              future: _buildSuggestions(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    height: parent.suggestionsContainerHeight,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: snapshot.data,
                      ),
                    ),
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
                tappedSuggestion = suggestion;
                parent.controller.text =
                    _toString<T>(suggestion, parent.itemParser);
                parent.focusNode.unfocus();
              },
            )));
    return list;
  }
}

String _toString<T>(T value, ItemParser parser) =>
    parser?.itemToString(value) ?? value?.toString() ?? '';

T _toObject<T>(String string, ItemParser parser) =>
    parser?.itemFromString(string) ?? null;
