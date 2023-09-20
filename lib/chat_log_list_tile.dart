import 'package:flutter/material.dart';

class ChatLogList extends StatefulWidget {
  final List<Map<String, String>> chatLogs;

  ChatLogList(this.chatLogs);

  @override
  _ChatLogListState createState() => _ChatLogListState();
}

class _ChatLogListState extends State<ChatLogList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener); // 리스너 추가
  }

  _scrollListener() {
    // 이곳에 스크롤 관련 로직을 추가할 수 있습니다.
  }

  @override
  void didUpdateWidget(ChatLogList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.chatLogs.length != oldWidget.chatLogs.length) {
      // 새로운 채팅이 추가되면 맨 아래로 스크롤합니다.
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: widget.chatLogs.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(widget.chatLogs[index]['content'] ?? 'Fallback value'),
          leading: widget.chatLogs[index]['role'] == 'user'
              ? const Icon(Icons.person_outline)
              : null,
          trailing: widget.chatLogs[index]['role'] == 'assistant'
              ? const Icon(Icons.assistant)
              : null,
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose(); // 컨트롤러 해제
    super.dispose();
  }
}
