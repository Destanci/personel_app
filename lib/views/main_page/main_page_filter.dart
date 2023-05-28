import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/block_radio_button.dart';
import '../../core/_utils/utilities.dart';
import '../../core/enums/gender_enum.dart';
import '../../managers/department_manager.dart';
import '../../managers/position_manager.dart';
import '../../models/department.dart';
import '../../models/filter_models/employee_filter.dart';
import '../../models/position.dart';

class MainPageFilter extends StatefulWidget {
  final void Function()? onSubmit;
  final void Function()? onReset;
  const MainPageFilter({Key? key, this.onSubmit, this.onReset, this.filter}) : super(key: key);

  final EmployeeFilter? filter;

  @override
  State<MainPageFilter> createState() => _MainPageFilterState();
}

class _MainPageFilterState extends State<MainPageFilter> {
  RangeValues _ageRangeValues = const RangeValues(0, 100);
  Department? selectedDepartment;
  Position? selectedPosition;

  bool filterMale = false;
  bool filterFemale = false;

  @override
  void initState() {
    super.initState();

    _ageRangeValues = RangeValues(
      widget.filter?.minAge ?? 0,
      widget.filter?.maxAge ?? 100,
    );

    if (widget.filter?.departmentIds != null && widget.filter!.departmentIds!.length > 0) {
      selectedDepartment =
          DepartmentManager().list.firstWhere((element) => element.id == widget.filter?.departmentIds?.first);
    }
    if (widget.filter?.positionIds != null && widget.filter!.positionIds!.length > 0) {
      selectedPosition =
          PositionManager().list.firstWhere((element) => element.id == widget.filter?.positionIds?.first);
    }
    if (widget.filter?.gender != null) {
      filterMale = widget.filter!.gender == Gender.male;
      filterFemale = widget.filter!.gender == Gender.female;
    }
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
            subtitle: Consumer<DepartmentManager>(
              builder: (context, manager, child) {
                return DropdownButton(
                  isExpanded: true,
                  hint: Text('Hiçbiri'),
                  menuMaxHeight: 400,
                  value: selectedDepartment,
                  items: manager.list.map<DropdownMenuItem<Department>>((Department value) {
                    return DropdownMenuItem<Department>(
                      value: value,
                      child: Text(
                        value.name!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (Department? newValue) {
                    setState(() {
                      selectedDepartment = newValue!;
                    });
                  },
                );
              },
            ),
          ),
          ListTile(
            onTap: null,
            title: Text('Pozisyon'),
            subtitle: Consumer<PositionManager>(
              builder: (context, manager, child) {
                return DropdownButton(
                  isExpanded: true,
                  hint: Text('Hiçbiri'),
                  menuMaxHeight: 400,
                  value: selectedPosition,
                  items: manager.list.map<DropdownMenuItem<Position>>((Position value) {
                    return DropdownMenuItem<Position>(
                      value: value,
                      child: Text(
                        value.name!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (Position? newValue) {
                    setState(() {
                      selectedPosition = newValue;
                    });
                  },
                );
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
            Utilities.closeKeyboard(context);
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
              departmentIds: selectedDepartment?.id != null ? [selectedDepartment!.id!] : [],
              positionIds: selectedPosition?.id != null ? [selectedPosition!.id!] : [],
            );

            Utilities.closeKeyboard(context);
            Navigator.pop(context, filter);
          },
        ),
      ],
    );
  }
}
