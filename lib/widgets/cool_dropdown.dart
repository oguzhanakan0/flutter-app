import 'package:flutter/material.dart';
import 'package:Optik/models/theme.dart' as o;

class CoolDropdown extends StatefulWidget {
  CoolDropdown({Key key,this.items,this.hint}) : super(key: key);
  final List<String> items;
  final String hint;

  @override
  _CoolDropdownState createState() => _CoolDropdownState();
}

class _CoolDropdownState extends State<CoolDropdown> {
  String dropdownValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      isExpanded: true,
      value: dropdownValue,
      icon:Icon(Icons.arrow_downward,color: o.Colors.optikBlack),
      elevation: 16,
      hint: Text(widget.hint,style: o.TextStyles.optikTitle,),
      underline: Text(''),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: widget.items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value,style: o.TextStyles.optikTitle,),
        );
      }).toList(),
  );
  }
}