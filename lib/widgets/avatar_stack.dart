import 'package:flutter/material.dart';

class AvatarStack extends StatelessWidget {
  final int count;
  final double avatarSize;
  final double overlap;

  const AvatarStack({
    super.key,
    this.count = 3,
    this.avatarSize = 22,
    this.overlap = 8,
  });

  @override
  Widget build(BuildContext context) {
    const avatarColors = [
      Color(0xFF94A3B8),
      Color(0xFF64748B),
      Color(0xFFCBD5E1),
    ];

    final displayCount = count.clamp(1, 3);
    final totalWidth = avatarSize + (displayCount - 1) * (avatarSize - overlap);

    return SizedBox(
      width: totalWidth,
      height: avatarSize,
      child: Stack(
        children: List.generate(displayCount, (index) {
          return Positioned(
            left: index * (avatarSize - overlap),
            child: Container(
              width: avatarSize,
              height: avatarSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: avatarColors[index % avatarColors.length],
                border: Border.all(
                  color: Colors.white,
                  width: 1.5,
                ),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.person,
                size: avatarSize * 0.65,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
          );
        }),
      ),
    );
  }
}
