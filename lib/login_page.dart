import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynote_app/register_screen.dart';
import 'firebase_options.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch(snapshot.connectionState){
            case ConnectionState.done:return Column(
              children: [
                TextField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(hintText: 'Email'),
                ),
                TextField(
                  controller: _password,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(hintText: 'Password'),
                ),
                SizedBox(height: 10,),
                TextButton(
                    onPressed: () async {
                      final email = _email.text;
                      final password = _password.text;
                     try {
                            final userCred = await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: email, password: password);
                          } on FirebaseAuthException catch(e){
                       print(e.code);
                       if(e.code == 'user-not-found'){
                         print('User not found');
                       } else if(e.code == 'wrong-password'){
                         print('Wrong password');
                       }

                     }
                        },
                    child: Text('Login')),
                TextButton(
                    onPressed:() => Navigator.push(context, MaterialPageRoute(builder: (builder) => RegisterPage())),
                    child: Text('Register')),
              ],
            );
          } return Text('Loading');

        }


      ),
    );
  }
}
