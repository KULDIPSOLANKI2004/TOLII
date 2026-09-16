import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';

class ChatMessageModel {
  final String id;
  final String sender;
  final String text;
  final String time;
  final bool isMe;

  const ChatMessageModel({
    required this.id,
    required this.sender,
    required this.text,
    required this.time,
    required this.isMe,
  });
}

class CommunityChatScreen extends StatefulWidget {
  final String title;
  final String membersCount;
  final String avatarInitials;

  const CommunityChatScreen({
    super.key,
    this.title = 'Football Match',
    this.membersCount = '8 members',
    this.avatarInitials = 'FT',
  });

  @override
  State<CommunityChatScreen> createState() => _CommunityChatScreenState();
}

class _CommunityChatScreenState extends State<CommunityChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late List<ChatMessageModel> _messages;

  @override
  void initState() {
    super.initState();
    _messages = [
      const ChatMessageModel(
        id: 'msg_1',
        sender: 'Meet Patel',
        text: "Hey guys! Let's ensure everyone brings their own jersey colors. We need white and blue.",
        time: '5:12 PM',
        isMe: false,
      ),
      const ChatMessageModel(
        id: 'msg_2',
        sender: 'Rohan Shah',
        text: 'I am bringing 2 balls just in case. See you guys at 6!',
        time: '5:14 PM',
        isMe: false,
      ),
      const ChatMessageModel(
        id: 'msg_3',
        sender: 'You',
        text: 'Perfect, thanks Rohan. I will be there by 5:45 PM to warm up.',
        time: '5:16 PM',
        isMe: true,
      ),
    ];
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    HapticFeedback.lightImpact();
    final now = TimeOfDay.now();
    final hour = now.hourOfPeriod == 0 ? 12 : now.hourOfPeriod;
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.period == DayPeriod.am ? 'AM' : 'PM';
    final timeStr = '$hour:$minute $period';

    setState(() {
      _messages.add(
        ChatMessageModel(
          id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
          sender: 'You',
          text: text,
          time: timeStr,
          isMe: true,
        ),
      );
    });

    _messageController.clear();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // 1. Top Bar (Deep Blue #063E9E)
            Container(
              color: AppColors.primary,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Row(
                    children: [
                      // Back Button
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 36,
                          height: 36,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),

                      // Avatar Initials
                      Container(
                        width: 38,
                        height: 38,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          widget.avatarInitials,
                          style: AppTypography.titleMedium.copyWith(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Title & Subtitle
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: AppTypography.titleMedium.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 1),
                            Text(
                              widget.membersCount,
                              style: AppTypography.caption.copyWith(
                                fontSize: 12,
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Share Button
                      GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Chat link copied!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Container(
                          width: 36,
                          height: 36,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.share_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),

                      // 3-dots Menu
                      GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Group details & settings'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                        child: Container(
                          width: 36,
                          height: 36,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.more_vert_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 2. Chat Messages List
            Expanded(
              child: ListView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                children: [
                  // Date Chip: "TODAY"
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'TODAY',
                        style: AppTypography.caption.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // System Event Notice
                  Center(
                    child: Text(
                      'Vatsal Parmar joined the activity',
                      style: AppTypography.caption.copyWith(
                        fontSize: 12,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Messages
                  ..._messages.map((msg) => _buildMessageBubble(msg)),
                ],
              ),
            ),

            // 3. Bottom Input Bar
            Container(
              padding: EdgeInsets.fromLTRB(
                14,
                8,
                14,
                MediaQuery.of(context).padding.bottom + 8,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Color(0xFFE2E8F0)),
                ),
              ),
              child: Row(
                children: [
                  // Plus Attachment Button
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Attachment options coming soon!'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: const Icon(
                        Icons.add_rounded,
                        color: Color(0xFF64748B),
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Input Box with Emoji
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              style: AppTypography.bodySubtitle.copyWith(
                                fontSize: 14,
                                color: const Color(0xFF0F172A),
                              ),
                              decoration: InputDecoration(
                                hintText: 'Type something...',
                                hintStyle: AppTypography.caption.copyWith(
                                  fontSize: 14,
                                  color: const Color(0xFF94A3B8),
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              onSubmitted: (_) => _sendMessage(),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: const Icon(
                              Icons.sentiment_satisfied_alt_rounded,
                              size: 20,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Send Button (Solid Deep Blue Circle)
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 19,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessageModel msg) {
    final isMe = msg.isMe;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Sender Name
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              msg.sender,
              style: AppTypography.caption.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isMe ? AppColors.primary : const Color(0xFF475569),
              ),
            ),
          ),

          // Bubble Container
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.76,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isMe ? AppColors.primary : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isMe ? 16 : 4),
                bottomRight: Radius.circular(isMe ? 4 : 16),
              ),
              border: isMe ? null : Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              msg.text,
              style: AppTypography.bodySubtitle.copyWith(
                fontSize: 14,
                height: 1.4,
                color: isMe ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
          ),
          const SizedBox(height: 4),

          // Timestamp
          Text(
            msg.time,
            style: AppTypography.caption.copyWith(
              fontSize: 11,
              color: const Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }
}
