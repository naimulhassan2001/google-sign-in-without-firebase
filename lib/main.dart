import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() {
  runApp(const MyApp());
}



class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Initialize GoogleSignIn object
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/userinfo.profile',
    ],
  );

  GoogleSignInAccount? _currentUser;

  @override
  void initState() {
    super.initState();
    // Handle changes to the current user state
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently(); // Automatically sign in the user if possible
  }

  // Sign in method
  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print('Sign-in error: $error');
    }
  }

  // Sign out method
  Future<void> _handleSignOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (error) {
      print('Sign-out error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    GoogleSignInAccount? user = _currentUser;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Google Sign In Demo'),
        ),
        body: Center(
          child: user != null
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Display user information after sign-in
              ListTile(
                leading: GoogleUserCircleAvatar(
                  identity: user,
                ),
                title: Text(user.displayName ?? ''),
                subtitle: Text(user.email),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _handleSignOut,
                child: Text('Sign Out'),
              ),
            ],
          )
              : ElevatedButton(
            onPressed: _handleSignIn,
            child: Text('Sign In with Google'),
          ),
        ),
      ),
    );
  }
}

