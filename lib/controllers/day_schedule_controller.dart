import 'package:get/get.dart';
import '../models/day_schedule.dart';
import '../services/day_schedule_service.dart';

class DayScheduleController extends GetxController {
  final DayScheduleService _service = DayScheduleService();

  var schedules = <String, DaySchedule>{}.obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadSchedules();
  }

  Future<void> loadSchedules() async {
    try {
      isLoading.value = true;
      final data = await _service.loadSchedules();
      schedules.value = data;
    } finally {
      isLoading.value = false;
    }
  }

  DaySchedule? getSchedule(String date) {
    return schedules[date];
  }
}