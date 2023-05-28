import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:personel_app/managers/api_manager.dart';
import 'package:personel_app/managers/department_manager.dart';
import 'package:personel_app/managers/position_manager.dart';
import 'package:personel_app/views/employee_pages/employee_add_page_select.dart';

import '../../components/circle_image_avatar.dart';
import '../../core/_utils/date_time_extensions.dart';
import '../../core/_utils/utilities.dart';
import '../../core/enums/gender_enum.dart';
import '../../models/employee.dart';

class EmployeeAddPage extends StatefulWidget {
  final Employee? employee;
  const EmployeeAddPage({
    Key? key,
    this.employee,
  }) : super(key: key);

  bool get isUpdate => employee != null;

  @override
  State<EmployeeAddPage> createState() => _EmployeeAddPageState();
}

class _EmployeeAddPageState extends State<EmployeeAddPage> {
  final ApiManager _apiManager = ApiManager();
  final DepartmentManager _departmentManager = DepartmentManager();
  final PositionManager _positionManager = PositionManager();

  Employee _employee = Employee();

  final DateTime firstDate = DateTime.now().subtract(Duration(days: 365 * 100));
  final DateTime lastDate = DateTime.now().add(Duration(days: 365 * 2));

  File? selectedImage = null;

  @override
  initState() {
    super.initState();

    if (widget.isUpdate) _employee = widget.employee!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isUpdate ? 'Personel Güncelleme' : 'Personel Ekleme'),
        actions: [
          if (widget.isUpdate)
            IconButton(
              icon: Icon(Icons.delete_forever_outlined),
              onPressed: () {
                developer.log('Delete');
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Personel Kaldırma'),
                    content: Text('"${_employee.fullName}" verileri kaldırılacak emin misiniz?'),
                    actions: [
                      OutlinedButton(
                        child: Text('Hayır'),
                        onPressed: () {
                          Utilities.closeKeyboard(context);
                          Navigator.pop(context);
                        },
                      ),
                      ElevatedButton(
                        child: Text(' Evet '),
                        onPressed: () {
                          developer.log('DELETE');
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                insetPadding: EdgeInsets.zero,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: CircularProgressIndicator(),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ).then((value) => Navigator.pop(context, value));
                          _apiManager.deleteEmployee(_employee).then((value) => Navigator.pop(context, value));

                          Utilities.closeKeyboard(context);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () async {
              Utilities.closeKeyboard(context);
              showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    insetPadding: EdgeInsets.zero,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: CircularProgressIndicator(),
                        ),
                      ],
                    ),
                  );
                },
              ).then((value) => Navigator.pop(context, value));
              _apiManager
                  .updateEmployee(
                    _employee,
                    add: !widget.isUpdate,
                    imagePath: selectedImage?.path,
                  )
                  .then((value) => Navigator.pop(context, value));
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
              child: Center(
                child: CircleImageAvatar(
                  imagePath: _employee.picturePath ?? '',
                  size: 100,
                  forcePlaceholder: selectedImage != null,
                  placeholder: selectedImage != null
                      ? Image.file(
                          selectedImage!,
                          fit: BoxFit.contain,
                        )
                      : null,
                  foreground: Positioned(
                    bottom: 5,
                    right: 5,
                    child: FloatingActionButton(
                      backgroundColor: Theme.of(context).primaryColor,
                      splashColor: Theme.of(context).primaryColorDark,
                      child: Icon(
                        Icons.edit,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      onPressed: () => _editImage(),
                    ),
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text('Ad'),
              subtitle: Text(_employee.name ?? ''),
              trailing: Icon(Icons.edit, size: 14),
              onTap: () {
                _showTextEditDialog(
                  context,
                  title: 'Ad',
                  hint: _employee.name ?? '',
                  onSubmit: (value) {
                    setState(() {
                      _employee.name = value;
                    });
                  },
                );
              },
            ),
            ListTile(
              title: Text('Soyad'),
              subtitle: Text(_employee.surname ?? ''),
              trailing: Icon(Icons.edit, size: 14),
              onTap: () {
                _showTextEditDialog(
                  context,
                  title: 'Soyad',
                  hint: _employee.surname ?? '',
                  onSubmit: (value) {
                    setState(() {
                      _employee.surname = value;
                    });
                  },
                );
              },
            ),
            ListTile(
              title: Text('Ünvan'),
              subtitle: Text(_employee.title ?? ''),
              trailing: Icon(Icons.edit, size: 14),
              onTap: () {
                _showTextEditDialog(
                  context,
                  title: 'Ünvan',
                  hint: _employee.title ?? '',
                  onSubmit: (value) {
                    setState(() {
                      _employee.title = value;
                    });
                  },
                );
              },
            ),
            ListTile(
              title: Text('Cinsiyet'),
              subtitle: Text(_employee.gender?.toDisplay() ?? ''),
              trailing: Icon(Icons.edit, size: 14),
              onTap: () {
                _showSelectDialog(
                  context,
                  ['Erkek', 'Kadın'],
                  title: 'Ünvan',
                  hint: _employee.gender?.toDisplay() ?? '',
                  onSubmit: (value) {
                    if (value != null) {
                      setState(() {
                        _employee.gender = value == 'Erkek' ? Gender.male : Gender.female;
                      });
                    }
                  },
                );
              },
            ),
            ListTile(
              title: Text('Departman'),
              subtitle: Text(_employee.departmentName ?? ''),
              trailing: Icon(Icons.edit, size: 14),
              onTap: () {
                _showSelectDialog(
                  context,
                  _departmentManager.list.map<String>((e) => e.name!).toList(),
                  title: 'Ünvan',
                  hint: _employee.departmentName ?? '',
                  onSubmit: (value) {
                    if (value != null) {
                      setState(() {
                        _employee.departmentName = value;
                        _employee.departmentId =
                            _departmentManager.list.firstWhere((element) => element.name == value).id;
                      });
                    }
                  },
                );
              },
            ),
            ListTile(
              title: Text('Pozisyon'),
              subtitle: Text(_employee.positionName ?? ''),
              trailing: Icon(Icons.edit, size: 14),
              onTap: () {
                _showSelectDialog(
                  context,
                  _positionManager.list.map<String>((e) => e.name!).toList(),
                  title: 'Ünvan',
                  hint: _employee.positionName ?? '',
                  onSubmit: (value) {
                    if (value != null) {
                      setState(() {
                        _employee.positionName = value;
                        _employee.positionId = _positionManager.list.firstWhere((element) => element.name == value).id;
                      });
                    }
                  },
                );
              },
            ),
            ListTile(
              title: Text('Telefon'),
              subtitle: Text(_employee.phone ?? ''),
              trailing: Icon(Icons.edit, size: 14),
              onTap: () {
                _showTextEditDialog(
                  context,
                  title: 'Telefon',
                  hint: _employee.phone ?? '',
                  onSubmit: (value) {
                    setState(() {
                      _employee.phone = value;
                    });
                  },
                );
              },
            ),
            ListTile(
              title: Text('Email'),
              subtitle: Text(_employee.email ?? ''),
              trailing: Icon(Icons.edit, size: 14),
              onTap: () {
                _showTextEditDialog(
                  context,
                  title: 'Email',
                  hint: _employee.email ?? '',
                  onSubmit: (value) {
                    setState(() {
                      _employee.email = value;
                    });
                  },
                );
              },
            ),
            ListTile(
              title: Text('Doğum Tarihi'),
              subtitle: Text(_employee.birthdayDate?.toDisplayDate() ?? ''),
              trailing: Icon(Icons.edit, size: 14),
              onTap: () async {
                var date = await showDialog(
                  context: context,
                  builder: (context) => DatePickerDialog(
                    restorationId: 'employee_birthday_date',
                    firstDate: firstDate,
                    lastDate: lastDate,
                    initialDate: (_employee.birthdayDate != null && _employee.birthdayDate!.isAfter(firstDate))
                        ? _employee.birthdayDate!
                        : DateTime.now(),
                  ),
                );

                if (date is DateTime) {
                  setState(() {
                    _employee.birthdayDate = date;
                  });
                }
              },
            ),
            ListTile(
              title: Text('İşe Alım Tarihi'),
              subtitle: Text(_employee.hireDate?.toDisplay() ?? ''),
              trailing: Icon(Icons.edit, size: 14),
              onTap: () async {
                var date = await showDatePicker(
                  context: context,
                  firstDate: firstDate,
                  lastDate: lastDate,
                  initialDate: (_employee.hireDate != null && _employee.hireDate!.isAfter(firstDate))
                      ? _employee.hireDate!
                      : DateTime.now(),
                );

                var time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(_employee.hireDate ?? DateTime.now()),
                );

                if (date is DateTime && time is TimeOfDay) {
                  setState(() {
                    var result = DateTime(
                      date.year,
                      date.month,
                      date.day,
                      time.hour,
                      time.minute,
                    );
                    _employee.hireDate = result;
                  });
                }
              },
            ),
            ListTile(
              title: Text('Adres'),
              subtitle: Text(_employee.address ?? ''),
              trailing: Icon(Icons.edit, size: 14),
              onTap: () {
                _showTextEditDialog(
                  context,
                  title: 'Adres',
                  hint: _employee.address ?? '',
                  onSubmit: (value) {
                    setState(() {
                      _employee.address = value;
                    });
                  },
                );
              },
            ),
            ListTile(
              title: Text('Hakkında'),
              subtitle: Text(_employee.about ?? ''),
              trailing: Icon(Icons.edit, size: 14),
              onTap: () {
                _showTextEditDialog(
                  context,
                  title: 'Hakkında',
                  hint: _employee.about ?? '',
                  onSubmit: (value) {
                    setState(() {
                      _employee.about = value;
                    });
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showTextEditDialog(
    BuildContext context, {
    String? title,
    String? hint,
    void Function(String value)? onSubmit,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        var controller = TextEditingController();

        return AlertDialog(
          title: title != null ? Text(title) : null,
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
            ),
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
                onSubmit?.call(controller.text);
                Utilities.closeKeyboard(context);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showSelectDialog(
    BuildContext context,
    List<String> selectList, {
    String? title,
    String? hint,
    void Function(String? value)? onSubmit,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return EmployeeAddPageSelect(
          selectList: selectList,
          title: title,
          hint: hint,
          onSubmit: onSubmit,
        );
      },
    );
  }

  Future _editImage() async {
    try {
      var file = await Utilities.pickImageFromGallery();

      developer.log(file.toString());

      if (file != null) {
        var cropped = await Utilities.cropImage(context, file.path, 500);
        developer.log(cropped.toString());

        if (cropped != null) {
          setState(() {
            selectedImage = File(cropped.path);
          });
        }
      }
    } catch (ex) {
      developer.log('ERROR -> $ex');
    }
  }
}
