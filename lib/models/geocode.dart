// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:latlong2/latlong.dart';

class GeocodeData {
  String name;
  LatLng latLng;

  GeocodeData({
    required this.name,
    required this.latLng,
  });

  factory GeocodeData.fromJson(Map<String, dynamic> json) {
    final name = json['name'] ?? 'Unknown';
    final lat = json['lat'] != null ? json['lat'].toDouble() : 0.0;
    final lon = json['lon'] != null ? json['lon'].toDouble() : 0.0;

    return GeocodeData(
      name: name,
      latLng: LatLng(lat, lon),
    );
  }
}
