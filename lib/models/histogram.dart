import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:Optik/models/theme.dart' as o;



class Histogram extends StatelessWidget {
  final ShowData _showData;
  final String _sinavTipi;
  Histogram(this._showData,this._sinavTipi,{Key key}) : super(key: key);  
  @override
  Widget build(BuildContext context) {
    return Container(
      height:200.0,
      child:charts.BarChart(
        getHistogramData(_showData,_sinavTipi),
        defaultInteractions: false,
        barRendererDecorator: charts.BarLabelDecorator<String>(
          insideLabelStyleSpec: charts.TextStyleSpec(
            fontSize: 11,fontFamily: 'Gothic',color: charts.Color.white),
          outsideLabelStyleSpec: charts.TextStyleSpec(
            fontSize: 11,fontFamily: 'Gothic')
        ),
        domainAxis: charts.OrdinalAxisSpec(
          showAxisLine: false
        ),
        primaryMeasureAxis: charts.NumericAxisSpec(
          showAxisLine: false,
          renderSpec: charts.NoneRenderSpec()
        ),
        layoutConfig: charts.LayoutConfig(
        leftMarginSpec: charts.MarginSpec.fixedPixel(4),
        topMarginSpec: charts.MarginSpec.fixedPixel(8),
        rightMarginSpec: charts.MarginSpec.fixedPixel(4),
        bottomMarginSpec: charts.MarginSpec.fixedPixel(24)
        ),
      )
    );
  }
}

class ShowData {
  String examID;
  String username;
  String examName;
  String userSchoolName;
  String radioValue;
  dynamic examRankings;
  dynamic examRankings2;
  dynamic katilimciSayisi;
  dynamic examHistogramData;
  dynamic userBuckets;
  dynamic schoolRankings;
  dynamic netler;
  String examDate;
  List<String> aytList;
  ShowData({this.examID,
           this.examName,
           this.username,
           this.userSchoolName,
           this.radioValue,
           this.examRankings,
           this.examRankings2,
           this.schoolRankings,
           this.examHistogramData,
           this.userBuckets,
           this.netler,
           this.aytList,
           this.katilimciSayisi,
           this.examDate});
}

class ExamRanking{
  List<String> birinci;
  List<String> ikinci;
  List<String> ucuncu;
  List<String> ninci;
  ExamRanking(this.birinci,this.ikinci,this.ucuncu, [this.ninci]);
}

class OrdinalBuckets {
  final String bucket;
  final int frequency;
  OrdinalBuckets(this.bucket, this.frequency);
}

List<charts.Series<OrdinalBuckets, String>> getHistogramData(ShowData _showData, String _sinavTipi) {
  final data_ = _showData.examHistogramData[_showData.radioValue][_sinavTipi];
  final data = List<OrdinalBuckets>();
  for(var i in  data_){data.add(OrdinalBuckets("≥"+i.bucket,i.frequency));}
  final _userBucket = "≥"+_showData.userBuckets[_showData.radioValue][_sinavTipi];
  final colorlookup = ['T','M','T2','M2'].contains(_sinavTipi) ? 'T' : ['Genel'].contains(_sinavTipi) ? 'Genel' : 'S';
  return [
    charts.Series<OrdinalBuckets, String>(
      id: _showData.radioValue,
      domainFn: (OrdinalBuckets bucket, _) => bucket.bucket,
      measureFn: (OrdinalBuckets bucket, _) => bucket.frequency,
      data: data,
      labelAccessorFn: (OrdinalBuckets bucket, _) => '\%${bucket.frequency.toString()}',
      colorFn: (OrdinalBuckets bucket, _) {
        if(bucket.bucket == _userBucket){
          return charts.ColorUtil.fromDartColor(o.Colors.optikHistogramColors[colorlookup][_userBucket]);
        } else{
          return charts.ColorUtil.fromDartColor(o.Colors.optikGray);
        }
      }
    )
  ];
}