import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hypebard/stores/AIChatStore.dart';
import 'package:hypebard/utils/Chatgpt.dart';
import 'package:provider/provider.dart';
import 'package:sp_util/sp_util.dart';
import 'package:url_launcher/url_launcher.dart';

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
                        Image(
                          width: 18,
                          image: AssetImage('images/back_icon.png'),
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
                      'images/key_icon.png',
                      Colors.lightGreen,
                      26,
                      'Customize OpenAI API Key',
                      () async {
                        String cacheKey = ChatGPT.getCacheOpenAIKey();
                        _keyTextEditingController.text = cacheKey;
                        _showCustomOpenAIKeyDialog();
                      },
                    ),
                    renderItemWidget(
                      'images/url_icon.png',
                      Colors.deepPurpleAccent,
                      26,
                      'Customize OpenAI Base URL',
                      () async {
                        String cacheUrl = ChatGPT.getCacheOpenAIBaseUrl();
                        _urlTextEditingController.text = cacheUrl;
                        _showCustomOpenAIUrlDialog();
                      },
                    ),
                    renderItemWidget(
                      'images/dev.png',
                      Colors.teal,
                      42,
                      'Hey, somrit here!',
                      () async {
                        final Uri url = Uri.parse(
                            'https://www.linkedin.com/in/somritdasgupta');
                        launchURL(url.toString());
                      },
                    ),
                    renderItemWidget(
                      'images/debug_icon.png',
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
    String iconPath,
    Color iconBgColor,
    double iconSize,
    String title,
    GestureTapCallback back, {
    String rightIconSrc = 'images/arrow_icon.png',
  }) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      hoverColor: Colors.yellowAccent,
      onTap: back,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(15),
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
            decoration: BoxDecoration(
              color: const Color(0xA5B7D5AF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: iconSize,
                        height: iconSize,
                        child: Image(
                          image: AssetImage(iconPath),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                if (rightIconSrc != '')
                  Row(
                    children: [
                      Image(
                        image: AssetImage(rightIconSrc),
                        width: 18,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
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
        return AlertDialog(
          scrollable: true,
          title: const Text('Custom OpenAI API Key'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _keyTextEditingController,
                autofocus: true,
                decoration:
                    const InputDecoration(hintText: 'Please input your key'),
              ),
              const SizedBox(height: 12),
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
                    'Copy successfully!',
                    dismissOnTap: true,
                  );
                  isCopying = false;
                },
                child: const SingleChildScrollView(
                  child: Wrap(
                    children: [
                      Text(
                        '* Custom key can use the APP without restrictions.',
                        textAlign: TextAlign.start,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 14,
                          height: 20 / 14,
                          color: Color.fromRGBO(220, 0, 0, 1.0),
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        '* You will get the APP version without ads.',
                        textAlign: TextAlign.start,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 14,
                          height: 20 / 14,
                          color: Color.fromRGBO(220, 0, 0, 1.0),
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        '* The AI Chat APP does not collect this key.',
                        textAlign: TextAlign.start,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 14,
                          height: 20 / 14,
                          color: Color.fromRGBO(126, 126, 126, 1.0),
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        '* The Key we provide may report an error, and custom keys need to be created at https://platform.openai.com/ .',
                        textAlign: TextAlign.start,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 14,
                          height: 20 / 14,
                          color: Color.fromRGBO(126, 126, 126, 1.0),
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        '* Click Copy URL.',
                        textAlign: TextAlign.start,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 14,
                          height: 20 / 14,
                          color: Color.fromRGBO(126, 126, 126, 1.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                _keyTextEditingController.clear();
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () async {
                ChatGPT.setOpenAIKey(_keyTextEditingController.text).then((_) {
                  _keyTextEditingController.clear();
                  Navigator.of(context).pop(true);
                  EasyLoading.showToast(
                    'Successful setting!',
                    dismissOnTap: true,
                  );
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _showCustomOpenAIUrlDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          title: const Text('Custom OpenAI Base URL'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _urlTextEditingController,
                autofocus: true,
                decoration: const InputDecoration(
                    hintText: 'Please input your OpenAI host'),
              ),
              const SizedBox(height: 12),
              const Wrap(
                children: [
                  Text(
                    "You can set openai host where access to the official OpenAI host is restricted or unavailable, "
                    "allowing you to configure an alternative host for the specific needs.\n"
                    "Use https://api.openai.com by default.",
                    textAlign: TextAlign.start,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 14,
                      height: 20 / 14,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    "This option is only applied when you provide a custom apiKey.",
                    textAlign: TextAlign.start,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 14,
                      height: 20 / 14,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                _urlTextEditingController.clear();
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () async {
                ChatGPT.setOpenAIBaseUrl(_urlTextEditingController.text)
                    .then((_) {
                  _urlTextEditingController.clear();
                  Navigator.of(context).pop(true);
                  EasyLoading.showToast(
                    'Successful setting!',
                    dismissOnTap: true,
                  );
                });
              },
            ),
          ],
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
