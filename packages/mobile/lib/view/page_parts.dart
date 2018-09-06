import 'package:flutter/material.dart';
import 'package:toledotechevents_mobile/providers.dart';
import 'package:url_launcher/url_launcher.dart';

export 'package:toledotechevents_mobile/resources.dart';
export 'package:toledotechevents_mobile/providers.dart';
export 'package:toledotechevents_mobile/theme.dart';
export 'package:toledotechevents_mobile/view/fade_scale_in.dart';

Widget defaultTitle(BuildContext context, [PageData data]) => Row(
      children: <Widget>[
        Text(
          'Toledo',
          style: TextStyle(
              color: data == null
                  ? Colors.white
                  : Color(data.theme.onPrimaryColor.argb)),
        ),
        SizedBox(width: 3.0),
        Text(
          'Tech Events',
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
      ],
    );

Scaffold buildScaffold(
    BuildContext context, PageData pageData, WidgetBuilder bodyBuilder,
    [WidgetBuilder fabBuilder]) {
  return Scaffold(
    appBar: buildAppBar(context, pageData),
    body: bodyBuilder(context),
    bottomNavigationBar: pageData.layout.nav == MainNavigation.bottom
        ? buildBottomNav(context, pageData)
        : null,
    floatingActionButton: fabBuilder == null ? null : fabBuilder(context),
  );
}

AppBar buildAppBar(BuildContext context, PageData pageData) {
  return AppBar(
    title: pageData.page.title == null
        ? defaultTitle(context, pageData)
        : Text(pageData.page.title,
            style: TextStyle(color: Color(pageData.theme.onPrimaryColor.argb))),
    actions: [buildOverflowMenu(context, pageData)],
    // bottom: pageData.layout.nav == MainNavigation.top
    // ? TabBar(tabs: pageData.layout.nav.items.map((page, label) =>
    // ),)
    // : null,
  );
}

List<Widget> _buildTabs() {}

Widget buildOverflowMenu(BuildContext context, PageData pageData) {
  final options = List<PopupMenuEntry<String>>();

  void tryAdd(MenuOption opt, arg) => pageData.layout.menuOptions.contains(opt)
      ? options
          .add(PopupMenuItem(child: Text(opt.title), value: opt.action(arg)))
      : null;

  void _overflowItemSelected(String action) async {
    if (action == MenuOption.removeSpam.action(null)) {
      AppDataProvider.of(context)
          .pageRequest
          .add(PageRequest(Page.spamRemover));
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
        options.clear();
        // Main.
        tryAdd(MenuOption.pastEvents, null);
        tryAdd(MenuOption.subscribeAllGoogle, null);
        tryAdd(MenuOption.subscribeAllICal, null);
        tryAdd(MenuOption.visitForum, null);
        tryAdd(MenuOption.reportIssue, null);
        // Event.
        tryAdd(MenuOption.editEvent, pageData.args['id']);
        tryAdd(MenuOption.cloneEvent, pageData.args['id']);
        // Venue.
        tryAdd(MenuOption.pastVenueEvents, pageData.args['id']);
        tryAdd(MenuOption.subscribeVenueGoogle, pageData.args['id']);
        tryAdd(MenuOption.subscribeVenueICal, pageData.args['id']);
        tryAdd(MenuOption.editVenue, pageData.args['id']);
        // Venue list extra option.
        tryAdd(MenuOption.removeSpam, null);

        return options;
      });
}

Widget buildBottomNav(BuildContext context, PageData pageData) {
  Icon iconFor(Page page) {
    switch (page) {
      case Page.eventList:
        return Icon(Icons.event);
      case Page.createEvent:
        return Icon(Icons.add_circle_outline);
      case Page.venueList:
        return Icon(Icons.business);
      case Page.about:
        return Icon(Icons.help);
      default:
        return null;
    }
  }

  final items = List<BottomNavigationBarItem>();
  pageData.layout.nav.items.forEach((page, title) => items.add(
      BottomNavigationBarItem(
          title: Text(title, style: Theme.of(context).textTheme.button),
          icon: iconFor(page))));

  return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex:
          pageData.layout.nav.items.keys.toList().indexOf(pageData.page),
      iconSize: 24.0,
      onTap: (index) {
        final page = pageData.layout.nav.items.keys.toList()[index];
        print('tapped $index: ${page.route}');
        AppDataProvider.of(context).pageRequest.add(PageRequest(page));
      },
      items: items);
}
