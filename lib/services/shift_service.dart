import '../models/employee.dart';
import '../models/shift.dart';

class ShiftService {
  // מאגר נתונים מדומה של עובדים
  final List<Employee> _employees = [
    Employee(id: '1', name: 'אבי כהן', role: EmployeeRole.technician),
    Employee(id: '2', name: 'יוסי לוי', role: EmployeeRole.technician),
    Employee(id: '3', name: 'דנה ישראלי', role: EmployeeRole.technician),
    Employee(id: '4', name: 'מיכל אברהם', role: EmployeeRole.technician),
    Employee(id: '5', name: 'רונן גולן', role: EmployeeRole.networkManager),
    Employee(id: '6', name: 'שירה דוד', role: EmployeeRole.networkManager),
    Employee(id: '7', name: 'אלון ברק', role: EmployeeRole.networkManager),
  ];

  // מאגר נתונים מדומה של משמרות
  final Map<String, Map<ShiftType, Shift>> _shifts = {};

  // מחזיר את כל העובדים
  List<Employee> getAllEmployees() {
    return List.unmodifiable(_employees);
  }

  // מחזיר את כל הטכנאים
  List<Employee> getTechnicians() {
    return _employees.where((emp) => emp.role == EmployeeRole.technician).toList();
  }

  // מחזיר את כל מנהלי הרשת
  List<Employee> getNetworkManagers() {
    return _employees.where((emp) => emp.role == EmployeeRole.networkManager).toList();
  }

  // מחזיר מפתח ייחודי למשמרת לפי תאריך
  String _getDateKey(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }

  // מחזיר את המשמרות ליום מסוים
  Map<ShiftType, Shift> getShiftsForDay(DateTime date) {
    final dateKey = _getDateKey(date);
    
    if (!_shifts.containsKey(dateKey)) {
      // אם אין משמרות ליום זה, יוצר משמרות ריקות
      _shifts[dateKey] = {
        ShiftType.morning: Shift(type: ShiftType.morning, date: date),
        ShiftType.evening: Shift(type: ShiftType.evening, date: date),
      };
    }
    
    return _shifts[dateKey]!;
  }

  // מעדכן משמרת
  void updateShift(Shift updatedShift) {
    final dateKey = _getDateKey(updatedShift.date);
    
    if (!_shifts.containsKey(dateKey)) {
      _shifts[dateKey] = {
        ShiftType.morning: Shift(type: ShiftType.morning, date: updatedShift.date),
        ShiftType.evening: Shift(type: ShiftType.evening, date: updatedShift.date),
      };
    }
    
    _shifts[dateKey]![updatedShift.type] = updatedShift;
  }
  //--------------------------------------------------------
  // מוצא עובד לפי מזהה
  Employee? findEmployeeById(String id) {
    try {
      return _employees.firstWhere((emp) => emp.id == id);
    } catch (e) {
      return null;
    }
  }
}
