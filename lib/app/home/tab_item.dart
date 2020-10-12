import 'package:flutter/material.dart';

enum TabItem { jobs, entries, account }

class TabItemData {
  final String title;
  final IconData iconData;

  const TabItemData({@required this.title, @required this.iconData});
  static const Map<TabItem, TabItemData> allTabs = {
    TabItem.jobs: TabItemData(title: "Jobs", iconData: Icons.work),
    TabItem.entries:
        TabItemData(title: "Entries", iconData: Icons.view_headline),
    TabItem.account: TabItemData(title: "Account", iconData: Icons.person)
  };
}
