import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_english_learning/viewmodels/auth/auth_view_models.dart';
import 'package:provider/provider.dart';




class ProfileScreenTeacher extends StatefulWidget {

  @override
  _ProfileScreenTeacherState createState() => _ProfileScreenTeacherState();

}

class _ProfileScreenTeacherState extends State<ProfileScreenTeacher>{

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();
    final user = authViewModel.user;
    final profile = authViewModel.profile;

    void _handleProfile(){
      debugPrint('Clicked.........');
      final getUser = context.read<AuthViewModel>().user;
      int? userID;

       if (getUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No user available")),
        );}
        else{
          userID = getUser.data.user.id;
        }
      context.push('/profile/details/${userID}');
    }
    // TODO: implement build
  return Scaffold(
  appBar: AppBar(
    centerTitle: true,
    title: Column(
      children: [
        Text("Kuizu!", style: TextStyle(fontFamily: 'Poppins',fontSize: 15.0,fontWeight: FontWeight.w500,color: Color.fromRGBO(236, 127, 25, 1)),)
      ],
    ),
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  body: SafeArea(
    child: SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          children: <Widget>[
            if (user == null)
              const Center(child: CircularProgressIndicator())
            else ...[
              const SizedBox(height: 40),
              Center(
                child: Column(
                  children: <Widget>[

                          // Welcome Text
                          const Text(
                            "Welcome",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 5),
                          
                          // Username
                          Text(
                            authViewModel.displayName.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 10),

                          SizedBox(
                            width: 300.0,
                            child: ElevatedButton(
                              onPressed: _handleProfile,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Row(
                                children: <Widget> [
                                  Container(
                                    padding: EdgeInsets.only(left: 15.0,right: 10.0),
                                    child: Row(
                                      children: [
                                          Icon(Icons.person,
                                          color: Colors.black,
                                          size: 25.0,),
                                          const SizedBox(width: 10, height: 40,),
                                          Text("Profile",
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w300,
                                            ),),                                  
                                      ],
                                    ),)
                                ],
                              )
                            ),
                          ),

                          
                          const SizedBox(height: 60),
                          SizedBox(
                            width: 300.0,
                            child: ElevatedButton(
                              onPressed: () => authViewModel.logout(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                "Logout",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                  ],
                ) 
                
              )

            ],
          ],
        ),
      ),
    ),
  ),
);
  }
}