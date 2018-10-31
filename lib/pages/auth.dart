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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Please Authenticate'),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/background.jpg'), fit: BoxFit.cover, colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop))),
        padding: EdgeInsets.all(10.0),
        child: Center( child:
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: 'Email', filled: true, fillColor: Colors.white ),
                onChanged: (String value) => setState(() => emailValue = value),
              ),
              SizedBox(height: 10.0,),
              TextField(
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password', filled: true, fillColor: Colors.white),
                onChanged: (String value) =>
                    setState(() => passwordValue = value),
              ),
              SwitchListTile(
                title: Text('Accept Terms'),
                value: _acceptTermsValue,
                onChanged: (bool value) =>
                    setState(() => _acceptTermsValue = value),
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
        ))

      ),
    );
  }
}
