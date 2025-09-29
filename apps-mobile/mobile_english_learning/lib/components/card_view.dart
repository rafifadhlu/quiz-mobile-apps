import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class ClassCard extends StatelessWidget {
  final int id;
  final String className;
  final String teacher;
  final String location;

  const ClassCard({
    Key? key,
    required this.location,
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
              const SizedBox(height: 8),
              Text(
                className,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text("Teacher: $teacher"),
              const Spacer(),

              Container(
                alignment: Alignment.bottomRight,
                child: 
                  TextButton(
                    onPressed: () {
                      context.go('/classrooms/detail/${location}');
                    },
                    child: const Text("Detail"),
                  ),
              )
              // 👇 Detail Button

            ],
          ),
        ),
      ),
    );
  }
}
