class GeolocationModel {
  int? id;
  int travelId;
  double latitude;
  double longitude;
  DateTime collectionDate;
  String statusSend;

  GeolocationModel({
    this.id,
    required this.travelId,
    required this.latitude,
    required this.longitude,
    required this.collectionDate,
    required this.statusSend,
  });

  factory GeolocationModel.fromJson(Map<String, dynamic> json) => GeolocationModel(
        id: json["id"],
        travelId: json["travelId"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        collectionDate: DateTime.parse(json["collectionDate"]),
        statusSend: json["statusSend"] == null ? StatusSend.pending.name.toLowerCase() : json["statusSend"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "travelId": travelId,
        "latitude": latitude,
        "longitude": longitude,
        "collectionDate": collectionDate.toIso8601String(),
        "statusSend": statusSend.isEmpty ? StatusSend.pending.name.toLowerCase() : statusSend,
      };

  @override
  String toString() {
    return 'GeolocationModel(id: $id, travelId: $travelId, latitude: $latitude, longitude: $longitude, collectionDate: $collectionDate, statusSend: $statusSend)';
  }
}

enum StatusSend {
  pending,
  sended,
}
