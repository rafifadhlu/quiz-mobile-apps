import 'package:flutter/material.dart';
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

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Test Profile"),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20.0,right: 20.0),
        child: Column(
          children: <Widget>[
            if (user == null)
              const Center(child: CircularProgressIndicator())
            else ...[
              Text(user.data.user.firstname),
              ElevatedButton(
                onPressed: () => authViewModel.logout(),
                child: Text(
                  "Logout",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ],
        )
      ),
    );
  }
}