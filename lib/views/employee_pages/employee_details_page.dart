import 'package:flutter/material.dart';
import 'package:personel_app/core/_utils/date_time_extensions.dart';

import '../../components/circle_image_avatar.dart';
import '../../core/_utils/utilities.dart';
import '../../core/enums/gender_enum.dart';
import '../../models/employee.dart';
import 'employee_add_page.dart';

class EmployeeDetailsPage extends StatefulWidget {
  final Employee employee;
  const EmployeeDetailsPage({
    Key? key,
    required this.employee,
  }) : super(key: key);

  @override
  State<EmployeeDetailsPage> createState() => _EmployeeDetailsPageState();
}

class _EmployeeDetailsPageState extends State<EmployeeDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personel Ayrıntıları'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              Utilities.closeKeyboard(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EmployeeAddPage(employee: widget.employee),
                ),
              ).then((value) {
                if (value is bool) {
                  Navigator.pop(context, value);
                }
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleImageAvatar(
                    imagePath: widget.employee.picturePath ?? '',
                    size: 100,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      widget.employee.fullName ?? '',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(widget.employee.title ?? ''),
                  ),
                ],
              ),
            ),
            ListTile(
              onTap: null,
              title: Text('Cinsiyet'),
              subtitle: Text(widget.employee.gender?.toDisplay() ?? ''),
            ),
            ListTile(
              onTap: null,
              title: Text('Departman'),
              subtitle: Text(widget.employee.departmentName ?? ''),
            ),
            ListTile(
              onTap: null,
              title: Text('Pozisyon'),
              subtitle: Text(
                widget.employee.positionName ?? '',
              ),
            ),
            ListTile(
              onTap: null,
              title: Text('Telefon'),
              subtitle: Text(widget.employee.phone ?? ''),
            ),
            ListTile(
              onTap: null,
              title: Text('Email'),
              subtitle: Text(widget.employee.email ?? ''),
            ),
            ListTile(
              onTap: null,
              title: Text('Doğum Tarihi'),
              subtitle: Text(widget.employee.birthdayDate?.toDisplayDate() ?? ''),
            ),
            ListTile(
              onTap: null,
              title: Text('İşe Alım Tarihi'),
              subtitle: Text(widget.employee.hireDate?.toDisplay() ?? ''),
            ),
            ListTile(
              onTap: null,
              title: Text('Adres'),
              subtitle: Text(widget.employee.address ?? ''),
            ),
            ListTile(
              onTap: null,
              title: Text('Hakkında'),
              subtitle: Text(widget.employee.about ?? ''),
            ),
          ],
        ),
      ),
    );
  }
}
