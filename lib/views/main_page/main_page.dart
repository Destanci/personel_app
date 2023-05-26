import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/employee_card.dart';
import '../../core/_utils/utilities.dart';
import '../../core/models/paged_request_model.dart';
import '../../managers/api_manager.dart';
import '../../managers/connection_manager.dart';
import '../../managers/employee_manager.dart';
import '../../models/filter_models/employee_filter.dart';
import 'main_page_filter.dart';
import 'main_page_order.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final ApiManager _apiManager = ApiManager();
  final EmployeeManager _employeeManager = EmployeeManager();

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  List<RequestOrder> orderList = [];

  EmployeeFilter? _filter;
  EmployeeFilter? get filter => _filter;
  set filter(EmployeeFilter? value) {
    setState(() {
      _filter = value;
    });
    refreshList();
  }

  bool _showSearch = false;
  bool get showSearch => _showSearch;
  set showSearch(bool value) {
    Utilities.closeKeyboard(context);
    setState(() {
      _showSearch = value;
    });
  }

  bool _showScrollTop = false;
  bool _requested = false;

  CancelableOperation? _searchTimeout = null;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      double scrollOffset = 10;

      if (_scrollController.offset > scrollOffset) {
        setState(() {
          _showScrollTop = true;
        });
      } else {
        setState(() {
          _showScrollTop = false;
        });
      }
    });
    _scrollController.addListener(() {
      if (!_employeeManager.endOfList) {
        if (_scrollController.position.extentAfter <= 0) {
          if (!_requested) {
            _requested = true;
            setState(() {
              _apiManager.getEmployees(
                PagedRequest(
                  start: _employeeManager.list.length,
                  length: 10,
                ),
                filter: filter,
                search: showSearch ? _searchController.text : null,
                orderList: orderList,
              );
            });
          }
        } else {
          _requested = false;
        }
      }
    });
  }

  Future refreshList() async {
    await _apiManager.getEmployees(
      PagedRequest(
        start: 0,
        length: 10,
      ),
      filter: filter,
      search: showSearch ? _searchController.text : null,
      orderList: orderList,
      clearList: true,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();

    super.dispose();
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
              filter != null ? Icons.filter_alt : Icons.filter_alt_outlined,
            ),
            onPressed: () async {
              dynamic val = await showDialog(
                context: context,
                builder: (context) {
                  return MainPageFilter(
                    filter: filter,
                    onReset: () => filter = null,
                  );
                },
              );
              if (val is EmployeeFilter) {
                filter = val;
              }
            },
          ),
          IconButton(
            icon: Icon(
              _showSearch ? Icons.search_off : Icons.search_rounded,
            ),
            onPressed: () {
              showSearch = !showSearch;
              if (showSearch == false) refreshList();
            },
          ),
          IconButton(
            icon: Transform.flip(
              flipX: true,
              child: Icon(
                Icons.sort,
              ),
            ),
            onPressed: () async {
              dynamic val = await showDialog(
                context: context,
                builder: (context) {
                  return MainPageOrder(
                    orderList: orderList,
                    onReset: () {
                      orderList.clear();
                      refreshList();
                    },
                  );
                },
              );
              if (val is List<RequestOrder>) {
                orderList = val;
                refreshList();
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => refreshList(),
        child: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverAppBar(
              pinned: true,
              titleSpacing: 0,
              toolbarHeight: showSearch ? kToolbarHeight : 0,
              title: Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: TextField(
                  controller: _searchController,
                  cursorColor: Theme.of(context).appBarTheme.foregroundColor,
                  style: TextStyle(
                    color: Theme.of(context).appBarTheme.foregroundColor,
                  ),
                  onChanged: (value) {
                    _searchTimeout?.cancel();
                    _searchTimeout = CancelableOperation.fromFuture(
                      Future.delayed(
                        Duration(seconds: 1),
                        () => refreshList(),
                      ),
                    );
                  },
                  onSubmitted: (_) => refreshList(),
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
                      onPressed: () {
                        refreshList();
                        if (_searchController.text.isEmpty) {
                          showSearch = false;
                        } else {
                          _searchController.clear();
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
            Consumer<EmployeeManager>(
              builder: (context, manager, child) {
                return manager.list.length > 0
                    ? SliverList(
                        delegate: SliverChildBuilderDelegate(
                          childCount: manager.list.length,
                          (context, index) {
                            return EmployeeTile(employee: manager.list.elementAt(index));
                          },
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                        childCount: 1,
                        (context, index) {
                          return Center(
                              child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: ConnectionManager().hasConnection
                                ? manager.recordsFiltered == 0
                                    ? Text('Veri Bulunamadı')
                                    : CircularProgressIndicator()
                                : Text('Bağlantı Kurulamadı'),
                          ));
                        },
                      ));
              },
            ),
          ],
        ),
      ),
      floatingActionButton: _showScrollTop
          ? FloatingActionButton(
              onPressed: () {
                _scrollController.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
              },
              child: Icon(
                Icons.arrow_upward,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
            )
          : FloatingActionButton(
              onPressed: () {
                // Navigator.push(context, );
              },
              child: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
    );
  }
}
