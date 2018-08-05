import 'package:flutter/material.dart';
import 'package:toledotechevents_mobile/provider/layout_provider.dart'
    hide Color;
import 'package:url_launcher/url_launcher.dart';

AppBar buildAppBar(BuildContext context, LayoutData data) {
  Widget defaultTitle() => Row(
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
      title: data.page.title ?? defaultTitle(),
      actions: [buildMenuOptions(context, data)],
      bottom: data.layout.mainNavigation == MainNavigation.top
      ? TabBar(tabs: <Widget>[],)
      : null,
      );
}

Widget buildMenuOptions(BuildContext context, LayoutData data) {
  final options = List<PopupMenuEntry<String>>();

  void tryAdd(MenuOption opt, arg) => data.layout.menuOptions.contains(opt)
      ? options
          .add(PopupMenuItem(child: Text(opt.title), value: opt.action(arg)))
      : null;

  void _overflowItemSelected(String action) async {
    if (action == MenuOption.removeSpam.action(null)) {
      LayoutProvider.of(context).page.add(PageRequest(Page.spamRemover));
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
