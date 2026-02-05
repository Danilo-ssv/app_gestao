import 'package:app_gestao/src/modules/authentication/models/login_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_gestao/src/modules/authentication/state/authentication_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  bool obscureText = true;

  void login() {
    if (context.read<AuthenticationState>().isLoading) return;

    context.read<AuthenticationState>().login(
          context,
          LoginModel(
            email: _emailController.text,
            senha: _senhaController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: double.infinity),
            TextField(
              controller: _emailController,
              onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
              onSubmitted: (_) => login(),
              decoration: const InputDecoration(hintText: 'E-mail'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _senhaController,
              onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
              onSubmitted: (_) => login(),
              decoration: InputDecoration(
                hintText: 'Senha',
                suffixIcon: IconButton(
                  onPressed: () => setState(() => obscureText = !obscureText),
                  icon: obscureText ? const Icon(Icons.remove_red_eye) : const Icon(Icons.remove_red_eye_outlined),
                ),
              ),
              obscureText: obscureText,
            ),
            const SizedBox(height: 10),
            Material(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                onTap: () => login(),
                borderRadius: BorderRadius.circular(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    context.watch<AuthenticationState>().isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Login',
                            style: TextStyle(fontSize: 17, color: Colors.white),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
