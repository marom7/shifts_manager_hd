import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '/services/shift_service.dart';
import '/widgets/shift_management_view.dart';

void main() async {
  // אתחול נתוני השפה העברית לפורמט תאריכים
  await initializeDateFormatting('he_IL', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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

class MonthCalendarPage extends StatefulWidget {
  const MonthCalendarPage({super.key, required this.title});

  final String title;

  @override
  State<MonthCalendarPage> createState() => _MonthCalendarPageState();
}

class _MonthCalendarPageState extends State<MonthCalendarPage> {
  late DateTime _currentDate;
  late List<DateTime> _daysInMonth;
  late int _selectedDayIndex;
  final ShiftService _shiftService = ShiftService();

  @override
  void initState() {
    super.initState();
    _currentDate = DateTime.now();
    _initializeDaysInMonth();
    _selectedDayIndex = _currentDate.day - 1;
  }

  void _initializeDaysInMonth() {
    // יצירת רשימה של כל הימים בחודש הנוכחי
    final DateTime lastDayOfMonth = DateTime(_currentDate.year, _currentDate.month + 1, 0);
    
    _daysInMonth = List.generate(
      lastDayOfMonth.day,
      (index) => DateTime(_currentDate.year, _currentDate.month, index + 1),
    );
  }

  void _selectDay(int index) {
    setState(() {
      _selectedDayIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // חישוב 15% מגובה המסך
    final double screenHeight = MediaQuery.of(context).size.height;
    final double calendarHeight = screenHeight * 0.15;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Align(
          alignment: Alignment.centerRight,
          child: Text(widget.title),
        ),
      ),
      body: Column(
        children: [
          // רכיב לוח השנה עם גלילה אופקית - 15% מגובה המסך
          SizedBox(
            height: calendarHeight,
            child: HorizontalCalendar(
              daysInMonth: _daysInMonth,
              selectedDayIndex: _selectedDayIndex,
              onDaySelected: _selectDay,
            ),
          ),
          
          // כותרת היום הנבחר
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'היום הנבחר:',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  DateFormat('dd/MM/yyyy').format(_daysInMonth[_selectedDayIndex]),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  DateFormat('EEEE', 'he_IL').format(_daysInMonth[_selectedDayIndex]),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
          
          // תצוגת ניהול משמרות
          Expanded(
            child: ShiftManagementView(
              selectedDate: _daysInMonth[_selectedDayIndex],
              shiftService: _shiftService,
            ),
          ),
        ],
      ),
    );
  }
}

class HorizontalCalendar extends StatefulWidget {
  final List<DateTime> daysInMonth;
  final int selectedDayIndex;
  final Function(int) onDaySelected;

  const HorizontalCalendar({
    super.key,
    required this.daysInMonth,
    required this.selectedDayIndex,
    required this.onDaySelected,
  });

  @override
  State<HorizontalCalendar> createState() => _HorizontalCalendarState();
}

class _HorizontalCalendarState extends State<HorizontalCalendar> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    
    // גלילה אל היום הנוכחי בטעינה הראשונית
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.daysInMonth.isNotEmpty && widget.selectedDayIndex < widget.daysInMonth.length) {
        const double itemWidth = 70.0; // רוחב כל פריט בלוח השנה
        final double offset = widget.selectedDayIndex * itemWidth;
        _scrollController.animateTo(
          offset,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      itemCount: widget.daysInMonth.length,
      itemBuilder: (context, index) {
        final DateTime day = widget.daysInMonth[index];
        final bool isSelected = index == widget.selectedDayIndex;
        final bool isToday = day.year == DateTime.now().year &&
                            day.month == DateTime.now().month &&
                            day.day == DateTime.now().day;
        
        return GestureDetector(
          onTap: () => widget.onDaySelected(index),
          child: Container(
            width: 70,
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : isToday
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('E', 'he_IL').format(day),
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  day.day.toString(),
                  style: TextStyle(
                    fontSize: 24,
                    color: isSelected
                        ? Colors.white
                        : Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
