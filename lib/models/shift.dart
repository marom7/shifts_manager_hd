import 'employee.dart';

enum ShiftType {
  morning,
  evening,
}

class Shift {
  final ShiftType type;
  final DateTime date;
  Employee? technician;
  Employee? networkManager;

  Shift({
    required this.type,
    required this.date,
    this.technician,
    this.networkManager,
  });

  // מחזיר עותק של המשמרת עם עובדים מעודכנים
  Shift copyWith({
    ShiftType? type,
    DateTime? date,
    Employee? technician,
    Employee? networkManager,
    bool clearTechnician = false,
    bool clearNetworkManager = false,
  }) {
    return Shift(
      type: type ?? this.type,
      date: date ?? this.date,
      technician: clearTechnician ? null : technician ?? this.technician,
      networkManager: clearNetworkManager ? null : networkManager ?? this.networkManager,
    );
  }
}
