import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_english_learning/viewmodels/auth/auth_view_models.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget{

  @override
  _AuthScreenState createState() => _AuthScreenState();
}


class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    // Reset errors whenever we come to this screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthViewModel>().resetState();
    });
}


  // ADD THIS - Fix memory leak
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ADD THIS - Validation methods
  String? _validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username cannot be empty';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }
    return null;
  }

  Widget _customLoginForm({
    required TextEditingController controller,
    required String labelText,
    required String hintext,
    required String? Function(String?) validator,
    required double paddingPlaceholderVertical,
    required double PaddingPlaceholderHorizontal,
    required double fontHintSize,
    required double fontLabelSize,
    bool obscureText=false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    Color? fontColor, 
  }){
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        isDense: false,
        filled: true,
        fillColor: Colors.white,
        labelText: labelText,
        labelStyle: TextStyle(
          fontFamily: 'Poppins',
          color: Colors.grey,
          fontSize: fontLabelSize,
        ),
        hintText: hintext,
        hintStyle: TextStyle(
          fontFamily: 'Poppins',
          color: Colors.grey,
          fontSize: fontHintSize, 
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: paddingPlaceholderVertical,
          horizontal: PaddingPlaceholderHorizontal,
        ),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();

    return Scaffold(
      body: Stack(
        children: <Widget>[
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
                    width: 320.0,
                    height: 320.0,
                    fit: BoxFit.fitHeight,
                    )

              ) 
            ),

          // ADD THIS - Make it scrollable and responsive
          SafeArea(
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
                child: Column(
                  children: [
                
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50.0),
                    child: Column(
                      children: <Widget> [
                      Image(
                        image: AssetImage('assets/icons/brain.png')
                      ),

                      Text("Brain Boost"
                      ,style: TextStyle(
                        fontSize: 30.0,
                        fontFamily: Theme.of(context).textTheme.bodySmall?.fontFamily,
                        fontWeight: FontWeight.bold,
                      ),),
                      ],
                    ) 
                    
                  ),
                ),

                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50.0),
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(0, 0, 0, 0.0),
                    ),
                    child: Form(  // ADD THIS - Wrap with Form
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              child: Column(
                                children: [

                                    _customLoginForm(
                                      controller: _usernameController, 
                                      labelText: 'username', 
                                      hintext: 'type your username', 
                                      validator: _validateUsername,
                                      paddingPlaceholderVertical: 10.0,
                                      PaddingPlaceholderHorizontal: 10.0,
                                      fontHintSize:10.0,
                                      fontLabelSize:15.0,
                                    ),
                                  const SizedBox(height: 20.0),
                                  _customLoginForm(
                                      controller: _passwordController, 
                                      labelText: 'password', 
                                      hintext: 'type your password', 
                                      validator: _validatePassword,
                                      obscureText: _obscurePassword,
                                      paddingPlaceholderVertical: 10.0,
                                      PaddingPlaceholderHorizontal: 10.0,
                                      fontHintSize:10.0,
                                      fontLabelSize:15.0,
                                      suffixIcon: IconButton(
                                        onPressed: () { 
                                          setState(() {
                                          _obscurePassword = !_obscurePassword;
                                          });
                                        }, 
                                        icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off))
                                    ),
                                    
                                                                                                 
                                  const SizedBox(height: 25.0),
                                  
                                  // CHANGED - Better loading state and validation
                                  if(authViewModel.isLoading)
                                    Column(
                                      children: [
                                        const CircularProgressIndicator(),
                                        SizedBox(height: 8),
                                        Text("Logging in...", style: TextStyle(color: Colors.white)),
                                      ],
                                    )
                                  else
                                    ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColor),
                                      ),
                                      onPressed: () async {
                                        // ADD THIS - Validate before login
                                        if (_formKey.currentState!.validate()) {
                                          debugPrint("login...");
                                          await authViewModel.login(
                                            _usernameController.text.trim(),  // ADD trim()
                                            _passwordController.text
                                          );
                                        }
                                      },
                                      child: const Text('Login',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white
                                        )
                                      ),
                                    ),

                                  Container(
                                    child: TextButton(
                                      onPressed: authViewModel.isLoading ? null : () {  // ADD THIS - disable when loading
                                        debugPrint("Navigating to /register");
                                        context.go('/register');
                                      },
                                      child: Text("Dont have an account?",
                                      style: TextStyle(color: Theme.of(context).primaryColor),), 
                                    )
                                  ),

                                  // ADD THIS - Show error messages
                                  if (authViewModel.errorMessage != null)
                                    Container(
                                      margin: EdgeInsets.only(top: 16),
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.red[100],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        overflow: TextOverflow.clip,
                                        authViewModel.errorMessage!,
                                        style: TextStyle(
                                          color: Colors.red[800],
                                          fontSize: 14,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                ],
                              )
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),

                  ],
                ), 
                
              ),
            ),
          ),
        ],
      ),
    );
  }
}