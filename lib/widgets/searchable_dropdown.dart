import 'package:flutter/material.dart';
import 'package:Optik/collections/user.dart';

class SearchableDropdown extends StatefulWidget {
  SearchableDropdown({Key key, this.allItems}) : super(key: key);
  final List<String> allItems;

  @override
  _SearchableDropdownState createState() => new _SearchableDropdownState();
}

class _SearchableDropdownState extends State<SearchableDropdown> {
  TextEditingController editingController = TextEditingController();

  var items = List<String>();

  @override
  void initState() {
    items.addAll(widget.allItems);
    super.initState();
  }

  void filterSearchResults(String query) {
    List<String> dummySearchList = List<String>();
    dummySearchList.addAll(widget.allItems);
    if(query.isNotEmpty) {
      List<String> dummyListData = List<String>();
      dummyListData.add('Diğer');
      dummySearchList.forEach((item) {
        if(item.toLowerCase().replaceAll('ü', 'u').replaceAll('ö', 'o').replaceAll('ı', 'i').replaceAll('ş', 's').replaceAll('ğ', 'g')
        .replaceAll('ç', 'c').contains(query.toLowerCase().replaceAll('ü', 'u').replaceAll('ö', 'o').replaceAll('ı', 'i').replaceAll('ş', 's').replaceAll('ğ', 'g')
        .replaceAll('ç', 'c'))) {
          dummyListData.add(item);
        }
        
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(widget.allItems);
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    final Map<String,dynamic> args = ModalRoute.of(context).settings.arguments;
    final User user = args['user'];
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                filterSearchResults(value);
              },
              controller: editingController,
              decoration: InputDecoration(
                  labelText: "Ara",
                  hintText: "Ara",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)))),
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: (){
                    setState(() {
                      user.schoolID = items[index];
                      user.schoolName = items[index];
                      user.displaySchoolName = items[index];
                    });
                    Navigator.of(context).pop(true);
                  },
                  title: Text('${items[index]}'),
                );
              },
            ),
          ),
        ],
      )
    );
  }
}