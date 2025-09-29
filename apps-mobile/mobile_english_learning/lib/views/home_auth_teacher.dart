import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile_english_learning/utils/shared_prefs.dart';
import 'package:mobile_english_learning/viewmodels/auth/auth_view_models.dart';
import 'package:mobile_english_learning/viewmodels/classroom/classroom_views_models.dart';
import 'package:provider/provider.dart';

import 'package:go_router/go_router.dart';
import 'package:mobile_english_learning/utils/hex_color_converter.dart';
import 'package:mobile_english_learning/viewmodels/auth/app_state_view_models.dart';



class HomeTeacherScreen extends StatefulWidget{
  const HomeTeacherScreen({super.key});

  @override
  State<HomeTeacherScreen> createState() => _homeTeacherScreenState();
  
}

class _homeTeacherScreenState extends State<HomeTeacherScreen>{
  final Color fontcolor = HexColor.fromHex("#102f74");


  @override
  void initState() {
    Future.microtask(() =>{
      context.read<AuthViewModel>().user});
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();
    final user = authViewModel.user;

    return Scaffold(
        body: Container(
          margin: EdgeInsets.only(top: 50.0, left: 20.0,right: 20.0),
          child: 
          Column(
            children: <Widget> [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children:<Widget> [
                    Image(width: 20.0,height: 20.0,image: AssetImage("assets/icons/brain.png"),color: Theme.of(context).primaryColor),
                    SizedBox(width: 10.0),
                    Text("Brain Boost", style: TextStyle(fontFamily: 'Poppins',fontSize: 15.0,fontWeight: FontWeight.w500,color: Theme.of(context).primaryColor),),
                  ],),
                    SingleChildScrollView(
                      child:
                      Column(
                        children: [
                           SizedBox(height: 20.0),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15), // optional rounded corners
                                          ),
                                child: Row(
                                          children: [
                                            (authViewModel.user == null)
                                            ? Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor,))
                                               
                                            :
                                                Icon(Icons.account_circle_outlined,color: Theme.of(context).primaryColor),
                                                SizedBox(width: 8),
                                                Text(
                                                    "Hi, ${authViewModel.displayName}",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w500,
                                                        color: Theme.of(context).primaryColor
                                                        ),
                                                ),
                                            ],
                                  ),
                              ),
                              SizedBox(height: 20.0),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: InkWell( // Wrap the container with InkWell
                                      onTap: () {
                                        debugPrint("Push to");
                                        context.push('/teacher/classrooms');
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color.fromARGB(255, 138, 138, 138).withValues(alpha: 10.0), // The withValues method does not exist. This will cause an error
                                              spreadRadius: 1,
                                              blurRadius: 4,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                        ),
                                        width: 140.0,
                                        height: 140.0,
                                        child: Center(
                                          child: Row(
                                            children: [
                                              Icon(Icons.edit, size: 40.0),
                                              SizedBox(width: 10.0),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text("Manage", style: TextStyle(fontSize: 14.0)),
                                                  Text("classes", style: TextStyle(fontSize: 14.0)),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                    Expanded(
                                      flex: 1,
                                      child: SizedBox(height: 20.0))
                                
                                ],
                              )
                          ],
                      )
                    )
                   
                ],
              )
            ],
          ),
        )
      );
      
  } 

}

