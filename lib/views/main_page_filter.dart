import 'package:flutter/material.dart';
import 'package:personel_app/components/BlockRadioButton.dart';
import 'package:personel_app/models/filter_models/employee_filter.dart';

import '../core/enums/gender_enum.dart';

class MainPageFilter extends StatefulWidget {
  final void Function()? onSubmit;
  final void Function()? onReset;
  const MainPageFilter({Key? key, this.onSubmit, this.onReset, this.filter}) : super(key: key);

  final EmployeeFilter? filter;

  @override
  _MainPageFilterState createState() => _MainPageFilterState();
}

class _MainPageFilterState extends State<MainPageFilter> {
  RangeValues _ageRangeValues = const RangeValues(0, 100);
  String? selectedDepartment;
  String? selectedPosition;

  bool filterMale = false;
  bool filterFemale = false;

  @override
  void initState() {
    super.initState();

    _ageRangeValues = RangeValues(
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
                Text('${_ageRangeValues.start.floor()} - ${_ageRangeValues.end.floor()}')
              ],
            ),
            subtitle: RangeSlider(
              values: _ageRangeValues,
              min: 0,
              max: 100,
              onChanged: (RangeValues values) {
                setState(() {
                  _ageRangeValues = values;
                });
              },
            ),
          ),
          ListTile(
            onTap: null,
            title: Text('Cinsiyet:'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                BlockRadioButton(
                  selected: filterMale,
                  icon: Icons.male,
                  onTap: (value) => filterMale = value,
                ),
                BlockRadioButton(
                  selected: filterFemale,
                  icon: Icons.female,
                  onTap: (value) => filterFemale = value,
                ),
              ],
            ),
          ),
          ListTile(
            onTap: null,
            title: Text('Departman'),
            subtitle: DropdownButton(
              isExpanded: false,
              icon: Container(),
              hint: Text('Hiçbiri'),
              alignment: Alignment.center,
              menuMaxHeight: 400,
              value: selectedDepartment,
              items: ['1', '2', '3'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  alignment: Alignment.center,
                  value: value,
                  child: Text(
                    value,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedDepartment = newValue;
                });
              },
            ),
          ),
          ListTile(
            onTap: null,
            title: Text('Pozisyon'),
            subtitle: DropdownButton(
              isExpanded: false,
              icon: Container(),
              hint: Text('Hiçbiri'),
              alignment: Alignment.center,
              menuMaxHeight: 400,
              value: selectedPosition,
              items: ['1', '2', '3'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  alignment: Alignment.center,
                  value: value,
                  child: Text(
                    value,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedPosition = newValue;
                });
              },
            ),
          ),
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

            var filter = EmployeeFilter(
              minAge: _ageRangeValues.start,
              maxAge: _ageRangeValues.end,
              gender: (filterMale == filterFemale)
                  ? null
                  : filterMale
                      ? Gender.male
                      : Gender.female,
              // departmentIds: [],
              // positionIds: [],
            );

            Navigator.pop(context, filter);
          },
        ),
      ],
    );
  }
}
