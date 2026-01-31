import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers.onboarding/onboarding_controller.dart';

class OnBoardingPreviousButton extends StatelessWidget {
  const OnBoardingPreviousButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 24,
      top: kToolbarHeight,
      child: Obx(() {
        if (OnBoardingController.instance.currentPageIndex.value == 0) {
          return SizedBox.shrink();
        }
    
        return TextButton(
          onPressed: () => OnBoardingController.instance.backPage(),
          child: Text(
            'Previous',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        );
      }),
    );
  }
}