import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
    // fetch data when widget initializes
    Future.microtask(() =>
        context.read<ClassroomViewsModels>().getAllclassrooms());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final classroomViewModel = context.watch<ClassroomViewsModels>();
    final user = classroomViewModel.classes;


    return Column(
      children: <Widget> [
        AppBar(title: const Text("Classrooms")),
        (classroomViewModel.isLoading) ?
          Container(
            child: Center(child: CircularProgressIndicator(),
          ))
        :
        Expanded(
          child: 
            user == null
                ? Container(child: Text("no data available"))
                :
                Container(
                  child: SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children:<Widget> [
                          ListView.builder(
                            shrinkWrap: true,
                              itemCount: user.data.length,
                              itemBuilder: (context, index) {
                                final classroom = user.data[index];
                                return Container(
                                  margin: EdgeInsets.only(top: 5.0),
                                  child: 
                                    ListTile(
                                      leading: const Icon(Icons.class_),
                                      title: Text(classroom.className),
                                      subtitle: Text("Teacher: ${classroom.teacher}"),
                                      onTap: () {
                                        context.go('/classrooms/detail/${classroom.id}');
                                      },
                          
                                    ),  
                                );
                              },
                            ),

                          if (classroomViewModel.errorMessage != null && classroomViewModel.classes == null  )
                          Container(
                            margin: EdgeInsets.only(top: 16),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                  color: Colors.red[100],
                                  borderRadius: BorderRadius.circular(8),
                                  ),
                            child: Text(
                              classroomViewModel.errorMessage!,
                              style: TextStyle(
                                    color: Colors.red[800],
                                    fontSize: 14,
                                    ),
                              textAlign: TextAlign.center,
                              ),
                          ),
                          

                        ],
                      ),
                    )),
                ) 
          )
      ],
    );

    // return Scaffold(
    //   appBar: ,
    //   body:
          
    // );
  }
}
