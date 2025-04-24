import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/shift_management_controller.dart';
import '../models/shift.dart';
import '../services/shift_service.dart';
import 'shift_card.dart';

class ShiftManagementView extends StatelessWidget {
  final DateTime selectedDate;
  final ShiftService shiftService;

  const ShiftManagementView({
    super.key,
    required this.selectedDate,
    required this.shiftService,
  });

  @override
  Widget build(BuildContext context) {
    final ShiftManagementController controller = Get.put(
      ShiftManagementController(
        shiftService: shiftService,
        selectedDate: selectedDate,
      ),
    );

    return Obx(() {
      if (controller.shifts.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      return Column(
        children: [
          // כרטיס משמרת בוקר
          ShiftCard(
            shift: controller.shifts[ShiftType.morning]!,
            technicians: controller.technicians,
            networkManagers: controller.networkManagers,
            onTechnicianChanged: (technician) =>
                controller.updateTechnician(ShiftType.morning, technician),
            onNetworkManagerChanged: (manager) =>
                controller.updateNetworkManager(ShiftType.morning, manager),
          ),

          // כרטיס משמרת ערב
          ShiftCard(
            shift: controller.shifts[ShiftType.evening]!,
            technicians: controller.technicians,
            networkManagers: controller.networkManagers,
            onTechnicianChanged: (technician) =>
                controller.updateTechnician(ShiftType.evening, technician),
            onNetworkManagerChanged: (manager) =>
                controller.updateNetworkManager(ShiftType.evening, manager),
          ),
        ],
      );
    });
  }
}
