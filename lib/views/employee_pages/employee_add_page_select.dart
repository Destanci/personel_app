import 'package:flutter/material.dart';

import '../../core/_utils/utilities.dart';

class EmployeeAddPageSelect extends StatefulWidget {
  final List<String> selectList;
  final String? title;
  final String? hint;
  final void Function(String? value)? onSubmit;

  const EmployeeAddPageSelect({
    Key? key,
    required this.selectList,
    this.title,
    this.hint,
    this.onSubmit,
  }) : super(key: key);

  @override
  State<EmployeeAddPageSelect> createState() => _EmployeeAddPageSelectState();
}

class _EmployeeAddPageSelectState extends State<EmployeeAddPageSelect> {
  String? selectedItem = null;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.title != null ? Text(widget.title!) : null,
      content: DropdownButton(
        isExpanded: true,
        hint: Text(widget.hint ?? ''),
        menuMaxHeight: 400,
        value: selectedItem,
        items: widget.selectList.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedItem = newValue!;
          });
        },
      ),
      actions: [
        OutlinedButton(
          child: Text('İptal'),
          onPressed: () {
            Utilities.closeKeyboard(context);
            Navigator.pop(context);
          },
        ),
        ElevatedButton(
          child: Text('Uygula'),
          onPressed: () {
            widget.onSubmit?.call(selectedItem);

            Utilities.closeKeyboard(context);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
