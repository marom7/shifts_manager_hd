import 'package:get/get.dart';

class CalendarController extends GetxController {
  late DateTime currentDate;
  late List<DateTime> daysInMonth;
  var selectedDayIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    currentDate = DateTime.now();
    _initializeDaysInMonth();
    selectedDayIndex.value = currentDate.day - 1;
  }

  void _initializeDaysInMonth() {
    final DateTime lastDayOfMonth = DateTime(currentDate.year, currentDate.month + 1, 0);
    daysInMonth = List.generate(
      lastDayOfMonth.day,
      (index) => DateTime(currentDate.year, currentDate.month, index + 1),
    );
  }

  void selectDay(int index) {
    selectedDayIndex.value = index;
  }
}