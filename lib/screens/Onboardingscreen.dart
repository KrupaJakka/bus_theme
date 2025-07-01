import 'package:bus_theme/screens/role_selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnboardingScreen(),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int currentIndex = 0;

  final List<Map<String, String>> onboardingData = [
    {
      'image': 'assets/city_bus-cuate.svg',
      'title': 'Track Your Bus Live',
      'desc': 'Get real-time location updates of your college bus.',
    },
    {
      'image': 'assets/Navigation-pana.svg',
      'title': 'Stay Informed',
      'desc': 'Receive alerts when the bus reaches your stop.',
    },
    {
      'image': 'assets/Paper_map-cuate.svg',
      'title': 'Connect Effortlessly',
      'desc': 'Students and parents stay connected and secure.',
    },
  ];

  void navigateToRoleSelection() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const RoleSelectionApp()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: onboardingData.length,
                  onPageChanged: (index) =>
                      setState(() => currentIndex = index),
                  itemBuilder: (context, index) => OnboardContent(
                    image: onboardingData[index]['image']!,
                    title: onboardingData[index]['title']!,
                    description: onboardingData[index]['desc']!,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  onboardingData.length,
                  (index) => buildDot(index),
                ),
              ),
              const SizedBox(height: 20),

              // Both Next and Get Started buttons look the same now
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: currentIndex == 2
                    ? navigateToRoleSelection
                    : () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      },
                child: Text(currentIndex == 2 ? 'Get Started' : 'Next'),
              ),

              const SizedBox(height: 40),
            ],
          ),

          // Skip Button at top-right
          Positioned(
            top: 40,
            right: 20,
            child: TextButton(
              onPressed: navigateToRoleSelection,
              child: const Text(
                'Skip',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 6),
      height: 10,
      width: currentIndex == index ? 22 : 10,
      decoration: BoxDecoration(
        color: currentIndex == index ? Colors.black : Colors.grey.shade600,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

class OnboardContent extends StatelessWidget {
  final String image, title, description;

  const OnboardContent({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(image, height: 250),
          const SizedBox(height: 40),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          Text(
            description,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
