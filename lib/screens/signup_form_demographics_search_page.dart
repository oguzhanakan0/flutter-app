import 'package:flutter/material.dart';
import 'package:Optik/widgets/searchable_dropdown.dart';
import 'package:Optik/models/theme.dart' as o;

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;


Future<List<dynamic>> parseJsonFromAssets(String assetsPath) async {
  print('--- Parse json from: $assetsPath');
  return rootBundle.loadString(assetsPath)
      .then((jsonStr) => jsonDecode(jsonStr));
}

class SignupFormDemographicsSearchPage extends StatefulWidget {
  SignupFormDemographicsSearchPage({Key key}) : super(key: key);
  @override
  _SignupFormDemographicsSearchPageState createState() => _SignupFormDemographicsSearchPageState();
}

class _SignupFormDemographicsSearchPageState extends State<SignupFormDemographicsSearchPage> {
  /* bool _isOtherSchoolVisible; */
  
  @override
  Widget build(BuildContext context) {
    Map<String,dynamic> args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        backgroundColor : o.Colors.optikBlue,
        elevation : 1.0,
        title : Text("Lisenizi Seçin", style:o.TextStyles.optikWhiteTitle)
      ),
      body:SearchableDropdown(
        allItems: args['allItems'],
      )
    );
  }
}