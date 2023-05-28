import 'package:flutter/material.dart';
import 'package:personel_app/views/employee_pages/employee_details_page.dart';

import '../core/_utils/utilities.dart';
import '../models/employee.dart';
import 'circle_image_avatar.dart';

class EmployeeTile extends StatefulWidget {
  final Employee employee;
  final void Function()? listRefresher;

  const EmployeeTile({
    Key? key,
    required this.employee,
    this.listRefresher,
  }) : super(key: key);

  @override
  _EmployeeTileState createState() => _EmployeeTileState();
}

class _EmployeeTileState extends State<EmployeeTile> {
  static const double imageSize = 50.0;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Utilities.closeKeyboard(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EmployeeDetailsPage(employee: widget.employee),
          ),
        ).then((value) {
          if (value is bool) {
            if (value) widget.listRefresher?.call();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(value ? 'Personel başarıyla güncellendi' : 'Personel güncelleme başarısız'),
              ),
            );
          }
        });
      },
      leading: SizedBox(
        height: 50,
        width: 50,
        child: CircleImageAvatar(
          imagePath: widget.employee.picturePath ?? '',
          size: 25,
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 1.0),
        child: Text(
          '${widget.employee.name ?? ''} ${widget.employee.surname ?? ''}',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: imageSize / 2.5,
          ),
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.fade,
        ),
      ),
      subtitle: Text(
        widget.employee.title ?? '',
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: imageSize / 3.5,
        ),
        maxLines: 1,
        softWrap: false,
        overflow: TextOverflow.fade,
      ),
    );
  }
}
