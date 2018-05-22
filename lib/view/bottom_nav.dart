
import 'package:flutter/material.dart';

BottomNavigationBar getBottomNav(BuildContext context, onTap) {
  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    iconSize: 24.0,
    onTap: onTap,
    items: [
      BottomNavigationBarItem(
        title: Text('Events'),
        icon: Icon(Icons.event),
      ),
      BottomNavigationBarItem(
        title: Text('New'),
        icon: Icon(Icons.add_circle_outline),
      ),
      BottomNavigationBarItem(
        title: Text('Venues'),
        icon: Icon(Icons.business),
      ),
      BottomNavigationBarItem(
        title: Text('About'),
        icon: Icon(Icons.help),
      ),
    ],
  );
}
