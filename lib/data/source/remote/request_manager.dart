import 'dart:convert';

import 'package:covid19/data/models/danger_zone.dart';
import 'package:covid19/data/models/stats.dart';
import 'package:http/http.dart' as http;

class RequestManager {
  final String _endpoint =
      "https://us-central1-cadi360-sac.cloudfunctions.net/function-pakipe-publish/api/v1";

  Future<List<DangerZone>> listDangerZones() async {
    var response = await http.get("$_endpoint/marks",
        headers: {"K-Device": "5a5e1120-e245-45b2-8dda-5cef9e3ebb91"});

    if (response.statusCode == 200) {
      var jsonArray = json.decode(response.body) as List;
      var mapList =
          jsonArray.map((jsonObject) => DangerZone.fromJson(jsonObject));
      return mapList.toList();
    } else {
      throw Exception('Failed to load danger zones');
    }
  }

  Future<Stats> getStatsPerDay(String day) async {
    var response = await http.get("$_endpoint/summary/peru?date=$day",
        headers: {"K-Device": "5a5e1120-e245-45b2-8dda-5cef9e3ebb91"});

    if (response.statusCode == 200) {
      var jsonObject = json.decode(response.body);
      return Stats.fromJson(jsonObject);
    } else {
      throw Exception('Failed to load stats');
    }
  }
}
