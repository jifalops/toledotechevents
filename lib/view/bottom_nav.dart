
import 'package:flutter/material.dart';

BottomNavigationBar getBottomNav(BuildContext context, onTap) {
  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    iconSize: 24.0,
    onTap: onTap,
    items: [
      BottomNavigationBarItem(
        title: Text('Events', style: Theme.of(context).textTheme.button),
        icon: Icon(Icons.event),
      ),
      BottomNavigationBarItem(
        title: Text('New', style: Theme.of(context).textTheme.button),
        icon: Icon(Icons.add_circle_outline),
      ),
      BottomNavigationBarItem(
        title: Text('Venues', style: Theme.of(context).textTheme.button),
        icon: Icon(Icons.business),
      ),
      BottomNavigationBarItem(
        title: Text('About', style: Theme.of(context).textTheme.button),
        icon: Icon(Icons.help),
      ),
    ],
  );
}
