import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F1F1),
        elevation: 0,
        title: const Text(
          'Privacy Policy',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.normal,
            color: Colors.black87,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '⦾ Introduction',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'This Privacy Policy explains how we collect, use, and disclose your information when you use our app "hypeBard". By using our app, you consent to the collection, use, and disclosure of your information as described in this Privacy Policy.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              '➊ Information We Collect',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'We do not collect or store any personal information or data in the cloud. All processing is done locally on your device to ensure speed and data privacy.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              '➋ Permissions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Our app requires the following permissions:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              '⦿ Internet: This permission is required for the app to connect to the internet and utilize the GPT-3.5 Turbo engine from OpenAI.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              '⦿ Bluetooth: This permission is used for accessing the connected bluetooth audio services, so that you can access speech-to-text function using that device.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              '⦿ Nearby Devices: This permission is used for connecting the app to the bluetooth audio devices supporting the nearby device function for seamless integration.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              '⦿ Microphone (Speech to Text): This permission is required to enable speech recognition and convert speech into text input.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              "➌ Children's Privacy",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Our app does not knowingly collect personal information from children under the age of 16. If we learn that we have collected personal information of a child under 16, we will take steps to delete such information as soon as possible.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              '➍ Changes to This Privacy Policy',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'We may update our Privacy Policy from time to time. Any changes we make will be posted on this page, and the revised date will be indicated at the top of the page. We encourage you to review this Privacy Policy periodically for any updates or changes.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              '➎ Contact Us',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'If you have any questions or concerns about our Privacy Policy, please contact us:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              '⦿ Email: somritdasgupta@outlook.com',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              '➏ Conclusion',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'By using our hypeBard, you acknowledge that you have read and understood this Privacy Policy and agree to its terms and conditions.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'By using our hypeBard, you acknowledge that you have read and understood this Privacy Policy and agree to its terms and conditions.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Vibration.vibrate(duration: 50);
                launch('https://www.openai.com/privacy-policy/');
              },
              style: ElevatedButton.styleFrom(
                elevation: 10,
                foregroundColor: Colors.white, backgroundColor: Colors.black87, // Set the button's text color
                textStyle: const TextStyle(fontSize: 18),
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 12), // Set the button's padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), // Set the button's border radius
                ),
              ),
              child: const Text('OpenAI ChatGPT Privacy Policy'),
            ),
          ],
        ),
      ),
    );
  }
}
