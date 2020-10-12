import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timetracker/app/home/tab_item.dart';

class CupertionHomeScaffold extends StatelessWidget {
  const CupertionHomeScaffold({
    Key key,
    @required this.currentTab,
    @required this.onSelectedTab,
    @required this.widgetsBuilder,
    @required this.navigatorKeys,
  }) : super(key: key);
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectedTab;
  final Map<TabItem, WidgetBuilder> widgetsBuilder;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          _buildItem(TabItem.jobs),
          _buildItem(TabItem.entries),
          _buildItem(TabItem.account),
        ],
        onTap: (index) => onSelectedTab(TabItem.values[index]),
      ),
      tabBuilder: (context, index) {
        final item = TabItem.values[index];
        return CupertinoTabView(
          navigatorKey: navigatorKeys[item],
          builder: (context) => widgetsBuilder[item](context),
        );
      },
    );
  }

  BottomNavigationBarItem _buildItem(TabItem tabItem) {
    final itemData = TabItemData.allTabs[tabItem];
    final color = currentTab == tabItem ? Colors.indigo : Colors.grey;
    return BottomNavigationBarItem(
      icon: Icon(
        itemData.iconData,
        color: color,
      ),
      title: Text(
        itemData.title,
        style: TextStyle(color: color),
      ),
    );
  }
}
