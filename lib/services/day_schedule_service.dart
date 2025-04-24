import 'dart:convert';
import 'package:flutter/services.dart';
import '/models/day_schedule.dart';

class DayScheduleService {
  Future<Map<String, DaySchedule>> loadSchedules() async {
    final String jsonString = await rootBundle.loadString('lib/services/shift_schedule_2025_separated.json');
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);

    return jsonMap.map((key, value) {
      return MapEntry(key, DaySchedule.fromJson(value));
    });
  }
}