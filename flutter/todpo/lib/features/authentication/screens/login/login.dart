import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                        decoration: InputDecoration(
                          prefixIcon: Icon(Iconsax.direct_right),
                          labelText: 'Email',
                        ),
                      ),
                      SizedBox(height: 16.0),

                      //password field
                      TextFormField(
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
                            backgroundColor: const Color.fromARGB(
                              255,
                              157,
                              92,
                              92,
                            ),
                          ),
                          onPressed: () {},
                          child: Text(
                            'Sign In',
                            style: TextStyle(color: Colors.white),
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
                          onPressed: () {},
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
