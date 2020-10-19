import 'package:flutter/material.dart';
import 'package:Optik/models/theme.dart' as o;

class GununSorusu extends StatelessWidget {
  GununSorusu({Key key, this.title, this.child}) : super(key: key);
  final String title;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.white.withAlpha(0));
    return Theme(data: theme, child:Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        border: Border.all(width: 1.0,color: o.Colors.optikBorder),
        /* color: o.Colors.optikContainerBg, */
      ),        
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.only(left:8.0,right: 8.0),
      child:ExpansionTile(
        key: PageStorageKey('gununSorusuScrollable'),
        title: Text(title,style: o.TextStyles.optikSubTitle,),
        children: [child]
      ) 
    ));
  }
}


