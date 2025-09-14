import 'package:flutter/material.dart';


class ClassCard extends StatelessWidget {
  final int id;
  final String className;
  final int teacher;

  const ClassCard({
    Key? key,
    required this.id,
    required this.className,
    required this.teacher,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160, // width for horizontal scroll
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                className,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text("ID: $id"),
              Text("Teacher: $teacher"),
              const Spacer(),

              // 👇 Detail Button
              TextButton(
                onPressed: () {
                  // Change bottom nav index to "Classes"
                  // You can do this via Provider, Riverpod, GetX, or a callback
                  // Example with Provider:
                  // context.read<NavigationProvider>().setIndex(id); // where 1 = Classes tab
                },
                child: const Text("Detail"),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
