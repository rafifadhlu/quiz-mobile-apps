import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_english_learning/models/register_models.dart';
import 'package:provider/provider.dart';


import 'package:mobile_english_learning/viewmodels/auth/register_view_models.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();

  bool _obscureText = true;
  
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _firstnameController.dispose();
    _lastnameController.dispose();
    super.dispose();
  }

  // Input validation methods
  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }
    if (value.length < 3) {
      return 'Username must be at least 3 characters';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateName(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    if (value.length < 2) {
      return '$fieldName must be at least 2 characters';
    }
    return null;
  }

  // Custom TextFormField builder for consistency
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
  final registerViewModel = context.watch<RegisterViewModel>();
  
    return Scaffold(
      body: Stack(
        children: <Widget> [

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


          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    SizedBox(height: 20.0,),
                    Text(
                      registerViewModel.errorMessage ?? 'Create New Account',
                      style: TextStyle(
                        fontSize: 22,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w200,
                        color: registerViewModel.errorMessage != null 
                            ? Colors.red 
                            : Theme.of(context).primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    if (registerViewModel.errorMessage == null) ...[
                      Text(
                        'sign up to continue',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontFamily: 'Poppins',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    
                    SizedBox(height: 32),
                    // Form Fields
                    _customLoginForm(
                      controller: _usernameController, 
                      labelText: "Username", 
                      hintext: "Enter your username", 
                      validator: _validateUsername, 
                      paddingPlaceholderVertical: 10.0,
                      PaddingPlaceholderHorizontal: 10.0,
                      fontHintSize:10.0,
                      fontLabelSize:15.0,),
                    
                    SizedBox(height: 16),
                    _customLoginForm(
                      controller: _emailController, 
                      labelText: "Email", 
                      hintext: "Enter your email address", 
                      validator: _validateEmail, 
                      paddingPlaceholderVertical: 10.0,
                      PaddingPlaceholderHorizontal: 10.0,
                      fontHintSize:10.0,
                      fontLabelSize:15.0,
                      keyboardType: TextInputType.emailAddress
                      ),
                    
                    SizedBox(height: 16),
                    
                    _customLoginForm(
                    controller: _passwordController, 
                    labelText: 'password', 
                    hintext: 'type your password', 
                    validator: _validatePassword,
                    obscureText: _obscureText,
                    paddingPlaceholderVertical: 10.0,
                    PaddingPlaceholderHorizontal: 10.0,
                    fontHintSize:10.0,
                    fontLabelSize:15.0,
                    suffixIcon: IconButton(
                        onPressed: () { 
                        setState(() {
                            _obscureText = !_obscureText;
                            });
                        }, 
                        icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off))
                    ),
                    SizedBox(height: 16),
                    
                    // Name fields in a responsive row
                    LayoutBuilder(
                      builder: (context, constraints) {
                        // Use row layout for wider screens
                        if (constraints.maxWidth > 600) {
                          return Row(
                            children: [
                              Expanded(

                              child:_customLoginForm(
                                    controller: _firstnameController, 
                                    labelText: "First Name", 
                                    hintext: "Enter your First Name", 
                                    validator: (value) => _validateName(value, 'First name'), 
                                    paddingPlaceholderVertical: 10.0,
                                    PaddingPlaceholderHorizontal: 10.0,
                                    fontHintSize:10.0,
                                    fontLabelSize:15.0,
                                    keyboardType: TextInputType.name),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: _customLoginForm(
                                    controller: _lastnameController, 
                                    labelText: "Last Name", 
                                    hintext: "Enter your Last Name", 
                                    validator: (value) => _validateName(value, 'Last Name'), 
                                    paddingPlaceholderVertical: 10.0,
                                    PaddingPlaceholderHorizontal: 10.0,
                                    fontHintSize:10.0,
                                    fontLabelSize:15.0,
                                    keyboardType: TextInputType.name),
                              ),
                            ],
                          );
                        } else {
                          // Use column layout for smaller screens
                          return Column(
                            children: [
                              _customLoginForm(
                                    controller: _firstnameController, 
                                    labelText: "First Name", 
                                    hintext: "Enter your First Name", 
                                    validator: (value) => _validateName(value, 'First name'), 
                                    paddingPlaceholderVertical: 10.0,
                                    PaddingPlaceholderHorizontal: 10.0,
                                    fontHintSize:10.0,
                                    fontLabelSize:15.0,
                                    keyboardType: TextInputType.name),
                              SizedBox(height: 16),
                              _customLoginForm(
                                    controller: _lastnameController, 
                                    labelText: "Last Name", 
                                    hintext: "Enter your Last Name", 
                                    validator: (value) => _validateName(value, 'Last Name'), 
                                    paddingPlaceholderVertical: 10.0,
                                    PaddingPlaceholderHorizontal: 10.0,
                                    fontHintSize:10.0,
                                    fontLabelSize:15.0,
                                    keyboardType: TextInputType.name),
                            ],
                          );
                        }
                      },
                    ),
                    
                    SizedBox(height: 32),
                    
                    // Register Button
                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: registerViewModel.isLoading ? null : _handleRegister,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: registerViewModel.isLoading
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'Creating Account...',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                'Create Account',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    
                    SizedBox(height: 24),
                    
                    // Login link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigate to login screen
                            context.go('/login');
                          },
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ) 
      
    );
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      final registerViewModel = context.read<RegisterViewModel>();
      await registerViewModel.registerUser(
        _usernameController.text.trim(),
        _passwordController.text,
        _emailController.text.trim(),
        _firstnameController.text.trim(),
        _lastnameController.text.trim(),
      );
    }
  }
}