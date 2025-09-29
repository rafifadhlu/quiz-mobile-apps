import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_english_learning/models/user_models.dart';
import 'package:mobile_english_learning/utils/hex_color_converter.dart';
import 'package:mobile_english_learning/viewmodels/classroom/classroom_views_models.dart';
import 'package:provider/provider.dart';
import 'package:mobile_english_learning/components/card_view.dart';


import 'package:mobile_english_learning/viewmodels/auth/auth_view_models.dart';

class UserAuthHomeScreen extends StatefulWidget{

  @override
  
  _UserAuthHomeScreen createState() => _UserAuthHomeScreen();
}

class _UserAuthHomeScreen extends State<UserAuthHomeScreen>{

  @override
  void initState() {
    Future.microtask(() =>{
      context.read<ClassroomViewsModels>().getAllclassrooms()});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();
    final classViewModel = context.watch<ClassroomViewsModels>();

    final user = authViewModel.user;
    final classes = classViewModel.classes;
    
    

    return Column(
      children: <Widget> [
        AppBar(
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


        Expanded(
          child: 
         
          Stack(
            children:<Widget> [
                SafeArea(
                  child: SingleChildScrollView(
                    child: 
                    
                      Container(
                        color: Colors.transparent,
                        child: user == null
                          ? Container(
                              padding: EdgeInsets.only(left:20.0 ,right: 20.0,top: 20.0),
                              child: Center(
                                child: Column(
                                  children:<Widget> [
                                    CircularProgressIndicator(color: Theme.of(context).primaryColor,),
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

                                        if (classes == null) 
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
                                              height: 180,
                                              child: 
                                              Container(
                                                alignment: Alignment.center,
                                                constraints: BoxConstraints.tight(Size(350.0, 50.0)),
                                                decoration: BoxDecoration(color: const Color.fromARGB(255, 224, 224, 224), borderRadius: BorderRadius.circular(20)),
                                                      child: Row( 
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                        Expanded(
                                                          flex: 1,
                                                          child:Icon(Icons.warning)),
                                                        Expanded(
                                                          flex: 4,
                                                          child: 
                                                          Text("No data available or you have not joined any classes",softWrap: true,)
                                                          )
                                                        
                                                        ])
                                                      
                                                    )
                                                  )                                                                                  
                                                ],
                                              ),
                                            )
                                        else if (classes.data.isEmpty) 
                                          Container(
                                            margin: const EdgeInsets.only(top: 30.0),
                                            alignment: Alignment.center,
                                            child: Column(
                                              children: const [
                                                Icon(Icons.info_outline, color: Colors.grey, size: 40),
                                                SizedBox(height: 10),
                                                Text(
                                                  "No classes found",
                                                  style: TextStyle(color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                          )
                                        else
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
                                              height: 180,
                                              child: 
                                              Container(
                                                constraints: BoxConstraints.tight(Size(350.0, 50.0)),
                                                decoration: BoxDecoration(color: const Color.fromARGB(255, 224, 224, 224), borderRadius: BorderRadius.circular(20)),
                                                child: 
                                                ListView.builder(
                                                  scrollDirection: Axis.horizontal,
                                                  shrinkWrap: true,
                                                    itemCount: classes.data.length,
                                                    itemBuilder: (context, index) {
                                                      final classItem = classes.data[index];
                                                      return ClassCard(
                                                        id: classItem.id,
                                                        className: classItem.className,
                                                        teacher: classItem.teacher,
                                                        location: classItem.id.toString(),
                                                      );
                                                    },
                                                  ),
                                              )
                                            )
                                            

                                          
                                          ],
                                        ),
                                      ),


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
        )
      ],
    );

    // return Scaffold(

      
    // );
  }
}