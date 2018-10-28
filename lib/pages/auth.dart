import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  String emailValue;
  String passwordValue;
  bool _acceptTermsValue = false ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Please Authenticate'),
      ),
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: 'Email'),
              onChanged: (String value) => setState(() => emailValue = value),
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
              onChanged: (String value) => setState(() => passwordValue = value),

            ),
            SwitchListTile(
              title: Text('Accept Terms'),
              value: _acceptTermsValue,
              onChanged: (bool value) => setState(() => _acceptTermsValue = value ),
            ),
            SizedBox(height: 10.0),
            RaisedButton(
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                child: Text('Login'),
                onPressed: () {
                  print(emailValue);
                  print(passwordValue);
                  Navigator.pushReplacementNamed(context, '/products');
                }),
          ],
        ),
      ),
    );
  }
}
