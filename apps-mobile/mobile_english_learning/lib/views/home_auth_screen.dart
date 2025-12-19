import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_english_learning/models/user_models.dart';
import 'package:mobile_english_learning/utils/ClipperRightTopRounded.dart';

import 'package:mobile_english_learning/utils/hex_color_converter.dart';
import 'package:mobile_english_learning/viewmodels/classroom/classroom_views_models.dart';
import 'package:provider/provider.dart';
import 'package:mobile_english_learning/components/card_view.dart';

import 'package:mobile_english_learning/viewmodels/auth/auth_view_models.dart';

class UserAuthHomeScreen extends StatefulWidget {
  @override
  _UserAuthHomeScreen createState() => _UserAuthHomeScreen();
}

class _UserAuthHomeScreen extends State<UserAuthHomeScreen> {
  @override
  void initState() {
    Future.microtask(
      () => {context.read<ClassroomViewsModels>().getAllclassrooms()},
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();
    final classViewModel = context.watch<ClassroomViewsModels>();

    final user = authViewModel.user;
    final classes = classViewModel.classes;

    return Column(
      children: [
        Expanded(
          child: Stack(
            children: <Widget>[
              SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                    child: user == null
                        ? Container(
                            padding: EdgeInsets.only(
                              left: 20.0,
                              right: 20.0,
                              top: 20.0,
                            ),
                            child: Center(
                              child: Column(
                                children: <Widget>[
                                  CircularProgressIndicator(
                                    color: Color.fromRGBO(236, 127, 25, 1),
                                  ),
                                  Text("Loading User Data"),
                                ],
                              ),
                            ),
                          )
                        : Container(
                            padding: EdgeInsets.only(
                              left: 20.0,
                              right: 20.0,
                              top: 20.0,
                            ),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        child: Row(
                                          children: <Widget>[
                                            Row(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 6,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(
                                                      context,
                                                    ).primaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          19,
                                                        ), // optional rounded corners
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .account_circle_outlined,
                                                        color: Colors.white,
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text(
                                                        "Hai, ${user.data.user.username}",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Spacer(),
                                          ],
                                        ),
                                      ),

                                      if (classes == null)
                                        Container(
                                          margin: const EdgeInsets.only(
                                            top: 30.0,
                                          ),
                                          alignment: Alignment.centerLeft,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                "Your",
                                                style: TextStyle(
                                                  color: Theme.of(
                                                    context,
                                                  ).primaryColor,
                                                  fontFamily: "Poppins",
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 30.0,
                                                ),
                                              ),
                                              Text(
                                                "Classes",
                                                style: TextStyle(
                                                  color: HexColor.fromHex(
                                                    "#38aef2",
                                                  ),
                                                  fontFamily: "Poppins",
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 30.0,
                                                ),
                                              ),

                                              const SizedBox(height: 20),

                                              SizedBox(
                                                height: 180,
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  constraints:
                                                      BoxConstraints.tight(
                                                        Size(350.0, 100.0),
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(
                                                      context,
                                                    ).primaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: Icon(
                                                          Icons.warning,
                                                          color: Colors.white,
                                                          size: 20,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 4,
                                                        child: Text(
                                                          "No data available or you have not joined any classes",
                                                          softWrap: true,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      else if (classes.data.isEmpty)
                                        Container(
                                          margin: const EdgeInsets.only(
                                            top: 30.0,
                                          ),
                                          alignment: Alignment.center,
                                          child: Column(
                                            children: [
                                              Icon(
                                                Icons.info_outline,
                                                color: Colors.grey,
                                                size: 40,
                                              ),
                                              SizedBox(height: 20),
                                              Text(
                                                "No classes found",
                                                style: TextStyle(
                                                  color: Theme.of(
                                                    context,
                                                  ).primaryColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      else
                                        Container(
                                          margin: const EdgeInsets.only(
                                            top: 30.0,
                                          ),
                                          alignment: Alignment.centerLeft,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[

                                              Container(
                                                width:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.width *
                                                    0.88,
                                                    
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: AssetImage("assets/background/bg-home.png")
                                                    ),
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey,
                                                      blurRadius: 3.0,
                                                    ),
                                                  ],
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [

                                                    ClipPath(
                                                      clipper: RightTopRounded(),
                                                      child: Container(
                                                        width: 
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.width *
                                                    0.60,
                                                    
                                                          decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20))
                                                          ),
                                                        child:
                                                        Container(
                                                          padding: EdgeInsets.fromLTRB(15, 5, 0, 5),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: <Widget> [

                                                               Text(
                                                              "Your",
                                                              style: TextStyle(
                                                                color: Theme.of(
                                                                  context,
                                                                ).primaryColor,
                                                                fontFamily: "Poppins",
                                                                fontWeight:
                                                                    FontWeight.bold,
                                                                fontSize: 30.0,
                                                              ),
                                                            ),
                                                            Text(
                                                              "Classes",
                                                              style: TextStyle(
                                                                color: HexColor.fromHex(
                                                                  "#38aef2",
                                                                ),
                                                                fontFamily: "Poppins",
                                                                fontWeight:
                                                                    FontWeight.bold,
                                                                fontSize: 30.0,
                                                              ),
                                                            ),

                                                            ],
                                                          ),
                                                        )


                                                      )
                                                    )

                                                    
                                                  ],
                                                ),
                                              ),

                                              const SizedBox(height: 20),

                                              SizedBox(
                                                height: 200,
                                                child: Container(
                                                  constraints:
                                                      BoxConstraints.tight(
                                                        Size(350.0, 50.0),
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(
                                                      context,
                                                    ).primaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                  ),
                                                  child: ListView.builder(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        classes.data.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                          final classItem =
                                                              classes
                                                                  .data[index];
                                                          return ClassCard(
                                                            id: classItem.id,
                                                            className: classItem
                                                                .className,
                                                            teacher: classItem
                                                                .teacher,
                                                            location: classItem
                                                                .id
                                                                .toString(),
                                                          );
                                                        },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
