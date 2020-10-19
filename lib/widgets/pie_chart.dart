import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:Optik/collections/pie_stat.dart';
import 'package:Optik/models/theme.dart' as o;
import 'package:Optik/services/convert_functions.dart';
import 'package:Optik/services/fetch_functions.dart';
import 'package:Optik/widgets/loading.dart';

class PieChart extends StatefulWidget {
  final String questionID;
  final int questionNumber;
  final bool animate;
  final double width;
  PieChart({this.animate, this.questionID, this.questionNumber = 999, this.width});  

  @override
  _PieChartState createState() => _PieChartState();
}

class _PieChartState extends State<PieChart> {

  bool loading;
  List<charts.Series<ChartData, int>> chartData;
  List<ChartData> data;
  @override
  void initState() {
    super.initState();
    loading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) => onAfterBuild(context));
  }

  onAfterBuild(BuildContext context) async {
    data = await fetchPieChart(questionID: widget.questionID).then((response)=>convertPieChart(response));
    if(data!=null){
      chartData = [
        new charts.Series<ChartData, int>(
          id: 'Sales',
          domainFn: (ChartData index, _) => index.index,
          measureFn: (ChartData index, _) => index.value,
          colorFn: (ChartData index, _) {
          if(index.index == 1){
              return charts.ColorUtil.fromDartColor(o.Colors.optikGreen);
            } else{
              return charts.ColorUtil.fromDartColor(o.Colors.optikGray);
            }
          },
          data: data,
          // Set a label accessor to control the text of the arc label.
          labelAccessorFn: (ChartData index, _) => '%${index.value}',
        )
      ];
      if(mounted){
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading?Loading(negative:true):Column(
      children: <Widget>[
      Text(widget.questionNumber.toString()+'. Soruya katılımcıların %'+data[0].value.toString()+'\'ü doğru yanıt verdi! Sınav bitiminde doğru şıkları görebilirsin.',
                  style: o.TextStyles.optikBody2,
                  textAlign: TextAlign.center,),
      SizedBox(height: 4.0),
      Container(width:widget.width,height:widget.width,child:
      Center(
        child:charts.PieChart(chartData,
          animate: widget.animate,
          defaultRenderer: new charts.ArcRendererConfig(
            arcWidth: 60,
            arcRendererDecorators: [new charts.ArcLabelDecorator()]))
          )
        )
      ]
    );
  }
}
