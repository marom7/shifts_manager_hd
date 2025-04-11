class Employee {
  final String id;
  final String name;
  final EmployeeRole role;

  Employee({
    required this.id,
    required this.name,
    required this.role,
  });
}

enum EmployeeRole {
  technician,
  networkManager,
}
