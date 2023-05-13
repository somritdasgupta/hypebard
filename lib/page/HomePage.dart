import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hypebard/components/QuestionInput.dart';
import 'package:hypebard/page/ChatHistoryPage.dart';
import 'package:hypebard/page/ChatPage.dart';
import 'package:hypebard/page/SettingPage.dart';
import 'package:hypebard/stores/AIChatStore.dart';
import 'package:hypebard/utils/Chatgpt.dart';
import 'package:hypebard/utils/Time.dart';
import 'package:hypebard/utils/Utils.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:vibration/vibration.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController questionController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Widget _renderBottomInputWidget() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        handleClickInput();
      },
      child: const QuestionInput(
        chat: {},
        autofocus: false,
        enabled: false,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _handleClickModel(Map chatModel) {
    final store = Provider.of<AIChatStore>(context, listen: false);
    store.fixChatList();
    Utils.jumpPage(
      context,
      ChatPage(
        chatId: const Uuid().v4(),
        autofocus: true,
        chatType: chatModel['type'],
      ),
    );
  }

  void handleClickInput() async {
    final store = Provider.of<AIChatStore>(context, listen: false);
    store.fixChatList();
    Utils.jumpPage(
      context,
      ChatPage(
        chatType: 'chat',
        autofocus: true,
        chatId: const Uuid().v4(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AIChatStore>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        forceMaterialTransparency: true,
        toolbarHeight: 70,
        automaticallyImplyLeading: true,
        titleSpacing: 0,
        title: Stack(
          alignment: Alignment.centerLeft,
          children: [
            PhysicalModel(
              color: Colors.transparent,
              elevation: 0,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
              shadowColor: Colors.black.withOpacity(0.2),
              child: const ClipRRect(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25.0),
                  bottomRight: Radius.circular(25.0),
                ),

                child: Image(
                  width: 180,
                  height: 45,
                  colorBlendMode: BlendMode.clear,
                  filterQuality: FilterQuality.high,
                  isAntiAlias: true,
                  alignment: Alignment.centerLeft,
                  image: AssetImage('images/hypeBard.png'),
                ),
              ),
            ),
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0),
              ),
              child: Container(
                width: 180,
                height: 45,
                color: Colors.transparent,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFF6F1F1),
        elevation: 0,
        actions: [
          const SizedBox(width: 6),
          IconButton(
            icon: const Icon(Icons.security_rounded),
            splashColor: Colors.black54,
            iconSize: 40,
            color: const Color.fromRGBO(37, 34, 34, 1.0),
            onPressed: () {
              Vibration.vibrate(duration: 50);
              Utils.jumpPage(context, const SettingPage());
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (store.homeHistoryList.length > 0)
                      _renderTitle(
                        'Your Rewinds',
                        animateText: false,
                        rightContent: Flexible(
                          child: SizedBox(
                            width: double.maxFinite,
                            child: GestureDetector(
                              onTap: () {
                                Vibration.vibrate(duration: 50);
                                Utils.jumpPage(
                                    context, const ChatHistoryPage());
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(
                                          0.1), // Customize the shadow color here
                                      blurRadius: 10,
                                      offset: const Offset(0, 0),
                                    ),
                                  ],
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Color(
                                          0xFF46144B), // Customize the gradient start color here
                                      Color(
                                          0xFFF6F1F1), // Customize the gradient end color here
                                    ],
                                  ),
                                ),
                                child: const Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'More',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 18,
                                        height: 18 / 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors
                                            .white, // Customize the text color here
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (store.homeHistoryList.length > 0)
                      _renderChatListWidget(
                        store.homeHistoryList,
                      ),
                    _renderTitle("Hey, I am"),
                    _renderChatModelListWidget(),
                  ],
                ),
              ),
            ),
            _renderBottomInputWidget(),
          ],
        ),
      ),
    );
  }

  Widget _renderTitle(
    String text, {
    Widget? rightContent,
    TextStyle? textStyle,
    bool animateText = true,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const SizedBox(width: 20.0, height: 30),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    text,
                    style: textStyle ??
                        const TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                if (animateText)
                  Flexible(
                    flex: 1,
                    child: FractionallySizedBox(
                      alignment: Alignment.topRight,
                      widthFactor: 1.25,
                      child: SizedBox(
                        height: 40.0,
                        child: DefaultTextStyle(
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 24.0,
                            fontFamily: 'Poppins',
                          ),
                          child: AnimatedTextKit(
                            repeatForever: true,
                            animatedTexts: [
                              RotateAnimatedText('Awesome.'),
                              RotateAnimatedText('Incredible.'),
                              RotateAnimatedText('hypeBard.'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          rightContent ?? Container(),
        ],
      ),
    );
  }

  Widget _renderChatModelListWidget() {
    List<Widget> list = [];
    for (var i = 0; i < ChatGPT.chatModelList.length; i++) {
      list.add(
        _genChatModelItemWidget(ChatGPT.chatModelList[i]),
      );
    }
    list.add(
      const SizedBox(height: 10),
    );
    return Column(
      children: list,
    );
  }

  Widget _genChatModelItemWidget(Map chatModel) {
    return InkWell(
      highlightColor: Colors.white,
      splashColor: Colors.white,
      onTap: () {
        _handleClickModel(chatModel);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: const Color(0xA5B7D5AF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            chatModel['name'],
                            softWrap: true,
                            style: const TextStyle(
                              color: Color.fromRGBO(1, 2, 6, 1),
                              fontSize: 16,
                              height: 24 / 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            chatModel['desc'],
                            softWrap: true,
                            style: const TextStyle(
                              color: Color.fromRGBO(70, 54, 77, 1.0),
                              fontSize: 16,
                              height: 22 / 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 0,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                      child: const Image(
                        image: AssetImage('images/arrow_icon.png'),
                        width: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _renderChatListWidget(List chatList) {
    List<Widget> list = [];
    for (var i = 0; i < chatList.length; i++) {
      list.add(
        _genChatItemWidget(chatList[i]),
      );
    }
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        children: [
          ...list,
        ],
      ),
    );
  }

  Widget _genChatItemWidget(Map chat) {
    return InkWell(
      highlightColor: Colors.white,
      splashColor: Colors.white,
      onTap: () {
        final store = Provider.of<AIChatStore>(context, listen: false);
        store.fixChatList();
        Utils.jumpPage(
          context,
          ChatPage(
            chatId: chat['id'],
            autofocus: false,
            chatType: chat['ai']['type'],
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: const Color(0xA5D5AFAF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (chat['updatedTime'] != null)
                            Text(
                              TimeUtils().formatTime(
                                chat['updatedTime'],
                                format: 'dd/MM/yyyy ➜ HH:mm',
                              ),
                              softWrap: false,
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                height: 24 / 16,
                              ),
                            ),
                          const SizedBox(height: 8),
                          Text(
                            chat['messages'][0]['content'],
                            softWrap: true,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              height: 24 / 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.playlist_remove_rounded,
                      size: 30,
                    ),
                    color: Colors.blueGrey,
                    onPressed: () {
                      Vibration.vibrate(duration: 50);
                      _showDeleteConfirmationDialog(context, chat['id']);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, String chatId) async {
    final store = Provider.of<AIChatStore>(context, listen: false);
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 90,
          shadowColor: Colors.black,
          surfaceTintColor: Colors.lime[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          backgroundColor:
              Colors.white.withOpacity(0.8), // Adjust the opacity here
          child: Container(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Confirm deletion?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    CupertinoButton(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12.0),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 24.0,
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                    CupertinoButton(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12.0),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 24.0,
                      ),
                      child: const Text(
                        'Confirm',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () async {
                        await store.deleteChatById(chatId);
                        Navigator.of(context).pop(true);
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
}
