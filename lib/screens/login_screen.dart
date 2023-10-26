import 'package:flutter/material.dart';
import 'package:smart_menu_app/api/smart_menu_socker_api.dart';
import 'package:smart_menu_app/screens/qrcode_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String userEmail = "";
  String userPassword = "";

  goToQrCodeScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const QrCodeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SmartMenuSocketApi().disconnect();
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFF2),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 8, bottom: 16),
                    child: const Image(image: AssetImage('images/logo.png')),
                  ),
                ),
                const SizedBox(
                  child: Text(
                    "Login",
                    style: TextStyle(
                        fontFamily: 'Sofia',
                        fontWeight: FontWeight.bold,
                        fontSize: 32),
                  ),
                ),
                Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: const Text(
                          "E-mail",
                          style: TextStyle(
                            fontFamily: 'Sofia',
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: TextFormField(
                          onChanged: (value) {
                            userEmail = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email Inválido';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            labelText: 'Digite seu email',
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: const Text(
                          "Senha",
                          style: TextStyle(
                            fontFamily: 'Sofia',
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: TextFormField(
                          onChanged: (value) {
                            userPassword = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Senha inválida';
                            }
                            return null;
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            labelText: 'Digite sua senha',
                          ),
                        ),
                      ),
                      Container(
                        width: screenWidth,
                        height: 60,
                        padding: const EdgeInsets.only(
                          left: 50,
                          right: 50,
                        ),
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Text(
                            'LOGIN',
                            style: TextStyle(
                                fontFamily: 'Sofia',
                                fontWeight: FontWeight.w800,
                                fontSize: 16),
                          ),
                        ),
                      ),
                      const Center(
                          child: Text(
                        "Ou entre por QR-Code no botão à direita 😊",
                        style: TextStyle(fontFamily: 'Sofia', fontSize: 16),
                      ))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          goToQrCodeScreen();
        },
        tooltip: 'QR code',
        child: const Icon(Icons.qr_code),
      ),
    );
  }
}
