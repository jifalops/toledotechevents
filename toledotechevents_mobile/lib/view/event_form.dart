import 'dart:core';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';
import 'package:toledotechevents/forms.dart';
import 'package:toledotechevents_mobile/view/page_container.dart';

class EventFormView extends StatefulWidget {
  EventFormView(this.authToken, this.pageData);
  final String authToken;
  final PageData pageData;

  @override
  _EventFormViewState createState() {
    return _EventFormViewState();
  }
}

class _EventFormViewState extends State<EventFormView> {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final venueController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();

  bool autovalidate = false;
  VenueListItem selectedVenue;

  void startTimeListener(DateTime value) {
    if (value != null) startTimeController.text = EventForm.date.format(value);
  }

  void endTimeListener(DateTime value) {
    if (value != null) endTimeController.text = EventForm.date.format(value);
  }

  @override
  void initState() {
    super.initState();
    EventInput.startTime.addListener(startTimeListener);
    EventInput.endTime.addListener(endTimeListener);
    EventInput.authToken.value = widget.authToken;
  }

  @override
  void dispose() {
    EventInput.startTime.removeListener(startTimeListener);
    EventInput.endTime.removeListener(endTimeListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      buildScaffold(context, widget.pageData, _buildBody);

  _showSnackBar(BuildContext context, String text) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: Duration(milliseconds: 3000),
      ),
    );
  }

  void _handleSubmitted() {
    final FormState form = formKey.currentState;
    if (form.validate()) {
      form.save();
      eventForm.submit();
    } else {
      // Start validating on every change.
      setState(() => autovalidate = true);
      _showSnackBar(context, 'Fix fields outlined in red.');
    }
  }

  Widget _buildBody(BuildContext context) {
    return Form(
      key: formKey,
      autovalidate: autovalidate,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: 800.0),
              child: Column(
                children: <Widget>[
                  Text('Add Event',
                      style: Theme.of(context).textTheme.headline),
                  SizedBox(height: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: _buildInputs(context),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: PrimaryButton(
                        context,
                        'CREATE EVENT',
                        _handleSubmitted,
                        widget.pageData.theme,
                        color: Theme.of(context).primaryColor,
                        textColor:
                            Color(widget.pageData.theme.onPrimaryColor.argb),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildInputs(BuildContext context) {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: EventInput.name.label()),
        validator: EventInput.name.validator,
        onSaved: (value) => EventInput.name.value = value,
      ),
      SizedBox(height: 8.0),
      StreamHandler<VenueList>(
        stream: AppDataProvider.of(context).venues,
        handler: _buildVenueInput,
      ),
      SizedBox(height: 8.0),
      DateTimePickerFormField(
        controller: startTimeController,
        format: EventForm.date,
        decoration: InputDecoration(labelText: EventInput.startTime.label()),
        validator: EventInput.startTime.validator,
        onSaved: (value) => EventInput.startTime.value = value,
        onChanged: (value) => EventInput.startTime.value = value,
      ),
      SizedBox(height: 8.0),
      DateTimePickerFormField(
        controller: endTimeController,
        format: EventForm.date,
        decoration: InputDecoration(labelText: EventInput.endTime.label()),
        validator: EventInput.endTime.validator,
        onSaved: (value) => EventInput.endTime.value = value,
        onChanged: (value) => EventInput.endTime.value = value,
      ),
      SizedBox(height: 8.0),
      TextFormField(
        decoration: InputDecoration(labelText: EventInput.rsvp.label()),
        validator: EventInput.rsvp.validator,
        onSaved: (value) => EventInput.rsvp.value = value,
      ),
      SizedBox(height: 8.0),
      TextFormField(
        decoration: InputDecoration(labelText: EventInput.website.label()),
        validator: EventInput.website.validator,
        onSaved: (value) => EventInput.website.value = value,
      ),
      SizedBox(height: 8.0),
      TextFormField(
        decoration: InputDecoration(
          labelText: EventInput.description.label(),
          helperText: EventInput.description.helperText(),
        ),
        onSaved: (value) => EventInput.description.value = value,
        maxLines: null, // auto-grow
      ),
      SizedBox(height: 8.0),
      TextFormField(
        decoration: InputDecoration(
          labelText: EventInput.venueDetails.label(),
          helperText: EventInput.venueDetails.helperText(),
        ),
        onSaved: (value) => EventInput.venueDetails.value = value,
        maxLines: null, // auto-grow
      ),
      SizedBox(height: 8.0),
      TextFormField(
        decoration: InputDecoration(
          labelText: EventInput.tags.label(),
          helperText: EventInput.tags.helperText(),
        ),
        onSaved: (value) => EventInput.tags.value = value,
      )
    ];
  }

  Widget _buildVenueInput(BuildContext context, VenueList venues) {
    return SimpleAutocompleteFormField<VenueListItem>(
      maxSuggestions: 10,
      controller: venueController,
      decoration: InputDecoration(
        labelText: EventInput.venue.label(),
        helperText: EventInput.venue.helperText(selectedVenue?.address),
      ),
      onChanged: (value) => setState(() => selectedVenue = value),
      onSaved: (value) {
        selectedVenue = value;
        EventInput.venue.value = venueController.text;
      },
      itemBuilder: (context, venue) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(venue.title, style: TextStyle(fontWeight: FontWeight.w600)),
              Text(
                venue.address,
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
      itemParser: ItemParser<VenueListItem>(
        itemToString: (item) => item?.title ?? '',
        itemFromString: (string) => venues.findByTitle(string),
      ),
      onSearch: (search) async {
        search = search.toLowerCase().trim();
        final results = VenueList.from(venues.where((v) =>
            v.title.toLowerCase().contains(search) ||
            v.address.toLowerCase().contains(search)));
        _sortVenues(results, search);
        return results;
      },
    );
  }
}

void _sortVenues(VenueList results, String search) {
  results.sort((a, b) {
    int mostPopular(VenueListItem a, VenueListItem b) {
      return b.eventCount - a.eventCount;
    }

    final aTitleStartsWith = a.title.toLowerCase().startsWith(search);
    final bTitleStartsWith = b.title.toLowerCase().startsWith(search);
    if (aTitleStartsWith && bTitleStartsWith)
      return mostPopular(a, b);
    else if (aTitleStartsWith)
      return -1;
    else if (bTitleStartsWith)
      return 1;
    else {
      final aTitleContains = a.title.toLowerCase().contains(search);
      final bTitleContains = b.title.toLowerCase().contains(search);
      if (aTitleContains && bTitleContains)
        return mostPopular(a, b);
      else if (aTitleContains)
        return -1;
      else if (bTitleContains)
        return 1;
      else {
        final aAddressContains = a.address.toLowerCase().contains(search);
        final bAddressContains = b.address.toLowerCase().contains(search);
        if (aAddressContains && bAddressContains)
          return mostPopular(a, b);
        else if (aAddressContains)
          return -1;
        else if (bAddressContains)
          return 1;
        else {
          return mostPopular(a, b);
        }
      }
    }
  });
}
