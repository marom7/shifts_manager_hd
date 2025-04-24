import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '/services/shift_service.dart';
import '/UI/shift_management_view.dart';
import '/UI/horizontal_calendar.dart';
import '/controllers/calendar_controller.dart';

void main() async {
  // אתחול נתוני השפה העברית לפורמט תאריכים
  await initializeDateFormatting('he_IL', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'חודש נוכחי',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MonthCalendarPage(title: 'לוח שנה חודשי'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MonthCalendarPage extends StatelessWidget {
  const MonthCalendarPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final CalendarController controller = Get.put(CalendarController());
    final ShiftService shiftService = ShiftService();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Align(
          alignment: Alignment.centerRight,
          child: Text(title),
        ),
      ),
      body: SingleChildScrollView(
        // גלילה אופקית של הקפסולות ימים לחודש
        child: Column(
          children: [
            // רכיב לוח השנה עם גלילה אופקית - 15% מגובה המסך
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
              child: Obx(() => HorizontalCalendar(
                    daysInMonth: controller.daysInMonth,
                    selectedDayIndex: controller.selectedDayIndex.value,
                    onDaySelected: controller.selectDay,
                  )),
            ),

            // כותרת היום הנבחר
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Obx(() {
                final selectedDate = controller.daysInMonth[controller.selectedDayIndex.value];
                return Column(
                  children: [
                    Text(
                      'היום הנבחר:',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      DateFormat('dd/MM/yyyy').format(selectedDate),
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      DateFormat('EEEE', 'he_IL').format(selectedDate),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                );
              }),
            ),

            // תצוגת ניהול משמרות
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7, // גובה מותאם לכרטיסים
              child: Obx(() {
                final selectedDate = controller.daysInMonth[controller.selectedDayIndex.value];
                return ShiftManagementView(
                  selectedDate: selectedDate,
                  shiftService: shiftService,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
