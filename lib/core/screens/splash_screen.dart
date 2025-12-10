import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  bool showLoading = false;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    // Show splash image for 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => showLoading = true);
      _fadeController.forward(); // fade in loading animation

      // Show loading animation for 2 more seconds
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      });
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size
    final size = MediaQuery.of(context).size;
    final double imageWidth = size.width * 0.6; // 60% of screen width
    final double animationWidth = size.width * 0.3; // 30% of screen width

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: showLoading
            ? FadeTransition(
                opacity: _fadeAnimation,
                child: Lottie.asset(
                  'assets/animations/Cosmos.json',
                  width: animationWidth,
                  height: animationWidth,
                ),
              )
            : Image.asset(
                'assets/images/homescreenbg.png',
                width: imageWidth,
                height: imageWidth,
              ),
      ),
    );
  }
}
