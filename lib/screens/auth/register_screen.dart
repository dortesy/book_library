// lib/screens/auth/register_screen.dart
import 'package:flutter/material.dart';
import '../../../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  String _error = '';

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_password != _confirmPassword) {
        setState(() {
          _error = 'Passwords do not match';
        });
        return;
      }
      try {
        await _authService.registerWithEmailAndPassword(_email, _password);
        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        setState(() {
          _error = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Enter an email' : null,
                onSaved: (value) => _email = value ?? '',
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Enter a password' : null,
                onSaved: (value) => _password = value ?? '',
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Confirm your password' : null,
                onSaved: (value) => _confirmPassword = value ?? '',
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                child: Text('Register'),
              ),
              if (_error.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text(
                    _error,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                child: Text('Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}