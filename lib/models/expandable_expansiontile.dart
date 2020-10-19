import 'package:flutter/material.dart';

class ExpandableExpansionTile extends StatefulWidget {
  @override
  _ExpandableExpansionTileState createState() => _ExpandableExpansionTileState();
}

class _ExpandableExpansionTileState extends State<ExpandableExpansionTile> {
  final ScrollController _scrollController = ScrollController();

  void _scrollToSelectedContent(bool isExpanded, double previousOffset, int index, GlobalKey myKey) {
    final keyContext = myKey.currentContext;

    if (keyContext != null) {
      // make sure that your widget is visible
      final box = keyContext.findRenderObject() as RenderBox;
      _scrollController.animateTo(isExpanded ? (box.size.height * index) : previousOffset,
          duration: Duration(milliseconds: 500), curve: Curves.linear);
    }
  }

  List<Widget> _buildExpansionTileChildren() => [
        FlutterLogo(
          size: 50.0,
        ),
        Text(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse vulputate arcu interdum lacus pulvinar aliquam. Donec ut nunc eleifend, volutpat tellus vel, volutpat libero. Vestibulum et eros lorem. Nam ut lacus sagittis, varius risus faucibus, lobortis arcu. Nullam tempor vehicula nibh et ornare. Etiam interdum tellus ut metus faucibus semper. Aliquam quis ullamcorper urna, non semper purus. Mauris luctus quam enim, ut ornare magna vestibulum vel. Donec consectetur, quam a mattis tincidunt, augue nisi bibendum est, quis viverra risus odio ac ligula. Nullam vitae urna malesuada magna imperdiet faucibus non et nunc. Integer magna nisi, dictum a tempus in, bibendum quis nisi. Aliquam imperdiet metus id metus rutrum scelerisque. Morbi at nisi nec risus accumsan tempus. Curabitur non sem sit amet tellus eleifend tincidunt. Pellentesque sed lacus orci.',
          textAlign: TextAlign.justify,
        ),
      ];

  ExpansionTile _buildExpansionTile(int index) {
    final GlobalKey expansionTileKey = GlobalKey();
    double previousOffset;

    return ExpansionTile(
      key: PageStorageKey('gununSorusuScrollable32'),
      onExpansionChanged: (isExpanded) {
        if (isExpanded) previousOffset = _scrollController.offset;
        _scrollToSelectedContent(isExpanded, previousOffset, index, expansionTileKey);
      },
      title: Text('My expansion tile $index'),
      children: _buildExpansionTileChildren(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        controller: _scrollController,
        itemCount: 2,
        itemBuilder: (BuildContext context, int index) => _buildExpansionTile(index)
    );
  }
}