import 'package:flutter/material.dart';
import '../../../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _error = '';

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await _authService.signInWithEmailAndPassword(_email, _password);
        // Changed from pushReplacementNamed to pushNamedAndRemoveUntil to clear the navigation stack
        Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
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
      appBar: AppBar(title: Text('Вход')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Электронная почта'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Введите электронную почту' : null,
                onSaved: (value) => _email = value ?? '',
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Пароль'),
                obscureText: true,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Введите пароль' : null,
                onSaved: (value) => _password = value ?? '',
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                child: Text('Войти'),
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
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/register'),
                child: Text('Нужен аккаунт? Зарегистрироваться'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}