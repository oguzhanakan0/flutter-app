import 'package:flutter/material.dart';
import 'package:Optik/scoped_models/home_view_model.dart';
import 'package:Optik/widgets/stats_counter.dart';

class HomeView extends StatelessWidget {
  final HomeViewModel model;
  HomeView(this.model);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: _getBody(model, context));
  }

  Widget _getBody(HomeViewModel model, BuildContext context) {
    return _getStatsUi(model, context);
  }

  Widget _getStatsUi(HomeViewModel model, BuildContext context) {
    
    return Column(children: [
      StatsCounter(
        size: 50,
        count: model.appStats.userCount,
        title:  'Users',
      ),
    ]);
  }
}
