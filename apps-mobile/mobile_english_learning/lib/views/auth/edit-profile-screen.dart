import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import 'package:mobile_english_learning/models/user_models.dart';
import 'package:mobile_english_learning/viewmodels/auth/auth_view_models.dart';
import 'package:provider/provider.dart';


class editProfileScreen extends StatefulWidget {
  final String userID;

  editProfileScreen({
    super.key, required this.userID
  });

  @override
  _editProfileScreenState createState() => _editProfileScreenState();
}

class _editProfileScreenState extends State<editProfileScreen>{
    final _formKey = GlobalKey<FormState>();
    late final _usernameController = TextEditingController();
    late final _emailController = TextEditingController();
    late final _first_nameController = TextEditingController();
    late final _last_nameController = TextEditingController();
    bool _editField = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userAuthViewModel = context.read<AuthViewModel>();
      userAuthViewModel.fetchProfile(int.parse(widget.userID)).then((_) {
        if (mounted && userAuthViewModel.profile != null) {
          setState(() {
            _usernameController.text = userAuthViewModel.profile!.username ?? "";
            _emailController.text = userAuthViewModel.profile!.email ?? "";
            _first_nameController.text = userAuthViewModel.profile!.first_name ?? "";
            _last_nameController.text = userAuthViewModel.profile!.last_name ?? "";
          });
        }
      });
    });
  }


  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _first_nameController.dispose();
    _last_nameController.dispose();
    super.dispose();
  }

  void handleEdit(){
    setState(() {
      _editField = !_editField;
    });
  }


  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();
    final user = authViewModel.user;

    if (authViewModel.isLoading && authViewModel.profile == null) {
      return const Center(child: CircularProgressIndicator());
    }
    // TODO: implement build
  return Scaffold(
    appBar: AppBar(
      title: Row(

        children: [
          Text("Profile"),
          TextButton(onPressed: handleEdit
          , child: Text("Edit"),)
        ],
      ),
      leading:Builder(
        builder: (BuildContext context){
          return IconButton(onPressed: () => context.pop(), 
          icon: Icon(Icons.arrow_back));

        }) ,
    ),
    body: Container(
      child: SafeArea(
        child: SingleChildScrollView(
          child: 
            Container(
              padding: const EdgeInsets.only(left:20.0 ,right: 20.0,),
              child:
                Form(
                  key: _formKey,
                  child: Column(
                    children:<Widget> [
                      SizedBox(height: 20.0,),
                      TextFormField(
                          readOnly: _editField,
                          controller: _usernameController,
                          decoration: InputDecoration(
                            label: Text("Username"),
                            // Conditionally set the fill color
                            fillColor: _editField ? Colors.grey.shade200 : null,
                            filled: _editField,
                            // Conditionally set the label style
                            labelStyle: TextStyle(
                              color: _editField ? Colors.grey.shade600 : null,
                            ),
                            // Optionally change the border color
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: _editField ? Colors.grey.shade400 : Colors.blue,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: _editField ? Colors.grey.shade400 : Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0,),

                        TextFormField(
                          readOnly: _editField,
                          controller: _emailController,
                          decoration: InputDecoration(
                            label: Text("email"),
                            // Conditionally set the fill color
                            fillColor: _editField ? Colors.grey.shade200 : null,
                            filled: _editField,
                            // Conditionally set the label style
                            labelStyle: TextStyle(
                              color: _editField ? Colors.grey.shade600 : null,
                            ),
                            // Optionally change the border color
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: _editField ? Colors.grey.shade400 : Colors.blue,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: _editField ? Colors.grey.shade400 : Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0,),
                        TextFormField(
                          readOnly: _editField,
                          controller: _first_nameController,
                          decoration: InputDecoration(
                            label: Text("First name"),
                            // Conditionally set the fill color
                            fillColor: _editField ? Colors.grey.shade200 : null,
                            filled: _editField,
                            // Conditionally set the label style
                            labelStyle: TextStyle(
                              color: _editField ? Colors.grey.shade600 : null,
                            ),
                            // Optionally change the border color
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: _editField ? Colors.grey.shade400 : Colors.blue,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: _editField ? Colors.grey.shade400 : Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0,),
                       TextFormField(
                          readOnly: _editField,
                          controller: _last_nameController,
                          decoration: InputDecoration(
                            label: Text("Last name"),
                            // Conditionally set the fill color
                            fillColor: _editField ? Colors.grey.shade200 : null,
                            filled: _editField,
                            // Conditionally set the label style
                            labelStyle: TextStyle(
                              color: _editField ? Colors.grey.shade600 : null,
                            ),
                            // Optionally change the border color
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: _editField ? Colors.grey.shade400 : Colors.blue,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: _editField ? Colors.grey.shade400 : Colors.blue,
                              ),
                            ),
                          ),
                        ),
                      SizedBox(height: 20.0),
                      !_editField
                      ?
                      ElevatedButton(
                        style: ButtonStyle(backgroundColor:  WidgetStatePropertyAll(Theme.of(context).primaryColor)),
                        onPressed: authViewModel.isLoading
                            ? null
                            : () async {
                                debugPrint('Clicked...');

                                if (!_formKey.currentState!.validate()) return;

                                final updated = authViewModel.profile!.changeData(
                                  username: _usernameController.text,
                                  email: _emailController.text,
                                  first_name: _first_nameController.text,
                                  last_name: _last_nameController.text,
                                );

                                final getUser = context.read<AuthViewModel>().user;
                                if (getUser == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("No user available")),
                                  );
                                  return;
                                }

                                final userID = getUser.data.user.id;

                                // ✅ await ensures isLoading triggers UI rebuild properly
                                await authViewModel.updateProfile(updated, userID);

                                if (authViewModel.errorMessage == null) {
                                  setState(() {
                                    _editField = true;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Profile updated successfully!",style: TextStyle(color: Colors.greenAccent),)),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Error: ${authViewModel.errorMessage}")),
                                  );
                                }
                              },
                        child: authViewModel.isLoading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(color: Theme.of(context).primaryColor,strokeWidth: 2.0,),
                              )
                            : const Text("Save",style: TextStyle(color: Colors.white),),
                      )

                    :
                    SizedBox()
                    ],
                  ))
            ),
        )


        )   
      ),
    );
  }
}