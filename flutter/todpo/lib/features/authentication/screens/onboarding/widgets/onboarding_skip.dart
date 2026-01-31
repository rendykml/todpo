import 'package:flutter/material.dart';
import '../../../controllers.onboarding/onboarding_controller.dart';

class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: kToolbarHeight,
      right: 24,
      child: TextButton(
        onPressed: () => OnBoardingController.instance.skipPage(),
        child: Text('Skip', style: Theme.of(context).textTheme.bodyMedium),
      ),
    );
  }
}
