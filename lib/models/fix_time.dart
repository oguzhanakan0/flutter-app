DateTime fixTime(DateTime fix, int offset){
  return fix.add(Duration(seconds: offset));
}