import 'package:flutter/material.dart';
import 'package:toledotechevents_mobile/providers.dart' hide Theme, Color;
import 'package:url_launcher/url_launcher.dart';

class LayoutView extends StatelessWidget {
  final PageLayoutData data;
  final WidgetBuilder bodyBuilder;

  LayoutView(this.data, this.bodyBuilder);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: bodyBuilder(context),
      bottomNavigationBar: data.layout.nav == MainNavigation.bottom
          ? _buildBottomNav(context)
          : null,
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    Widget defaultTitle = Row(
      children: <Widget>[
        Text('Toledo'),
        SizedBox(width: 3.0),
        Text(
          'Tech Events',
          style: TextStyle(color: Color(data.theme.secondaryColor.argb)),
        ),
      ],
    );
    return AppBar(
      title: data.page.title ?? defaultTitle,
      actions: [_buildOverflowMenu(context)],
      // bottom: data.layout.nav == MainNavigation.top
      // ? TabBar(tabs: data.layout.nav.items.map((page, label) =>
      // ),)
      // : null,
    );
  }

  Widget _buildOverflowMenu(BuildContext context) {
    final options = List<PopupMenuEntry<String>>();

    void tryAdd(MenuOption opt, arg) => data.layout.menuOptions.contains(opt)
        ? options
            .add(PopupMenuItem(child: Text(opt.title), value: opt.action(arg)))
        : null;

    void _overflowItemSelected(String action) async {
      if (action == MenuOption.removeSpam.action(null)) {
        PageLayoutProvider.of(context).request.add(PageRequest(Page.spamRemover));
      } else if (await canLaunch(action)) {
        launch(action);
      } else {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('Unable to launch URL.')));
      }
    }

    return PopupMenuButton(
        icon: Icon(Icons.more_vert),
        onSelected: _overflowItemSelected,
        itemBuilder: (context) {
          // Main.
          tryAdd(MenuOption.pastEvents, null);
          tryAdd(MenuOption.subscribeAllGoogle, null);
          tryAdd(MenuOption.subscribeAllICal, null);
          tryAdd(MenuOption.visitForum, null);
          tryAdd(MenuOption.reportIssue, null);
          // Event.
          tryAdd(MenuOption.editEvent, data.args['id']);
          tryAdd(MenuOption.cloneEvent, data.args['id']);
          // Venue.
          tryAdd(MenuOption.pastVenueEvents, data.args['id']);
          tryAdd(MenuOption.subscribeVenueGoogle, data.args['id']);
          tryAdd(MenuOption.subscribeVenueICal, data.args['id']);
          tryAdd(MenuOption.editVenue, data.args['id']);
          // Venue list extra option.
          tryAdd(MenuOption.removeSpam, null);

          return options;
        });
  }

  Widget _buildBottomNav(BuildContext context) {
    Icon iconFor(Page page) {
      switch (page) {
        case Page.eventList:
          return Icon(Icons.event);
        case Page.createEvent:
          return Icon(Icons.add_circle_outline);
        case Page.venuesList:
          return Icon(Icons.business);
        case Page.about:
          return Icon(Icons.help);
        default:
          return null;
      }
    }

    List<BottomNavigationBarItem> items;
    data.layout.nav.items.forEach((page, title) => items.add(
        BottomNavigationBarItem(
            title: Text(title, style: Theme.of(context).textTheme.button),
            icon: iconFor(page))));

    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: data.layout.nav.items.keys.toList().indexOf(data.page),
        iconSize: 24.0,
        onTap: (index) => PageLayoutProvider.of(context)
            .request
            .add(PageRequest(data.layout.nav.items.keys.toList()[index])),
        items: items);
  }
}
