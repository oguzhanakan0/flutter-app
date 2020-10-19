import 'package:Optik/collections/avatar.dart';
import 'package:flutter/material.dart';
import 'package:Optik/models/theme.dart' as o;

class UnsearchableDropdown extends StatefulWidget {
  UnsearchableDropdown({Key key, this.allItems}) : super(key: key);
  final Map<int,Avatar> allItems;

  @override
  _UnsearchableDropdownState createState() => new _UnsearchableDropdownState();
}

class _UnsearchableDropdownState extends State<UnsearchableDropdown> {
  TextEditingController editingController = TextEditingController();

  

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:ListView.builder(
        shrinkWrap: true,
        itemCount: widget.allItems.keys.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: (){
              Navigator.of(context).pop(index);
            },
            title: Container(
              padding: EdgeInsets.symmetric(vertical:8.0,horizontal:8.0),
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width/3,
                maxWidth: MediaQuery.of(context).size.width/2
              ),
              decoration: BoxDecoration(
                border: Border.all(width:1.0,color:o.Colors.optikContainerBg),
                borderRadius: BorderRadius.circular(16.0)
              ),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children:[
                  Image(image:AssetImage(widget.allItems[index].path),height: 40,),
                  SizedBox(width: 20,),
                  Text(widget.allItems[index].name,style: o.TextStyles.optikTitle),
              ]),
            )
          );
        },
      ),
    );
  }
}