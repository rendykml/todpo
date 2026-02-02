import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:todpo/navigation_menu.dart';
import '../signup/signup.dart';
import '../../../../services/auth_services.dart';
import '../../../../utils/token_storage.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(bottom: 24, left: 24, top: 56, right: 24),
          child: Column(
            children: [
              //logo and welcome text
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 0.0),
                    child: Image(
                      height: 150,
                      image: AssetImage(
                        dark
                            ? 'assets/logos/todpo-white.PNG'
                            : 'assets/logos/todpo-black.PNG',
                      ),
                    ),
                  ),
                  Text(
                    'Welcome Back,',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6.0),
                  Text(
                    'Login to your account',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),

              //form
              Form(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32.0),
                  child: Column(
                    children: [
                      //email field
                      TextFormField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Iconsax.direct_right),
                          labelText: 'Username',
                        ),
                      ),
                      SizedBox(height: 16.0),

                      //password field
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Iconsax.password_check),
                          labelText: 'Password',
                          suffixIcon: Icon(Iconsax.eye_slash),
                        ),
                      ),
                      SizedBox(height: 24.0),

                      // Remember Me and Forgot Password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //remember me
                          Row(
                            children: [
                              Checkbox(value: false, onChanged: (value) {}),
                              Text(
                                'Remember Me',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ],
                          ),

                          // Forgot Password
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Forgot Password',
                              style: Theme.of(
                                context,
                              ).textTheme.labelMedium?.copyWith(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.0),

                      // Sign In button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: dark
                                ? const Color.fromARGB(255, 255, 255, 255)
                                : const Color.fromARGB(255, 0, 0, 0),
                            // backgroundColor: const Color.fromARGB(
                            //   255,
                            //   157,
                            //   92,
                            //   92,
                            // ),
                          ),
                          onPressed: () async {
                            setState(() => isLoading = true);

                            try {
                              final response = await AuthService.login(
                                username: usernameController.text,
                                password: passwordController.text,
                              );

                              if (response['token'] != null &&
                                  response['user'] != null) {
                                final token = response['token'];
                                final userId = response['user']['id'];

                                await TokenStorage.saveToken(token);
                                await TokenStorage.saveUserId(userId);

                                if (!mounted) return;

                                // PILIH SATU SAJA ⬇️

                                // 🔹 Kalau pakai Navigator
                                // Navigator.pushReplacement(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (_) => const HomeScreen(),
                                //   ),
                                // );

                                // 🔹 ATAU kalau pakai GetX
                                Get.offAll(() => const NavigationMenu());
                              } else {
                                if (!mounted) return;

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      response['message'] ?? 'Login gagal',
                                    ),
                                  ),
                                );
                              }
                            } catch (e) {
                              if (!mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: $e')),
                              );
                            }

                            setState(() => isLoading = false);
                          },

                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  'Sign In',
                                  style: TextStyle(
                                    color: dark ? Colors.black : Colors.white,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: 16.0),

                      // Create Account
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Create Account',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Divider
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Divider(
                      color: dark ? Colors.white54 : Colors.black54,
                      thickness: 0.5,
                      endIndent: 5,
                      indent: 60,
                    ),
                  ),
                  Text(
                    ' Made in Todpo ',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  Flexible(
                    child: Divider(
                      color: dark ? Colors.white54 : Colors.black54,
                      thickness: 0.5,
                      endIndent: 60,
                      indent: 5,
                    ),
                  ),
                ],
              ),

              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Container(decoration: BoxDecoration())],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
