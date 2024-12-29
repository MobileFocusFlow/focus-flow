import 'package:flutter/material.dart';
import 'register.dart';
import 'temp_user_db.dart';
import 'home_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void login() {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      if (UserDatabase.login(email, password)) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid email or password')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      appBar: AppBar(title: const Text("Login"),backgroundColor: Colors.redAccent ,),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orangeAccent, Colors.redAccent],
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
               
              Text("Welcome Back",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white)),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email',
                prefixIcon:Icon(Icons.email), 
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius:BorderRadius.circular(50.0),
                ),
                filled:true,
                fillColor: Colors.white.withOpacity(0.7),
                ),
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Colors.black),
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
                decoration: InputDecoration(labelText: 'Password', 
                prefixIcon:Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius:BorderRadius.circular(50.0),
                ),
                filled:true,
                fillColor: Colors.white.withOpacity(0.7),
                labelStyle: TextStyle(color: Colors.black)),
                obscureText: true,
                style: TextStyle(color: Colors.black),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style:ElevatedButton.styleFrom(
                  padding:const EdgeInsets.symmetric(horizontal: 50,vertical: 15),
                  shape:RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  backgroundColor: Colors.lightGreen,
                  foregroundColor: Colors.black,

                ),
                onPressed: login,
                 child: const Text('Login')
                ),
              const SizedBox(height: 16),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding:const EdgeInsets.symmetric(horizontal: 50,vertical: 15),
                  shape:RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  backgroundColor: Colors.lightGreen,
                  foregroundColor: Colors.blue,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterScreen()),
                  );
                },
                child: const Text("Don't have an account? Register", style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
