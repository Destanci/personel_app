import 'package:flutter/material.dart';

import '../models/employee_model.dart';

class EmployeeCard extends StatefulWidget {
  final Employee employee;

  const EmployeeCard({
    Key? key,
    required this.employee,
  }) : super(key: key);

  @override
  _EmployeeCardState createState() => _EmployeeCardState();
}

class _EmployeeCardState extends State<EmployeeCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: Card(
        child: Column(
          children: [
            Image.asset("assets/placeholder.png"),
            Text(
              '${widget.employee.name} ${widget.employee.surname}',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
