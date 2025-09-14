import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mobile_english_learning/viewmodels/classroom/classroom_views_models.dart';
import 'package:mobile_english_learning/viewmodels/classroom/classroom_views_models.dart';

class ClassroomHome extends StatefulWidget {

  @override
  _ClassroomHomeState createState() => _ClassroomHomeState();

}

class _ClassroomHomeState extends State<ClassroomHome> {
  @override
  void initState() {
    super.initState();
    // fetch data when widget initializes
    Future.microtask(() =>
        context.read<ClassroomViewsModels>().getAllclassrooms());
  }

  @override
  Widget build(BuildContext context) {
    final classroomViewModel = context.watch<ClassroomViewsModels>();
    final user = classroomViewModel.classes;

    return Scaffold(
      appBar: AppBar(title: const Text("Classrooms")),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: user.data.length,
              itemBuilder: (context, index) {
                final classroom = user.data[index];
                return ListTile(
                  leading: const Icon(Icons.class_),
                  title: Text(classroom.className),
                  subtitle: Text("Teacher ID: ${classroom.teacher}"),
                );
              },
            ),
    );
  }
}
