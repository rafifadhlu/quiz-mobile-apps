import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_english_learning/viewmodels/auth/auth_view_models.dart';
import 'package:provider/provider.dart';




class ProfileScreen extends StatefulWidget {

  @override
  _ProfileScreenState createState() => _ProfileScreenState();

}

class _ProfileScreenState extends State<ProfileScreen>{
  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();
    final user = authViewModel.user;

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
    title: const Text("Profile"),
    backgroundColor: Colors.blueAccent,
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
                          const SizedBox(height: 10),
                          
                          // Username
                          Text(
                            user.data.user.firstname + " " + user.data.user.lastname,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),

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
                                    padding: EdgeInsets.only(left: 10.0,right: 10.0),
                                    child: Row(
                                      children: [
                                          Icon(Icons.person,
                                          color: Colors.black,
                                          size: 40.0,),
                                          Text("Profile",
                                          style: TextStyle(
                                            color: Theme.of(context).primaryColor,
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