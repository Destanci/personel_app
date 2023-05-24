import 'package:flutter/material.dart';
import 'package:personel_app/core/models/paged_request_model.dart';
import 'package:personel_app/models/filter_models/employee_filter.dart';

class MainPageFilter extends StatefulWidget {
  final void Function()? onSubmit;
  final void Function()? onReset;
  const MainPageFilter({Key? key, this.onSubmit, this.onReset, this.filter}) : super(key: key);

  final EmployeeFilter? filter;

  @override
  _MainPageFilterState createState() => _MainPageFilterState();
}

class _MainPageFilterState extends State<MainPageFilter> {
  RangeValues _currentRangeValues = const RangeValues(0, 100);

  @override
  void initState() {
    super.initState();

    _currentRangeValues = RangeValues(
      widget.filter?.minAge == null ? 0 : widget.filter!.minAge!,
      widget.filter?.maxAge == null ? 100 : widget.filter!.maxAge!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.only(top: 24, left: 16, bottom: 16),
      contentPadding: EdgeInsets.symmetric(horizontal: 4),
      title: Text("Filtreler"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            onTap: null,
            title: Row(
              children: [
                Expanded(
                  child: Text('Yaş Aralığı:'),
                ),
                Text('${_currentRangeValues.start.floor()} - ${_currentRangeValues.end.floor()}')
              ],
            ),
            subtitle: RangeSlider(
              values: _currentRangeValues,
              min: 0,
              max: 100,
              onChanged: (RangeValues values) {
                setState(() {
                  _currentRangeValues = values;
                });
              },
            ),
          )
        ],
      ),
      actions: [
        OutlinedButton(
          child: Text('Sıfırla'),
          onPressed: () {
            widget.onReset?.call();
            Navigator.pop(context, null);
          },
        ),
        ElevatedButton(
          child: Text('Uygula'),
          onPressed: () {
            widget.onSubmit?.call();
            Navigator.pop(context, PagedRequest(draw: 0, start: 0, length: 10));
          },
        ),
      ],
    );
  }
}
