class TollModel {
  int? id;
  int travelId;
  int passingOrder;
  String tollCode;
  String? tollName;
  String? concessionaire;
  String? highway;
  double? value;
  DateTime? passingDateTime;

  TollModel({
    this.id,
    required this.travelId,
    required this.passingOrder,
    required this.tollCode,
    this.tollName,
    this.concessionaire,
    this.highway,
    this.value,
    this.passingDateTime,
  });

  factory TollModel.fromJson(Map<String, dynamic> json) {
    return TollModel(
      id: json['id'],
      travelId: json['travelId'],
      passingOrder: json['ordemPassagem'],
      tollCode: json['codigoPedagio'],
      tollName: json['nomePedagio'],
      concessionaire: json['concessionaria'],
      highway: json['rodovia'],
      value: json['valor'],
      passingDateTime: json['dataHoraPassagem'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ordemPassagem': passingOrder,
      'codigoPedagio': tollCode,
      'nomePedagio': tollName,
      'concessionaria': concessionaire,
      'rodovia': highway,
      'valor': value,
      'dataHoraPassagem': passingDateTime,
    };
  }

  @override
  String toString() {
    return 'TollModel(id: $id, travelId: $travelId, passingOrder: $passingOrder, tollCode: $tollCode, tollName: $tollName, concessionaire: $concessionaire, highway: $highway, value: $value, passingDateTime: $passingDateTime)';
  }
}
