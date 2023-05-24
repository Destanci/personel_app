import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:personel_app/core/_utils/utilities.dart';
import 'package:personel_app/views/main_page_filter.dart';
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
  final TextEditingController _searchController = TextEditingController();

  bool _filterActive = false;
  bool get filterActive => _filterActive;
  set filterActive(bool value) {
    setState(() {
      _filterActive = value;
    });
  }

  bool _showSearch = false;
  bool get showSearch => _showSearch;
  set showSearch(bool value) {
    Utilities.closeKeyboard(context);
    setState(() {
      _showSearch = value;
    });
  }

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
        actions: [
          IconButton(
            icon: Icon(
              _filterActive ? Icons.filter_alt : Icons.filter_alt_outlined,
            ),
            onPressed: () async {
              dynamic val = await showDialog(
                context: context,
                builder: (context) {
                  return MainPageFilter(
                    onSubmit: () {
                      filterActive = true;
                    },
                    onReset: () {
                      filterActive = false;
                    },
                  );
                },
              );

              developer.log(val.toString());
              if (val != null) {}
            },
          ),
          IconButton(
            icon: Icon(
              _showSearch ? Icons.search_off : Icons.search_rounded,
            ),
            onPressed: () {
              developer.log('Search');
              showSearch = !_showSearch;
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          developer.log('Refresh');
        },
        child: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverAppBar(
              pinned: true,
              titleSpacing: 0,
              toolbarHeight: _showSearch ? kToolbarHeight : 0,
              title: Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: TextField(
                  controller: _searchController,
                  cursorColor: Theme.of(context).appBarTheme.foregroundColor,
                  style: TextStyle(
                    color: Theme.of(context).appBarTheme.foregroundColor,
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    hintText: 'Ara...',
                    hintStyle: TextStyle(
                      color: Theme.of(context).appBarTheme.foregroundColor,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).appBarTheme.foregroundColor!,
                        width: 1,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).appBarTheme.foregroundColor!,
                        width: 1,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: Theme.of(context).appBarTheme.foregroundColor,
                      ),
                      onPressed: () => _searchController.clear(),
                    ),
                  ),
                ),
              ),
            ),
            Consumer<EmployeeManager>(
              builder: (context, manager, child) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: manager.list.length,
                    (context, index) {
                      return EmployeeTile(employee: manager.list.elementAt(index));
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
