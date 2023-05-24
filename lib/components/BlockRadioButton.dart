import 'package:flutter/material.dart';

class BlockRadioButton extends StatefulWidget {
  final IconData? icon;
  final String text;

  final bool selected;

  final void Function(bool value)? onTap;

  BlockRadioButton({
    Key? key,
    this.icon,
    this.text = '',
    this.selected = false,
    this.onTap,
  }) : super(key: key);

  @override
  _BlockRadioButtonState createState() => _BlockRadioButtonState();
}

class _BlockRadioButtonState extends State<BlockRadioButton> {
  bool isSelected = false;

  @override
  void initState() {
    super.initState();

    isSelected = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.primaryContainer,
      child: InkWell(
        onTap: () {
          setState(() {
            isSelected = !isSelected;
          });
          widget.onTap?.call(isSelected);
        },
        child: Container(
          alignment: Alignment.center,
          margin: new EdgeInsets.all(5.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              FittedBox(
                fit: BoxFit.contain,
                child: Icon(
                  widget.icon,
                  color: isSelected
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              if (widget.text.isNotEmpty) SizedBox(height: 10),
              if (widget.text.isNotEmpty)
                Text(
                  widget.text,
                  style: TextStyle(
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
