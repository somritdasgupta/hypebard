import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hypebard/page/ChatPage.dart';
import 'package:hypebard/stores/AIChatStore.dart';
import 'package:hypebard/utils/Time.dart';
import 'package:hypebard/utils/Utils.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

class ChatHistoryPage extends StatefulWidget {
  const ChatHistoryPage({Key? key}) : super(key: key);

  @override
  _ChatHistoryPageState createState() => _ChatHistoryPageState();
}

class _ChatHistoryPageState extends State<ChatHistoryPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AIChatStore>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        toolbarHeight: 60,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
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
                      "Your Rewinds",
                      style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 1),
                        fontSize: 26,
                        height: 0,
                        fontWeight: FontWeight.w500,
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
        actions: const [
          SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _renderChatListWidget(
                store.sortChatList,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _genChatItemWidget(Map chat) {
    return Dismissible(
      key: Key(chat['id']),
      background: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Colors.red.withOpacity(0.8), Colors.red.withOpacity(0.2)],
          ),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: const EdgeInsets.only(right: 16.0),
        alignment: Alignment.centerRight,
        child: const Icon(
          Icons.delete_outline_rounded,
          color: Colors.pinkAccent,
          size: 30,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Vibration.vibrate(duration: 50);
        final store = Provider.of<AIChatStore>(context, listen: false);
        store.deleteChatById(chat['id']);
      },
      child: Card(
        color: Colors.black38,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
        child: InkWell(
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  TimeUtils().formatTime(
                    chat['updatedTime'],
                    format: 'dd/MM/yyyy ➜ HH:mm',
                  ),
                  style: const TextStyle(
                    color: Colors.tealAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  chat['messages'][0]['content'],
                  style: const TextStyle(
                    color: Colors.tealAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.playlist_remove_rounded,
                        size: 30,
                      ),
                      color: Colors.tealAccent,
                      onPressed: () {
                        Vibration.vibrate(duration: 50);
                        _showDeleteConfirmationDialog(context, chat['id']);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _renderChatListWidget(List chatList) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      itemCount: chatList.length,
      itemBuilder: (BuildContext context, int index) {
        final chat = chatList[index];
        return _genChatItemWidget(chat);
      },
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          backgroundColor: Colors.white,
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
