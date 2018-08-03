import 'package:flutter/material.dart';
import 'package:toledotechevents/bloc/layout_bloc.dart' hide Color;
import 'menu_options.dart';

AppBar buildAppBar(BuildContext context, LayoutData data, LayoutBloc layoutBloc,
    Function failHandler) {
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
      actions: [buildMenuOptions(context, data, layoutBloc, failHandler)]);
}
