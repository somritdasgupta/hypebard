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
