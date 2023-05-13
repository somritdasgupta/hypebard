import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hypebard/page/PrivacyPolicyPage.dart';
import 'package:hypebard/stores/AIChatStore.dart';
import 'package:hypebard/utils/Chatgpt.dart';
import 'package:provider/provider.dart';
import 'package:sp_util/sp_util.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';

import '../utils/Utils.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> with WidgetsBindingObserver {
  bool isCopying = false;
  final TextEditingController _keyTextEditingController =
      TextEditingController();
  final TextEditingController _urlTextEditingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        // TODO: Switch from background to foreground, the interface is visible.
        break;
      case AppLifecycleState.paused:

        /// TODO: Switch from foreground to background, the interface is not visible.
        break;
      case AppLifecycleState.inactive:

        /// TODO: Handle this case.
        break;
      case AppLifecycleState.detached:

        /// TODO: Handle this case.
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            toolbarHeight: 60,
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  splashColor: Colors.white,
                  highlightColor: Colors.white,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const SizedBox(
                    height: 60,
                    child: Row(
                      children: [
                        SizedBox(width: 24),
                        Icon(
                          Icons.arrow_back_ios_rounded,
                          size: 30,
                          weight: 100,
                          color: Colors.black,
                        ),
                        SizedBox(width: 12),
                        Text(
                          "Settings",
                          style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontSize: 26,
                            height: 0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(width: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFFF6F1F1),
            elevation: 0,
          ),
          body: Container(
            color: const Color(0xFFF6F1F1),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    renderItemWidget(
                      Icons.vpn_key,
                      Colors.lightGreen,
                      26,
                      'Customize OpenAI API',
                      () async {
                        String cacheKey = ChatGPT.getCacheOpenAIKey();
                        _keyTextEditingController.text = cacheKey;
                        _showCustomOpenAIKeyDialog();
                      },
                    ),
                    renderItemWidget(
                      Icons.link,
                      Colors.deepPurpleAccent,
                      26,
                      'Customize OpenAI URL',
                      () async {
                        String cacheUrl = ChatGPT.getCacheOpenAIBaseUrl();
                        _urlTextEditingController.text = cacheUrl;
                        _showCustomOpenAIUrlDialog();
                      },
                    ),
                    renderItemWidget(
                      Icons.face,
                      Colors.deepPurple,
                      26,
                      'Hey, somrit here!',
                      () async {
                        final Uri url = Uri.parse(
                            'https://www.linkedin.com/in/somritdasgupta');
                        launchURL(url.toString());
                      },
                    ),
                    renderItemWidget(
                      Icons.privacy_tip_rounded,
                      Colors.red,
                      26,
                      'Privacy Policy',
                      () async {
                        Vibration.vibrate(duration: 50);
                        Utils.jumpPage(context, const PrivacyPolicyPage());
                      },
                    ),
                    renderItemWidget(
                      Icons.delete,
                      Colors.indigo,
                      22,
                      'Clear Data',
                      () {
                        ChatGPT.storage.erase();
                        final store =
                            Provider.of<AIChatStore>(context, listen: false);
                        store.syncStorage();
                        SpUtil.clear();
                        EasyLoading.showToast('Data cleared successfully');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const Positioned(
          left: 0,
          right: 0,
          bottom: 10,
          child: Text(
            'Made with ❤ by Somrit',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget renderItemWidget(
    IconData icon,
    Color iconColor,
    double iconSize,
    String title,
    VoidCallback onPressed,
  ) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.pink[350],
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.pinkAccent.withOpacity(0.4),
              offset: const Offset(0, 2),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.white60,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: iconSize,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _showCustomOpenAIKeyDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          backgroundColor: Colors.white,
          elevation: 60,
          clipBehavior: Clip.antiAlias,
          insetAnimationCurve: Curves.fastEaseInToSlowEaseOut,
          child: Container(
            color: Colors.transparent, // Set background color to transparent
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              shrinkWrap: true,
              children: [
                const Text(
                  'Custom OpenAI API Key',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _keyTextEditingController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Enter your API key',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    if (isCopying) {
                      return;
                    }
                    isCopying = true;
                    await Clipboard.setData(
                      const ClipboardData(
                        text: 'https://platform.openai.com/',
                      ),
                    );
                    EasyLoading.showToast(
                      'Copied successfully!',
                      dismissOnTap: true,
                    );
                    isCopying = false;
                  },
                  child: const Text(
                    '⦿ hypeBard does not collect this key.\n'
                    '⦿ In case our API key reports an error, custom keys need to be created at https://platform.openai.com/.\n',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        backgroundColor: Colors.grey.withOpacity(0.2),
                      ),
                      child: const Text('Cancel'),
                      onPressed: () {
                        _keyTextEditingController.clear();
                        Navigator.of(context).pop(false);
                      },
                    ),
                    const SizedBox(width: 10),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        backgroundColor: Colors.black.withOpacity(0.8),
                      ),
                      child: const Text('Confirm',
                          style: TextStyle(color: Colors.white)),
                      onPressed: () async {
                        ChatGPT.setOpenAIKey(_keyTextEditingController.text)
                            .then((_) {
                          _keyTextEditingController.clear();
                          Navigator.of(context).pop(true);
                          EasyLoading.showToast(
                            'API key integrated',
                            dismissOnTap: true,
                          );
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

 void _showCustomOpenAIUrlDialog() async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        backgroundColor: Colors.white,
        insetAnimationCurve: Curves.fastLinearToSlowEaseIn,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(30.0),
          ),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Custom OpenAI Base URL',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _urlTextEditingController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Enter your OpenAI URL',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  if (isCopying) {
                    return;
                  }
                  isCopying = true;
                  await Clipboard.setData(
                    const ClipboardData(
                      text: 'https://platform.openai.com/',
                    ),
                  );
                  EasyLoading.showToast(
                    'Copied successfully!',
                    dismissOnTap: true,
                  );
                  isCopying = false;
                },
                child: const Text(
                  '⦿ Custom URL allows you to connect to your own OpenAI instance.\n'
                  '⦿ You can set up a local or custom OpenAI deployment.\n',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      backgroundColor: Colors.grey.withOpacity(0.2),
                    ),
                    child: const Text('Cancel'),
                    onPressed: () {
                      _urlTextEditingController.clear();
                      Navigator.of(context).pop(false);
                    },
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      backgroundColor: Colors.black.withOpacity(0.8),
                    ),
                    child: const Text('Confirm',
                        style: TextStyle(color: Colors.white)),
                    onPressed: () async {
                      ChatGPT.setOpenAIBaseUrl(_urlTextEditingController.text)
                          .then((_) {
                        _urlTextEditingController.clear();
                        Navigator.of(context).pop(true);
                        EasyLoading.showToast(
                          'URL updated',
                          dismissOnTap: true,
                        );
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

  void launchURL(String url) async {
    try {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
      );
    } catch (e) {
      throw 'Could not launch $url';
    }
  }
}
