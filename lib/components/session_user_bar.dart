import 'package:flutter/material.dart';
import 'package:smart_menu_app/models/session_user.dart';

class UserBar extends StatefulWidget {
  final SessionUser sessionUser;
  const UserBar({super.key, required this.sessionUser});

  @override
  State<UserBar> createState() => _UserBarState();
}

class _UserBarState extends State<UserBar> {
  @override
  Widget build(BuildContext context) {
    Color color = Colors.blue[200]!;

    if (widget.sessionUser.statusId == 0) {
      color = Colors.green[200]!;
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color,
      ),
      padding: const EdgeInsets.only(right: 8, left: 3, top: 3, bottom: 3),
      margin: const EdgeInsets.all(4),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: CircleAvatar(
              backgroundImage: AssetImage(
                  "images/avatar_${widget.sessionUser.user!.imageId}.png"),
              backgroundColor: Colors.red,
            ),
          ),
          Text(
            widget.sessionUser.user!.name,
            style: const TextStyle(
                fontFamily: 'Sofia', fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
