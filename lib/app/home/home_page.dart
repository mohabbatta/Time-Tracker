import 'package:flutter/material.dart';
import 'package:timetracker/app/home/account/account_page.dart';
import 'package:timetracker/app/home/cupertino_home_scaffold.dart';
import 'package:timetracker/app/home/entries/entries_page.dart';
import 'package:timetracker/app/home/jobs/jobs_page.dart';
import 'package:timetracker/app/home/tab_item.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _onSelect(TabItem tabItem) {
    if (tabItem == _currentTab) {
      navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentTab = tabItem;
      });
    }
  }

  TabItem _currentTab = TabItem.jobs;

  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.jobs: GlobalKey<NavigatorState>(),
    TabItem.entries: GlobalKey<NavigatorState>(),
    TabItem.account: GlobalKey<NavigatorState>(),
  };
  Map<TabItem, WidgetBuilder> get widgetsBuilder {
    return {
      TabItem.jobs: (_) => JobsPage(),
      TabItem.entries: (context) => EntriesPage.create(context),
      TabItem.account: (_) => AccountPage(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[_currentTab].currentState.maybePop(),
      child: CupertionHomeScaffold(
        currentTab: _currentTab,
        onSelectedTab: _onSelect,
        widgetsBuilder: widgetsBuilder,
        navigatorKeys: navigatorKeys,
      ),
    );
  }
}
