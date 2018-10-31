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
  bool _acceptTermsValue = false;
  DecorationImage _buildBackgroundImage() {
    return DecorationImage(
        image: AssetImage('assets/background.jpg'),
        fit: BoxFit.cover,
        colorFilter:
            ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop));
  }

  Widget _buildEmailTextInput() {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          labelText: 'Email', filled: true, fillColor: Colors.white),
      onChanged: (String value) => setState(() => emailValue = value),
    );
  }

  Widget _buildPasswordTextInput() {
    return TextField(
      obscureText: true,
      decoration: InputDecoration(
          labelText: 'Password', filled: true, fillColor: Colors.white),
      onChanged: (String value) => setState(() => passwordValue = value),
    );
  }

  Widget _buildAcceptSwitch() {
    return SwitchListTile(
      title: Text('Accept Terms'),
      value: _acceptTermsValue,
      onChanged: (bool value) => setState(() => _acceptTermsValue = value),
    );
  }

  void submitForm() {
    print(emailValue);
    print(passwordValue);
    Navigator.pushReplacementNamed(context, '/products');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Please Authenticate'),
      ),
      body: Container(
          decoration: BoxDecoration(image: _buildBackgroundImage()),
          padding: EdgeInsets.all(10.0),
          child: Center(
              child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _buildEmailTextInput(),
                SizedBox(
                  height: 10.0,
                ),
                _buildPasswordTextInput(),
                SizedBox(height: 10.0),
                _buildAcceptSwitch(),
                RaisedButton(
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  child: Text('Login'),
                  onPressed: submitForm,
                )
              ],
            ),
          ))),
    );
  }
}
