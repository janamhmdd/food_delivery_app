import 'package:flutter/material.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';

enum ChatSender { user, bot }

class ChatMessage {
  final ChatSender sender;
  final String text;
  final String timeLabel;
  final List<String>? actions;
  const ChatMessage({required this.sender, required this.text, required this.timeLabel, this.actions});
}

String _formatTime(DateTime dt) {
  final hour = dt.hour.toString().padLeft(2, '0');
  final minute = dt.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

class SupportChatScreen extends StatefulWidget {
  const SupportChatScreen({super.key});

  @override
  State<SupportChatScreen> createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends State<SupportChatScreen> {
  final List<ChatMessage> _messages = [
    const ChatMessage(sender: ChatSender.user, text: 'Hello!', timeLabel: '09:00'),
    const ChatMessage(
      sender: ChatSender.bot,
      text: 'Hello!, please choose the number corresponding to your needs for a more efficient service.',
      timeLabel: '09:00',
    ),
    const ChatMessage(
      sender: ChatSender.bot,
      text: '1. Order Management\n2. Payments Management\n3. Account management and profile\n'
          '4. About order tracking\n5. Safety',
      timeLabel: '09:00',
    ),
    const ChatMessage(sender: ChatSender.user, text: '1', timeLabel: '09:03'),
    const ChatMessage(
      sender: ChatSender.bot,
      text: 'You have a current order\nStrawberry Shake and Broccoli Lasagna\nOrder No. 0054752\n29 Nov, 01:20 pm',
      timeLabel: '09:03',
      actions: ['Order Issues', 'Order not received'],
    ),
  ];

  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  String _botReplyFor(String input) {
    switch (input.trim()) {
      case '1':
        return 'Order Management: you can view, track, or cancel your orders from the Orders tab.';
      case '2':
        return 'Payments Management: this is a demo app, so no real payments are processed.';
      case '3':
        return 'Account management: update your profile from the account screen.';
      case '4':
        return 'Order tracking: open an active order and tap Track Driver to see live tracking.';
      case '5':
        return "Safety: we take your safety seriously — reach out any time if something feels wrong.";
      default:
        return "Thanks for your message! This is a simulated support chat for the demo — "
            "there's no live agent behind it yet.";
    }
  }

  void _send(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add(ChatMessage(sender: ChatSender.user, text: text.trim(), timeLabel: _formatTime(DateTime.now())));
      _controller.clear();
    });
    _scrollToBottom();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() {
        _messages.add(ChatMessage(sender: ChatSender.bot, text: _botReplyFor(text), timeLabel: _formatTime(DateTime.now())));
      });
      _scrollToBottom();
    });
  }

  void _sendAction(String action) {
    setState(() {
      _messages.add(ChatMessage(sender: ChatSender.user, text: action, timeLabel: _formatTime(DateTime.now())));
    });
    _scrollToBottom();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() {
        _messages.add(ChatMessage(
          sender: ChatSender.bot,
          text: action == 'Order Issues'
              ? "We're sorry to hear that. Please describe the issue and our team will follow up."
              : "We're sorry your order hasn't arrived. Check the Orders tab for live tracking, "
                  "or use Contact Us for more help.",
          timeLabel: _formatTime(DateTime.now()),
        ));
      });
      _scrollToBottom();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.headerYellow,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 20, 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
                  ),
                  Expanded(
                    child: Text('Support', textAlign: TextAlign.center, style: AppTextStyles.headerTitle),
                  ),
                  const SizedBox(width: 28),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                ),
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) => _ChatBubble(message: _messages[index], onAction: _sendAction),
                ),
              ),
            ),
            SafeArea(
              top: false,
              child: Container(
                color: AppColors.background,
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Attachments aren't supported in this demo.")),
                      ),
                      icon: const Icon(Icons.attach_file, color: AppColors.textSecondary),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        onSubmitted: _send,
                        decoration: InputDecoration(
                          hintText: 'Write Here...',
                          filled: true,
                          fillColor: AppColors.fieldFill,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Voice messages aren't supported in this demo.")),
                      ),
                      icon: const Icon(Icons.mic_none, color: AppColors.textSecondary),
                    ),
                    IconButton(
                      onPressed: () => _send(_controller.text),
                      icon: const Icon(Icons.send, color: AppColors.primary),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final ValueChanged<String> onAction;
  const _ChatBubble({required this.message, required this.onAction});

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == ChatSender.user;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72),
            decoration: BoxDecoration(
              color: isUser ? const Color(0xFFFFE9B0) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: isUser ? null : Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message.text, style: AppTextStyles.body.copyWith(fontSize: 13)),
                if (message.actions != null) ...[
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: message.actions!
                        .map((action) => GestureDetector(
                              onTap: () => onAction(action),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.peachCircle,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  action,
                                  style: AppTextStyles.body.copyWith(
                                    color: AppColors.primary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(message.timeLabel, style: AppTextStyles.body.copyWith(color: AppColors.textSecondary, fontSize: 10)),
          ),
        ],
      ),
    );
  }
}