class TravelAddresses {
  String city;
  String state;

  TravelAddresses({
    required this.city,
    required this.state,
  });

  factory TravelAddresses.fromJson(Map<String, dynamic> json) {
    return TravelAddresses(
      city: json['cidade'],
      state: json['estado'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cidade': city,
      'estado': state,
    };
  }

  @override
  String toString() {
    return 'TravelAddresses{city: $city, state: $state}';
  }
}
