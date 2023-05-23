import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/employee_card.dart';
import '../managers/employee_manager.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Consumer<EmployeeManager>(
        builder: (context, manager, child) => RefreshIndicator(
          onRefresh: () async {},
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: false,
                snap: false,
                floating: false,
                expandedHeight: 160.0,
                flexibleSpace: const FlexibleSpaceBar(
                  title: Text('SliverAppBar'),
                  background: FlutterLogo(),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: (manager.list.length / 2).floor(),
                  (BuildContext context, int index) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(child: EmployeeCard(employee: manager.list.elementAt(index))),
                        if (index + 1 < manager.list.length / 2)
                          Flexible(child: EmployeeCard(employee: manager.list.elementAt(index + 1)))
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*
ListView.builder(
  controller: _scrollController,
  physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
  padding: EdgeInsets.only(bottom: 4, top: 4),
  itemCount: manager.list.length,
  itemBuilder: (context, index) {
    return EmployeeCard(employee: manager.list.elementAt(index));
  },
)

SliverList.builder(
  itemCount: manager.list.length,
  itemBuilder: (BuildContext context, int index) {
    return EmployeeCard(employee: manager.list.elementAt(index));
  },
)
*/