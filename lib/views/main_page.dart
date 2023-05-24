import 'dart:developer' as developer;
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
  final ScrollController _scrollController = ScrollController();
  // final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text('Personel Listesi'),
        actions: [],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            child: Scrollbar(
              child: RefreshIndicator(
                onRefresh: () async {
                  developer.log('Refresh');
                },
                child: Consumer<EmployeeManager>(
                  builder: (context, manager, child) => ListView.builder(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    padding: EdgeInsets.only(bottom: 4, top: 4),
                    itemCount: manager.list.length,
                    itemBuilder: (context, index) {
                      return EmployeeTile(employee: manager.list.elementAt(index));
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
