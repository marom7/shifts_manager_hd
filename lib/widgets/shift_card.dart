import 'package:flutter/material.dart';
import '../models/shift.dart';
import '../models/employee.dart';

class ShiftCard extends StatelessWidget {
  final Shift shift;
  final List<Employee> technicians;
  final List<Employee> networkManagers;
  final Function(Employee?) onTechnicianChanged;
  final Function(Employee?) onNetworkManagerChanged;

  const ShiftCard({
    super.key,
    required this.shift,
    required this.technicians,
    required this.networkManagers,
    required this.onTechnicianChanged,
    required this.onNetworkManagerChanged,
  });

  @override
  Widget build(BuildContext context) {
    final String shiftTitle = shift.type == ShiftType.morning ? 'משמרת בוקר' : 'משמרת ערב';
    final Color cardColor = shift.type == ShiftType.morning 
        ? Colors.blue.shade50 
        : Colors.indigo.shade50;
    final Color headerColor = shift.type == ShiftType.morning 
        ? Colors.blue.shade200 
        : Colors.indigo.shade200;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      color: cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // כותרת המשמרת
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: headerColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
            child: Text(
              shiftTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // בחירת טכנאי
                const Text(
                  'טכנאי:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 8),
                _buildEmployeeDropdown(
                  technicians,
                  shift.technician,
                  onTechnicianChanged,
                  'בחר טכנאי',
                ),
                
                const SizedBox(height: 16),
                
                // בחירת מנהל רשת
                const Text(
                  'מנהל רשת:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 8),
                _buildEmployeeDropdown(
                  networkManagers,
                  shift.networkManager,
                  onNetworkManagerChanged,
                  'בחר מנהל רשת',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeDropdown(
    List<Employee> employees,
    Employee? selectedEmployee,
    Function(Employee?) onChanged,
    String hint,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: selectedEmployee?.id,
          hint: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(hint, textAlign: TextAlign.right),
          ),
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(color: Colors.grey.shade800, fontSize: 16),
          onChanged: (String? newValue) {
            if (newValue == null) {
              onChanged(null);
            } else {
              final employee = employees.firstWhere((e) => e.id == newValue);
              onChanged(employee);
            }
          },
          items: [
            // אפשרות לא לבחור עובד
            const DropdownMenuItem<String>(
              value: null,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('לא נבחר', textAlign: TextAlign.right),
              ),
            ),
            // רשימת העובדים
            ...employees.map<DropdownMenuItem<String>>((Employee employee) {
              return DropdownMenuItem<String>(
                value: employee.id,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(employee.name, textAlign: TextAlign.right),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
