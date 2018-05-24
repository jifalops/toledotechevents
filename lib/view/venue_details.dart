import 'package:flutter/material.dart';
import '../model.dart';

class VenueDetails extends StatelessWidget {
  final Venue venue;

  VenueDetails(this.venue);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Venue details'),
        ),
        body: Text(venue.toString()));
  }
}
