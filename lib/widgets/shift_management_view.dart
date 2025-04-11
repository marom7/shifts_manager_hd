import 'package:flutter/material.dart';
import '../models/shift.dart';
import '../models/employee.dart';
import '../services/shift_service.dart';
import 'shift_card.dart';

class ShiftManagementView extends StatefulWidget {
  final DateTime selectedDate;
  final ShiftService shiftService;

  const ShiftManagementView({
    super.key,
    required this.selectedDate,
    required this.shiftService,
  });

  @override
  State<ShiftManagementView> createState() => _ShiftManagementViewState();
}

class _ShiftManagementViewState extends State<ShiftManagementView> {
  late Map<ShiftType, Shift> _shifts;
  late List<Employee> _technicians;
  late List<Employee> _networkManagers;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didUpdateWidget(ShiftManagementView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate) {
      _loadData();
    }
  }

  void _loadData() {
    // טעינת המשמרות ליום הנבחר
    _shifts = widget.shiftService.getShiftsForDay(widget.selectedDate);
    
    // טעינת רשימות העובדים
    _technicians = widget.shiftService.getTechnicians();
    _networkManagers = widget.shiftService.getNetworkManagers();
  }

  void _updateTechnician(ShiftType shiftType, Employee? technician) {
    final updatedShift = _shifts[shiftType]!.copyWith(
      technician: technician,
      clearTechnician: technician == null,
    );
    
    widget.shiftService.updateShift(updatedShift);
    
    setState(() {
      _shifts[shiftType] = updatedShift;
    });
  }

  void _updateNetworkManager(ShiftType shiftType, Employee? networkManager) {
    final updatedShift = _shifts[shiftType]!.copyWith(
      networkManager: networkManager,
      clearNetworkManager: networkManager == null,
    );
    
    widget.shiftService.updateShift(updatedShift);
    
    setState(() {
      _shifts[shiftType] = updatedShift;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // כרטיס משמרת בוקר
        ShiftCard(
          shift: _shifts[ShiftType.morning]!,
          technicians: _technicians,
          networkManagers: _networkManagers,
          onTechnicianChanged: (technician) => _updateTechnician(ShiftType.morning, technician),
          onNetworkManagerChanged: (manager) => _updateNetworkManager(ShiftType.morning, manager),
        ),
        
        // כרטיס משמרת ערב
        ShiftCard(
          shift: _shifts[ShiftType.evening]!,
          technicians: _technicians,
          networkManagers: _networkManagers,
          onTechnicianChanged: (technician) => _updateTechnician(ShiftType.evening, technician),
          onNetworkManagerChanged: (manager) => _updateNetworkManager(ShiftType.evening, manager),
        ),
      ],
    );
  }
}
