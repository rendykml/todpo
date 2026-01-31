import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../controllers.onboarding/onboarding_controller.dart';

class OnBoardingNextButton extends StatelessWidget {
  const OnBoardingNextButton({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Positioned(
      right: 24,
      bottom: MediaQuery.of(context).size.height * 0.1 + 24,
      child: ElevatedButton(
        onPressed: () => OnBoardingController.instance.nextPage(),
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          backgroundColor: dark ? Colors.white : Colors.black,
          padding: EdgeInsets.all(16),
        ),
        child: Icon(
          Iconsax.arrow_right_3,
          color: dark ? Colors.black : Colors.white,
          size: 24,
        ),
      ),
    );
  }
}
