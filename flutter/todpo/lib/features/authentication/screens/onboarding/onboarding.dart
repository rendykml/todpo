import 'package:flutter/material.dart';
import 'widgets/onboarding_page.dart';
import 'widgets/onboarding_skip.dart';
import 'widgets/onboarding_dot_navigation.dart';
import 'widgets/onboarding_next_button.dart';
import 'widgets/onboarding_previous_button.dart';
import 'package:get/get.dart';
import '../../controllers.onboarding/onboarding_controller.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());

    return Scaffold(
      body: Stack(
        children: [
          //horizontal scrollabel pages
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: [
              OnBoardingPage(
                image: 'assets/images/on_boarding_images/onBoarding.gif',
                title: 'Welcome to Todpo',
                subTitle:
                    'Your personal task manager to boost productivity and stay organized.',
              ),
              OnBoardingPage(
                image: 'assets/images/on_boarding_images/onBoarding5.gif',
                title: 'Create and Manage Tasks',
                subTitle:
                    'Easily create, organize, and manage your daily tasks.',
              ),
              OnBoardingPage(
                image: 'assets/images/on_boarding_images/onBoarding3.gif',
                title: 'Get Started',
                subTitle:
                    'Start your journey to better productivity and task management.',
              ),
            ],
          ),
          //skip buttion
          OnBoardingSkip(),

          //Dot Navigation indicator
          OnBoardingDotNavigation(),

          //Next button
          OnBoardingNextButton(),

          //Previous button
          OnBoardingPreviousButton(),
        ],
      ),
    );
  }
}
