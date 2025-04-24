import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/day_schedule_controller.dart';

class DayScheduleView extends StatelessWidget {
  final String date;

  const DayScheduleView({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final DayScheduleController controller = Get.put(DayScheduleController());

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final schedule = controller.getSchedule(date);
      if (schedule == null) {
        return const Center(child: Text('לא נמצאו נתונים לתאריך זה'));
      }

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('יום: ${schedule.day ?? "לא ידוע"}', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text('עובד: ${schedule.worker ?? "אין"}', style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 8),
          Text('חג: ${schedule.holiday ?? "אין"}', style: Theme.of(context).textTheme.bodyLarge),
        ],
      );
    });
  }
}