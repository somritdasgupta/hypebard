import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hypebard/components/QuestionInput.dart';
import 'package:hypebard/page/ChatHistoryPage.dart';
import 'package:hypebard/page/ChatPage.dart';
import 'package:hypebard/page/SettingPage.dart';
import 'package:hypebard/stores/AIChatStore.dart';
import 'package:hypebard/utils/Chatgpt.dart';
import 'package:hypebard/utils/Config.dart';
import 'package:hypebard/utils/Time.dart';
import 'package:hypebard/utils/Utils.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

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
        toolbarHeight: 70,
        automaticallyImplyLeading: true,
        titleSpacing: 0,
        title: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const SizedBox(width: 24),
            ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              clipBehavior: Clip.antiAlias,
              child: const Image(
                width: 36,
                height: 36,
                image: AssetImage('images/logo.png'),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              Config.appName,
              style: const TextStyle(
                color: Color.fromRGBO(54, 54, 54, 1.0),
                fontSize: 26,
                height: 0,
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFFF6F1F1),
        elevation: 0,
        actions: [
          const SizedBox(width: 6),
          IconButton(
            icon: const Icon(Icons.security_rounded),
            iconSize: 40,
            color: const Color.fromRGBO(98, 98, 98, 1.0),
            onPressed: () {
              // ChatGPT.genImage('Robot avatar, cute');
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
                        'Your Rewinds.',
                        rightContent: SizedBox(
                          width: 45,
                          child: GestureDetector(
                            onTap: () {
                              Utils.jumpPage(context, const ChatHistoryPage());
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text(
                                  'All',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 16,
                                    height: 18 / 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 8, 0),
                                  height: 16,
                                  child: const Image(
                                    image: AssetImage('images/arrow_icon.png'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    if (store.homeHistoryList.length > 0)
                      _renderChatListWidget(
                        store.homeHistoryList,
                      ),
                    _renderTitle('Welcome to hypeBard.'),
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
  }) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.fromLTRB(0, 20, 0, 8),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            text,
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: Color.fromRGBO(1, 2, 6, 1),
              fontSize: 22,
              height: 1,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (rightContent != null) rightContent,
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
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (chat['updatedTime'] != null)
                      Text(
                        TimeUtils().formatTime(
                          chat['updatedTime'],
                          format: 'dd/MM/yyyy -> HH:mm',
                        ),
                        softWrap: true,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 24 / 16,
                        ),
                      ),
                    const SizedBox(height: 8),
                    Text(
                      chat['messages'][0]['content'],
                      softWrap: true,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        height: 24 / 16,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.remove_circle_outline_rounded,
                  size: 30,
                ),
                color: const Color.fromARGB(255, 145, 145, 145),
                onPressed: () {
                  _showDeleteConfirmationDialog(context, chat['id']);
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(
            height: 2,
            color: Color.fromRGBO(166, 166, 166, 1.0),
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(
    BuildContext context,
    String chatId,
  ) async {
    final store = Provider.of<AIChatStore>(context, listen: false);
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm deletion?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () async {
                await store.deleteChatById(chatId);
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }
}
