import 'package:flutter/material.dart';
import 'package:toledotechevents/bloc/layout_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

Widget buildMenuOptions(BuildContext context, LayoutData data,
    LayoutBloc layoutBloc, Function failHandler) {
  final options = List<PopupMenuEntry<String>>();

  void tryAdd(MenuOption opt, arg) => data.layout.menuOptions.contains(opt)
      ? options
          .add(PopupMenuItem(child: Text(opt.title), value: opt.action(arg)))
      : null;

  void _overflowItemSelected(String action) async {
    if (action == MenuOption.removeSpam.action(null)) {
      layoutBloc.page.add(PageRequest(Page.spamRemover));
    } else if (await canLaunch(action)) {
      launch(action);
    } else {
      failHandler();
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
