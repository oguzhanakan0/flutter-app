
class PieStat {
  final String id;
  final String questionID;
  final List<ChartData> chartData;

  PieStat({
    this.id,
    this.questionID,
    this.chartData,
    }
  );
}

class ChartData {
  final int value;
  final int index;

  ChartData(this.index,this.value);
}