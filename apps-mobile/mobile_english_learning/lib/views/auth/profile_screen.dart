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
              
              // Welcome Text
              const Text(
                "Welcome",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 10),
              
              // Username
              Text(
                user.data.user.firstname,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              
              const SizedBox(height: 60),
              
              // Logout Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => authViewModel.logout(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
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
          ],
        ),
      ),
    ),
  ),
);
  }
}