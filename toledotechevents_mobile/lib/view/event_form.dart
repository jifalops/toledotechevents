import 'dart:core';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';
import 'package:toledotechevents/forms.dart';
import 'package:toledotechevents_mobile/view/page_parts.dart';

class EventFormView extends StatefulWidget {
  EventFormView(this.pageData);
  final PageData pageData;

  @override
  _EventFormViewState createState() {
    return _EventFormViewState();
  }
}

class _EventFormViewState extends State<EventFormView> {
  _EventFormViewState() {
    form.startTime.addListener((value) {
      if (value != null)
        startTimeController.text = EventForm.date.format(value);
    });
    form.endTime.addListener((value) {
      if (value != null) endTimeController.text = EventForm.date.format(value);
    });
  }

  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final venueController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  final form = EventForm();

  bool autovalidate = false;
  VenueListItem selectedVenue;
  bool submitting = false;

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

  void _handleSubmitted() async {
    final FormState formState = formKey.currentState;
    if (formState.validate()) {
      formState.save();
      setState(() => submitting = true);
      final resources = AppDataProvider.of(context).resources;
      form.authToken.value = (await resources.authToken.get())?.value;
      final result = await form.submit(
          venueId: selectedVenue?.title?.trim() == form.venue.value
              ? selectedVenue?.id
              : null,
          eventsResource: resources.eventList,
          venuesResource: resources.venueList);
      _showSnackBar(context, result.message);
      if (result.created) {
        if (result.foundInFeed) {
          AppDataProvider.of(context)
              .pageRequest
              .add(PageRequest(Page.eventDetails, args: {
                'details': EventDetails(result.events.findById(result.id),
                    resources.eventDetails(result.id))
              }));
        } else {
          // TODO load past event details from event id.
          Navigator.of(context).pop();
          AppDataProvider.of(context)
              .pageRequest
              .add(PageRequest(Page.eventList));
        }
      }
      setState(() => submitting = false);
    } else {
      // Start validating on every change.
      setState(() => autovalidate = true);
      _showSnackBar(context, 'Fix fields outlined in red.');
    }
  }

  Widget _buildBody(BuildContext context) {
    return FadeScaleIn(Form(
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
                      child: submitting
                          ? CircularProgressIndicator()
                          : PrimaryButton(
                              context,
                              'CREATE EVENT',
                              _handleSubmitted,
                              widget.pageData.theme,
                              color: Theme.of(context).primaryColor,
                              textColor: Color(
                                  widget.pageData.theme.onPrimaryColor.argb),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }

  List<Widget> _buildInputs(BuildContext context) {
    final appBloc = AppDataProvider.of(context);
    return [
      TextFormField(
        decoration: InputDecoration(labelText: form.name.label()),
        validator: form.name.validator,
        onSaved: (value) => form.name.value = value,
      ),
      SizedBox(height: 8.0),
      StreamHandler<VenueList>(
        stream: appBloc.venues,
        initialData: appBloc.lastVenueList,
        handler: _buildVenueInput,
      ),
      SizedBox(height: 8.0),
      DateTimePickerFormField(
        controller: startTimeController,
        format: EventForm.date,
        decoration: InputDecoration(labelText: form.startTime.label()),
        validator: form.startTime.validator,
        onSaved: (value) => form.startTime.value = value,
        onChanged: (value) => form.startTime.value = value,
      ),
      SizedBox(height: 8.0),
      DateTimePickerFormField(
        controller: endTimeController,
        format: EventForm.date,
        decoration: InputDecoration(labelText: form.endTime.label()),
        validator: form.endTime.validator,
        onSaved: (value) => form.endTime.value = value,
        onChanged: (value) => form.endTime.value = value,
      ),
      SizedBox(height: 8.0),
      TextFormField(
        decoration: InputDecoration(labelText: form.rsvp.label()),
        validator: form.rsvp.validator,
        onSaved: (value) => form.rsvp.value = value,
      ),
      SizedBox(height: 8.0),
      TextFormField(
        decoration: InputDecoration(labelText: form.website.label()),
        validator: form.website.validator,
        onSaved: (value) => form.website.value = value,
      ),
      SizedBox(height: 8.0),
      TextFormField(
        decoration: InputDecoration(
          labelText: form.description.label(),
          helperText: form.description.helperText(),
        ),
        onSaved: (value) => form.description.value = value,
        maxLines: null, // auto-grow
      ),
      SizedBox(height: 8.0),
      TextFormField(
        decoration: InputDecoration(
          labelText: form.venueDetails.label(),
          helperText: form.venueDetails.helperText(),
        ),
        onSaved: (value) => form.venueDetails.value = value,
        maxLines: null, // auto-grow
      ),
      SizedBox(height: 8.0),
      TextFormField(
        decoration: InputDecoration(
          labelText: form.tags.label(),
          helperText: form.tags.helperText(),
        ),
        onSaved: (value) => form.tags.value = value,
      )
    ];
  }

  Widget _buildVenueInput(BuildContext context, VenueList venues) {
    return SimpleAutocompleteFormField<VenueListItem>(
      maxSuggestions: 10,
      controller: venueController,
      decoration: InputDecoration(
        labelText: form.venue.label(),
        helperText: form.venue.helperText(selectedVenue?.address),
      ),
      onChanged: (value) => setState(() => selectedVenue = value),
      onSaved: (value) {
        selectedVenue = value;
        form.venue.value = venueController.text;
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
