class DangerZone {
  double latitude;
  double longitude;

  DangerZone(this.latitude, this.longitude);

  static DangerZone fromJson(Map<String, dynamic> json) => DangerZone(
        json['lat'],
        json['lon'],
      );

  Map<String, dynamic> toJson() => {
        'lat': latitude,
        'lon': longitude,
      };
}
