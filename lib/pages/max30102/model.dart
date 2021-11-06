class Max30102Model {
  num? hrAvg;
  num? spo2Avg;

  Max30102Model({this.hrAvg, this.spo2Avg});

  Max30102Model.fromJson(Map<String, dynamic> json) {
    hrAvg = json['hrAvg'];
    spo2Avg = json['spo2Avg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hrAvg'] = this.hrAvg;
    data['spo2Avg'] = this.spo2Avg;
    return data;
  }

  @override
  int get hashCode {
    int result = 17;
    result = 37 * result + hrAvg.hashCode;
    result = 37 * result + spo2Avg.hashCode;
    return result;
  }

  @override
  bool operator ==(dynamic other) {
    if (other is! Max30102Model) return false;
    Max30102Model temp = other;
    return (temp.hrAvg == hrAvg && temp.spo2Avg.toString() == spo2Avg.toString());
  }
}
