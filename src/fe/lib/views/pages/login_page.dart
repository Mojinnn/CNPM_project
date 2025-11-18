import 'package:first_flutter/data/auth_service.dart';
import 'package:first_flutter/views/admin_widget_tree.dart';
import 'package:first_flutter/views/police_widget_tree.dart';
import 'package:first_flutter/views/viewer_widget_tree.dart';
import 'package:first_flutter/views/widgets/hero_widget.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

bool _isObsecure = true;

class _LoginPageState extends State<LoginPage> {
  TextEditingController controllerEmail = TextEditingController(
    text: 'toantran1752004@viewer.com',
  );
  TextEditingController controllerPassword = TextEditingController(
    text: '123456',
  );

  @override
  void dispose() {
    controllerEmail.dispose();
    controllerPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: LayoutBuilder(
              builder: (context, BoxConstraints constraints) {
                return FractionallySizedBox(
                  widthFactor: mediaWidth > 1000 ? 0.5 : 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      HeroWidget(title: widget.title),
                      SizedBox(height: 20.0),
                      TextField(
                        controller: controllerEmail,

                        decoration: InputDecoration(
                          hintText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        onEditingComplete: () {
                          setState(() {});
                        },
                      ),
                      SizedBox(height: 10.0),
                      TextField(
                        controller: controllerPassword,
                        obscureText: _isObsecure,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isObsecure = !_isObsecure;
                              });
                            },
                            icon: Icon(
                              _isObsecure
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                        onEditingComplete: () {
                          setState(() {});
                        },
                      ),
                      SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: () {
                          onPressedLogin();
                        },
                        style: FilledButton.styleFrom(
                          minimumSize: Size(double.infinity, 50.0),
                        ),
                        child: Text(widget.title),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void onPressedLogin() async {
    final userInfo = await AuthService.login(
      controllerEmail.text,
      controllerPassword.text,
    );

    if (userInfo == null) {
      // showError("Wrong email or password");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Wrong email or password")));
      return;
    }

    // Điều hướng theo role:
    Widget nextPage;

    switch (userInfo.role) {
      case "viewer":
        nextPage = ViewerWidgetTree();
        break;
      case "police":
        nextPage = PoliceWidgetTree();
        break;
      case "admin":
        nextPage = AdminWidgetTree();
        break;
      default:
        nextPage = ViewerWidgetTree();
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => nextPage),
      (route) => false,
    );
  }
}
