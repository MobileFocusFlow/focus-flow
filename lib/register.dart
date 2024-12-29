import 'package:flutter/material.dart';
import 'temp_user_db.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
   bool hasUppercase = false;
  bool hasDigits = false;
  bool hasLowercase = false;
  bool hasMinLength = false;
  bool _isPasswordVisible=false;

  void _validatePassword(String password) {
    setState(() {
      hasUppercase = password.contains(RegExp(r'[A-Z]'));
      hasDigits = password.contains(RegExp(r'[0-9]'));
      hasLowercase = password.contains(RegExp(r'[a-z]'));
      hasMinLength = password.length >= 8;
    });
  }

  void register() {
    if (_formKey.currentState!.validate()) {
      UserDatabase.users[UserDatabase.emailIdentifier] =
          _emailController.text.trim();
      UserDatabase.users[UserDatabase.passwordIdentifier] =
          _passwordController.text.trim();

      if (UserDatabase.register(
          UserDatabase.users[UserDatabase.emailIdentifier]!,
          UserDatabase.users[UserDatabase.passwordIdentifier]!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration Successful')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email already registered')),
        );
      } 
    }
  }

  Widget _buildCriteriaRow(String criteria, bool met) {
    return Row(
      children: [
        Icon(
          met ? Icons.check : Icons.close,
          color: met ? Colors.black : Colors.white,
        ),
        const SizedBox(width: 8),
        Text(
          criteria,
          style: TextStyle(color: met ? Colors.black : Colors.white),
        ),
      ],
    );
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepOrangeAccent, Colors.orange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orangeAccent, Colors.pinkAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Create Account",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white)),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                  borderRadius:BorderRadius.circular(50.0),
                ),
                filled:true,
                fillColor: Colors.white.withOpacity(0.7),
                labelStyle: TextStyle(color: Colors.black)), 
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  onChanged: _validatePassword,
                  decoration: InputDecoration(labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(
                  borderRadius:BorderRadius.circular(50.0),
                ),
                filled:true,
                fillColor: Colors.white.withOpacity(0.7),
                  labelStyle: TextStyle(color: Colors.black),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_isPasswordVisible,
                validator: (value) {
                    if (value == null) {
                      return 'Please enter your password';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    if (!RegExp(r'[A-Z]').hasMatch(value)) {
                      return 'Password must contain at least one uppercase letter';
                    }
                    if (!RegExp(r'[a-z]').hasMatch(value)) {
                      return 'Password must contain at least one lowercase letter';
                    }
                    if (!RegExp(r'[0-9]').hasMatch(value)) {
                      return 'Password must contain at least one digit';
                    }
                    return null;
                    
                  },
                ),
                const SizedBox(height: 16),
                _buildCriteriaRow('At least 8 characters', hasMinLength),
            _buildCriteriaRow('At least 1 uppercase letter', hasUppercase),
            _buildCriteriaRow('At least 1 lowercase letter', hasLowercase),
            _buildCriteriaRow('At least 1 number', hasDigits),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: OutlinedButton.styleFrom(
                  padding:const EdgeInsets.symmetric(horizontal: 50,vertical: 15),
                  shape:RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  backgroundColor: Colors.lightGreen,
                  foregroundColor: Colors.blue,
                ),
                    onPressed: register, 
                    child: const Text('Register',style: TextStyle(color:Colors.black),)
                ),  
              ],
            ),
          ),
        ),
      ),
    );
  }
}
