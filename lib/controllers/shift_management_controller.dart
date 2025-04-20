import 'package:get/get.dart';
import '../models/shift.dart';
import '../models/employee.dart';
import '../services/shift_service.dart';

class ShiftManagementController extends GetxController {
  final ShiftService shiftService;
  final DateTime selectedDate;

  ShiftManagementController({
    required this.shiftService,
    required this.selectedDate,
  });

  late RxMap<ShiftType, Shift> shifts;
  late RxList<Employee> technicians;
  late RxList<Employee> networkManagers;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  void _loadData() {
    shifts = shiftService.getShiftsForDay(selectedDate).obs;
    technicians = shiftService.getTechnicians().obs;
    networkManagers = shiftService.getNetworkManagers().obs;
  }

  void updateTechnician(ShiftType shiftType, Employee? technician) {
    final updatedShift = shifts[shiftType]!.copyWith(
      technician: technician,
      clearTechnician: technician == null,
    );
    shiftService.updateShift(updatedShift);
    shifts[shiftType] = updatedShift;
  }

  void updateNetworkManager(ShiftType shiftType, Employee? networkManager) {
    final updatedShift = shifts[shiftType]!.copyWith(
      networkManager: networkManager,
      clearNetworkManager: networkManager == null,
    );
    shiftService.updateShift(updatedShift);
    shifts[shiftType] = updatedShift;
  }
}