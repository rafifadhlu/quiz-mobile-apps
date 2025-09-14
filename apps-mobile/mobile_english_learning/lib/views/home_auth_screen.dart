import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_english_learning/models/user_models.dart';
import 'package:mobile_english_learning/utils/hex_color_converter.dart';
import 'package:provider/provider.dart';
import 'package:mobile_english_learning/components/card_view.dart';


import 'package:mobile_english_learning/viewmodels/auth/auth_view_models.dart';

class UserAuthHomeScreen extends StatefulWidget{

  @override
  
  _UserAuthHomeScreen createState() => _UserAuthHomeScreen();
}

class _UserAuthHomeScreen extends State<UserAuthHomeScreen>{

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();
    final user = authViewModel.user;


    final classes = [
    {"id": 2, "class_name": "English 10.2", "teacher": 3},
    {"id": 3, "class_name": "Story Buta", "teacher": 3},
    {"id": 4, "class_name": "Story Buta", "teacher": 3},
    {"id": 5, "class_name": "Story Buta", "teacher": 3},
    {"id": 6, "class_name": "Story Buta", "teacher": 3},
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 60.0,
        title: Row(
          children:<Widget> [
             Expanded(
              flex:1,
                child: Column(
                  children: [
                    Image(
                      image: AssetImage('assets/icons/brain.png'),
                      // fit: BoxFit.cover,
                      width: 40.0,
                      height: 40.0),
                    Text("Brain Boost"
                      ,style: TextStyle(
                        fontSize: 8.0,
                        fontFamily: Theme.of(context).textTheme.bodySmall?.fontFamily,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor
                      ),),

                  ],
                )
              ),

              Expanded(
                flex:4,
                child: Text(
                  "HOME",
                  style: TextStyle(
                    fontFamily: Theme.of(context).textTheme.bodyMedium?.fontFamily,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).primaryColor
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                flex:1,
                child: Text(
                  ""
                ),
              )
          ],
        ),
      ),

      body: Stack(
        children:<Widget> [

          Container(
            foregroundDecoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white.withValues(alpha: 0.5), const Color.fromARGB(255, 0, 85, 212).withValues(alpha: 0.8)],
                ),
              ),
            child: Center(
              child: 
                   Image(
                    image: AssetImage("assets/icons/logo-fix.png"),
                    width: 220.0,
                    height: 220.0,
                    fit: BoxFit.fitHeight,
                    )

              ) 
            ),

            SafeArea(
              child: SingleChildScrollView(
                child: 
                
                  Container(
                    child: user == null
                      ? Container(
                          padding: EdgeInsets.only(left:20.0 ,right: 20.0,top: 20.0),
                          child: Center(
                            child: Column(
                              children:<Widget> [
                                CircularProgressIndicator(),
                                Text("Loading User Data")
                              ],
                            ),
                          )
                        )
                      : Container(
                        padding: EdgeInsets.only(left:20.0 ,right: 20.0,top: 20.0),
                        child: Column(
                          children:<Widget> [

                            Container(
                              child: Column(
                                children: <Widget> [

                                  Container(
                                      child: Row(
                                        children: <Widget> [
                                          Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(15), // optional rounded corners
                                                ),
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.account_circle_outlined,),
                                                    SizedBox(width: 8),
                                                    Text(
                                                        "Hai, ${user.data.user.username}",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w500,
                                                          color: Theme.of(context).primaryColor
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              )

                                            ],
                                          ),
                                        Spacer()
                                        ],
                                      )                   
                                    ),
                                  
                                  Container(
                                    margin: const EdgeInsets.only(top: 30.0),
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget> [
                                        Text("Your",
                                          style: TextStyle(
                                            color: Theme.of(context).primaryColor,
                                            fontFamily: "Frankrut",
                                            fontWeight: FontWeight.w400,
                                            fontSize: 30.0),),
                                        Text("Classes",
                                          style: TextStyle(
                                            color: HexColor.fromHex("#38aef2"),
                                            fontFamily: "Frankrut",
                                            fontWeight: FontWeight.w400,
                                            fontSize: 30.0),),

                                        SizedBox(
                                          height: 160,
                                          child: 
                                          ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            shrinkWrap: true,
                                              itemCount: classes.length,
                                              itemBuilder: (context, index) {
                                                final classItem = classes[index];
                                                return ClassCard(
                                                  id: classItem["id"] as int,
                                                  className: classItem["class_name"] as String,
                                                  teacher: classItem["teacher"] as int,
                                                );
                                              },
                                            ),
                                        )
                                        

                                      
                                      ],
                                    ),
                                  ),

                                  // Container(
                                  //   child: ,
                                  // )

                                  
                                  // ElevatedButton(onPressed: () => {authViewModel.logout()}, 
                                  // child: Text("Logout",
                                  // style: TextStyle(
                                  //   color: Colors.red
                                  // ),)),

                                ],
                              )
                            
                            ),

                          ],
                        ),
                      ),
                  ),
              )),

        ],
      ) 
      
    );
  }
}