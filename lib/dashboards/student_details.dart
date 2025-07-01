import 'package:flutter/material.dart';

class StudentApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StudentListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Student {
  String name;
  String id;
  String busNumber;
  String city;
  String gender;

  Student({
    required this.name,
    required this.id,
    required this.busNumber,
    required this.city,
    required this.gender,
  });
}

class StudentListScreen extends StatefulWidget {
  @override
  _StudentListScreenState createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  static const Color primaryColor = Color(0xFFFECF4C);
  static const Color textColor = Colors.black;
  static const Color backgroundColor = Colors.white;

  List<Student> students = [
    Student(
      name: "Aarav Sharma",
      id: "S101",
      busNumber: "B12",
      city: "Delhi",
      gender: "male",
    ),
    Student(
      name: "Meera Patel",
      id: "S102",
      busNumber: "B15",
      city: "Mumbai",
      gender: "female",
    ),
  ];

  int? expandedIndex;

  void _handleDropdown(String value, Student student, int index) {
    switch (value) {
      case "View":
        _showViewDialog(student);
        break;
      case "Edit":
        _showEditDialog(student, index);
        break;
      case "Delete":
        _confirmDelete(index);
        break;
    }
  }

  void _showViewDialog(Student student) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Student Details"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: ${student.name}"),
            Text("ID: ${student.id}"),
            Text("Bus Number: ${student.busNumber}"),
            Text("City: ${student.city}"),
            Text("Gender: ${student.gender}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close", style: TextStyle(color: primaryColor)),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(Student student, int index) {
    TextEditingController nameController = TextEditingController(
      text: student.name,
    );
    TextEditingController idController = TextEditingController(
      text: student.id,
    );
    TextEditingController busController = TextEditingController(
      text: student.busNumber,
    );
    TextEditingController cityController = TextEditingController(
      text: student.city,
    );
    String gender = student.gender;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit Student"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: idController,
                decoration: InputDecoration(labelText: "ID"),
              ),
              TextField(
                controller: busController,
                decoration: InputDecoration(labelText: "Bus Number"),
              ),
              TextField(
                controller: cityController,
                decoration: InputDecoration(labelText: "City"),
              ),
              DropdownButtonFormField<String>(
                value: gender,
                items: ["male", "female"]
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) gender = val;
                },
                decoration: InputDecoration(labelText: "Gender"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: primaryColor)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                students[index] = Student(
                  name: nameController.text,
                  id: idController.text,
                  busNumber: busController.text,
                  city: cityController.text,
                  gender: gender,
                );
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: textColor,
            ),
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Student"),
        content: Text("Are you sure you want to delete this student?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: primaryColor)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                students.removeAt(index);
                expandedIndex = null;
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text("Student Details", style: TextStyle(color: textColor)),
        backgroundColor: primaryColor,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          bool isExpanded = expandedIndex == index;
          Student student = students[index];

          return GestureDetector(
            onTap: () {
              setState(() {
                expandedIndex = isExpanded ? null : index;
              });
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: primaryColor, width: 1.5),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  if (isExpanded)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: primaryColor.withOpacity(0.3),
                      child: Text(
                        student.gender.toLowerCase() == "female" ? "👧" : "👦",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    title: Text(
                      student.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: textColor,
                      ),
                    ),
                    subtitle: Text(
                      "ID: ${student.id}",
                      style: TextStyle(color: textColor.withOpacity(0.7)),
                    ),
                    trailing: DropdownButton<String>(
                      underline: SizedBox(),
                      icon: Icon(Icons.more_vert, color: textColor),
                      onChanged: (value) {
                        if (value != null)
                          _handleDropdown(value, student, index);
                      },
                      items: ["View", "Edit", "Delete"]
                          .map(
                            (option) => DropdownMenuItem(
                              value: option,
                              child: Text(option),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  if (isExpanded) ...[
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 60.0),
                      child: Text(
                        "Bus Number: ${student.busNumber}",
                        style: TextStyle(fontSize: 15, color: textColor),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 60.0, top: 4),
                      child: Text(
                        "City: ${student.city}",
                        style: TextStyle(fontSize: 15, color: textColor),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
