class DaySchedule {
  final String? day;
  final String? worker;
  final String? holiday;

  DaySchedule({this.day, this.worker, this.holiday});

  factory DaySchedule.fromJson(Map<String, dynamic> json) {
    return DaySchedule(
      day: json['day'] as String?,
      worker: json['worker'] as String?,
      holiday: json['holiday'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'worker': worker,
      'holiday': holiday,
    };
  }
}