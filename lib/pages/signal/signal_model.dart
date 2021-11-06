class SignalModel {
  num? thd;
  num? v0;
  num? v1;
  num? v2;
  num? v3;
  num? v4;

  SignalModel({this.thd, this.v0, this.v1, this.v2, this.v3, this.v4});

  SignalModel.fromJson(Map<String, dynamic> json) {
    thd = json['THD'];
    v0 = json['DB0'];
    v1 = json['DB1'];
    v2 = json['DB2'];
    v3 = json['DB3'];
    v4 = json['DB4'];
  }

  @override
  int get hashCode => super.hashCode;

  @override
  bool operator ==(dynamic other) {
    if (other is! SignalModel) return false;
    SignalModel temp = other;
    return (temp.thd == thd && temp.v0 == v0 && temp.v1 == v1 && temp.v2 == v2 && temp.v3 == v3 && temp.v4 == v4);
  }
}

class SignalChartModel {
  int? x;
  int? y;
  SignalChartModel({this.x, this.y});

  SignalChartModel.fromJson(Map<String, dynamic> json) {
    print(json);
    x = json['x'];
    y = json['y'];
  }
}
