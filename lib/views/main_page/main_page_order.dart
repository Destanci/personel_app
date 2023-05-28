import 'package:flutter/material.dart';

import '../../core/_utils/utilities.dart';
import '../../core/models/paged_request_model.dart';

class MainPageOrder extends StatefulWidget {
  final void Function()? onSubmit;
  final void Function()? onReset;
  const MainPageOrder({Key? key, this.onSubmit, this.onReset, this.orderList}) : super(key: key);

  final List<RequestOrder>? orderList;

  @override
  State<MainPageOrder> createState() => _MainPageOrderState();
}

class _MainPageOrderState extends State<MainPageOrder> {
  final Map<String, String> dropdownList = {
    "Name": "Ad",
    "Surname": "Soyad",
    "Age": "Yaş",
    "Gender": "Cinsiyet",
  };

  Map<String, bool> selectedParameters = {};

  @override
  void initState() {
    super.initState();

    if (widget.orderList != null && widget.orderList!.isNotEmpty)
      for (var order in widget.orderList!) {
        selectedParameters.addAll({dropdownList[order.column]!: order.dir == "desc"});
      }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.only(top: 24, left: 16, bottom: 16),
      contentPadding: EdgeInsets.symmetric(horizontal: 4),
      title: Text("Sıralama"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (String key in selectedParameters.keys)
            ListTile(
              onTap: null,
              title: DropdownButton<String?>(
                isExpanded: true,
                menuMaxHeight: 400,
                icon: Row(
                  children: [
                    SizedBox(
                      width: 40,
                      child: IconButton(
                        splashRadius: 20,
                        onPressed: () {
                          setState(() {
                            selectedParameters[key] = !selectedParameters[key]!;
                          });
                        },
                        icon: Transform.flip(
                          flipY: selectedParameters[key]!,
                          child: Icon(Icons.filter_list),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 40,
                      child: IconButton(
                        splashRadius: 20,
                        onPressed: () {
                          setState(() {
                            selectedParameters.remove(key);
                          });
                        },
                        icon: Icon(Icons.clear),
                      ),
                    ),
                  ],
                ),
                value: key,
                items: dropdownList.values
                    .where((element) => element == key || !selectedParameters.keys.contains(element))
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedParameters.remove(key);
                    if (value != null) selectedParameters[value] = false;
                  });
                },
              ),
            ),
          ListTile(
            onTap: null,
            title: DropdownButton<String?>(
              isExpanded: true,
              hint: Text('Parametre Seç'),
              menuMaxHeight: 400,
              value: null,
              items: dropdownList.values
                  .where((element) => !selectedParameters.keys.contains(element))
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  if (value != null) selectedParameters[value] = false;
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

            Utilities.closeKeyboard(context);
            Navigator.pop(context, null);
          },
        ),
        ElevatedButton(
          child: Text('Uygula'),
          onPressed: () {
            widget.onSubmit?.call();

            List<RequestOrder> orders = [];
            for (var param in selectedParameters.keys) {
              orders.add(RequestOrder(
                column: dropdownList.entries.firstWhere((element) => element.value == param).key,
                dir: selectedParameters[param]! ? "desc" : "asc",
              ));
            }

            Utilities.closeKeyboard(context);
            Navigator.pop(context, orders);
          },
        ),
      ],
    );
  }
}
