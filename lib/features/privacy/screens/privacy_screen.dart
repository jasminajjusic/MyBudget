import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:mybudget/features/routing/app_routes.dart';

class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
    BuildContext context,
    Widget child,
    AxisDirection axisDirection,
  ) {
    return child;
  }
}

class PrivacyScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final tabIndex = useState(0);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 1),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: const Text(
                'Privacy & Terms',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'SFPro',
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Color(0xFF03225C),
                  size: 18,
                ),
                onPressed: () {
                  context.go(AppRoutes.settings);
                },
              ),
            ),
            const Divider(height: 1, thickness: 0.5, color: Colors.grey),
          ],
        ),
      ),

      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () => tabIndex.value = 0,
                        child: Column(
                          children: [
                            Text(
                              'Privacy Policy',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight:
                                    tabIndex.value == 0
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                fontFamily: 'SFPro',
                                color:
                                    tabIndex.value == 0
                                        ? Colors.black
                                        : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => tabIndex.value = 1,
                        child: Column(
                          children: [
                            Text(
                              'Terms and Conditions',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight:
                                    tabIndex.value == 0
                                        ? FontWeight.w400
                                        : FontWeight.w600,
                                fontFamily: 'SFPro',
                                color:
                                    tabIndex.value == 1
                                        ? Colors.black
                                        : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 21, right: 21, top: 9),
                    child: Container(
                      height: 2,
                      width: double.infinity,
                      color: const Color.fromRGBO(232, 232, 232, 1),
                      child: Stack(
                        children: [
                          Align(
                            alignment:
                                tabIndex.value == 0
                                    ? Alignment.centerLeft
                                    : Alignment.centerRight,
                            child: Container(
                              width: MediaQuery.of(context).size.width / 2 - 21,
                              height: 2,
                              color: const Color.fromRGBO(14, 130, 253, 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ScrollConfiguration(
                  behavior: NoGlowScrollBehavior(),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(
                      right: 30,
                      left: 30,
                      bottom: 30,
                    ),
                    child:
                        tabIndex.value == 0
                            ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 32),
                                const Text(
                                  'Privacy Policy',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'SFPro',
                                  ),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  'Last update: January 1, 2025',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'SFPro',
                                    color: Color.fromRGBO(64, 64, 64, 1),
                                  ),
                                ),
                                const SizedBox(height: 26),
                                const Divider(thickness: 1.0),
                                const SizedBox(height: 34),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        'Information We Collect',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'SFPro',
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "We prioritize your security by enabling biometric authentication for accessing the app, such as fingerprint or face recognition. This ensures that only you can open and use the application.",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'SFPro',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      SizedBox(height: 30),
                                      Text(
                                        'How We Use Your Data',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'SFPro',
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "All your data is securely stored locally on your device, eliminating the need for internet connection or cloud storage. This guarantees that your information stays private and under your control at all times.",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'SFPro',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                            : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 32),
                                const Text(
                                  'Terms and Conditions',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'SFPro',
                                  ),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  'Last update: January 1, 2025',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'SFPro',
                                    color: Color.fromRGBO(64, 64, 64, 1),
                                  ),
                                ),
                                const SizedBox(height: 26),
                                const Divider(thickness: 1.0),
                                const SizedBox(height: 34),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        'Usage',
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'SFPro',
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "By using this app, you agree that all your information is securely managed locally without sharing data externally. You are responsible for maintaining your biometric authentication credentials to keep your account secure.",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'SFPro',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      SizedBox(height: 30),
                                      Text(
                                        'Content',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'SFPro',
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "This app provides transparent privacy information, giving you clear insights into how your data is handled. Our goal is to build trust through openness and respect for your privacy.",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'SFPro',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
