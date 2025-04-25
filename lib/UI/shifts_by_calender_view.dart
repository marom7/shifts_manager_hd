import 'package:flutter/material.dart';
import 'package:get/get.dart';

//void main() {
//  runApp(GetMaterialApp(home: ShiftScreen()));
//}

class ShiftScreen extends StatelessWidget {
  final List<String> days = ["10", "11", "12", "13", "14", "15", "16"];
  final List<String> employees = ["דניאל", "נועה", "יוסף", "טל"];

  final RxString selectedMorning1 = "".obs;
  final RxString selectedMorning2 = "".obs;
  final RxString selectedEvening1 = "".obs;
  final RxString selectedEvening2 = "".obs;

  ShiftScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF103E6E),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // קפסולות ימים
              SizedBox(
                height: 60,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: days.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: index == 2
                            ? Colors.lightBlueAccent
                            : Colors.grey.shade700,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        days[index],
                        style: const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // משמרת בוקר
              buildShiftCard(
                title: "משמרת בוקר",
                color: const Color(0xFF3BA5B4),
                dropdown1: selectedMorning1,
                dropdown2: selectedMorning2,
                employees: employees,
              ),

              const SizedBox(height: 16),

              // משמרת ערב
              buildShiftCard(
                title: "משמרת ערב",
                color: const Color(0xFF3BA58A),
                dropdown1: selectedEvening1,
                dropdown2: selectedEvening2,
                employees: employees,
              ),

              const Spacer(),

              // כפתור עדכן
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  onPressed: () {
                    Get.snackbar("עודכן", "המשמרות נשמרו בהצלחה");
                  },
                  child: const Text("עדכן", style: TextStyle(fontSize: 20)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildShiftCard({
    required String title,
    required Color color,
    required RxString dropdown1,
    required RxString dropdown2,
    required List<String> employees,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 16),
          Obx(() => buildDropdown(dropdown1, employees)),
          const SizedBox(height: 12),
          Obx(() => buildDropdown(dropdown2, employees)),
        ],
      ),
    );
  }

  Widget buildDropdown(RxString selected, List<String> items) {
    return DropdownButtonFormField<String>(
      value: selected.value.isEmpty ? null : selected.value,
      dropdownColor: Colors.white,
      decoration: const InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
      ),
      items: items
          .map((name) => DropdownMenuItem(value: name, child: Text(name)))
          .toList(),
      onChanged: (val) => selected.value = val ?? "",
    );
  }
}
