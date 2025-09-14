import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class QuestionCard extends StatelessWidget{
  final int id;
  final String className;
  final String teacher;
  final double width;
  final double height;
  // final String location;

  const QuestionCard({
    Key? key,
    // required this.location,
    required this.id,
    required this.className,
    required this.teacher,
    required this.height,
    required this.width
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width, // width for horizontal scroll
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
                      // context.go('/classrooms/detail/${location}');
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