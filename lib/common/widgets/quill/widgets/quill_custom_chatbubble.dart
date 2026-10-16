import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:cached_network_image/cached_network_image.dart';

/// 对话气泡渲染组件
class QuillCustomChatBubble extends quill.EmbedBuilder {
  @override
  String get key => 'chatbubble';

  @override
  bool get expanded => false;

  @override
  Widget build(BuildContext context, quill.EmbedContext embedContext) {
    final data = jsonDecode(embedContext.node.value.data);
    final name = data['name'] ?? '';
    final message = data['message'] ?? '';
    final avatar = data['avatar'] ?? '';
    final isRight = data['isRight'] ?? false;

    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment:
            isRight ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isRight) _buildAvatar(avatar, name, primaryColor),
          if (!isRight) const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (name.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(
                      left: isRight ? 0 : 12,
                      right: isRight ? 12 : 0,
                      bottom: 4,
                    ),
                    child: Text(
                      name,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isRight ? primaryColor : Colors.grey.shade200,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isRight ? 18 : 4),
                      bottomRight: Radius.circular(isRight ? 4 : 18),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    message,
                    style: TextStyle(
                      color: isRight ? Colors.white : Colors.black87,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isRight) const SizedBox(width: 8),
          if (isRight) _buildAvatar(avatar, name, primaryColor),
        ],
      ),
    );
  }

  Widget _buildAvatar(String avatarUrl, String name, Color primaryColor) {
    if (avatarUrl.isNotEmpty) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: avatarUrl,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
          errorWidget: (_, __, ___) => _defaultAvatar(name, primaryColor),
        ),
      );
    }
    return _defaultAvatar(name, primaryColor);
  }

  Widget _defaultAvatar(String name, Color primaryColor) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primaryColor, primaryColor.withOpacity(0.7)],
        ),
      ),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
