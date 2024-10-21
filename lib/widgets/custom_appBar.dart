import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isLoggedIn;
  final String? userImageUrl;

  const CustomAppBar({
    Key? key,
    required this.title,
    required this.isLoggedIn,
    this.userImageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.blue[800],
      actions: isLoggedIn
          ? [
        Builder(
          builder: (BuildContext context) {
            return IconButton(
              onPressed: () {
                // Open the endDrawer using Scaffold.of(context)
                Scaffold.of(context).openEndDrawer();
              },
              icon: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 20,
                backgroundImage: userImageUrl != null
                    ? AssetImage(userImageUrl!)
                    : const AssetImage('assets/default_user.png'),
              ),
            );
          },
        )
      ]
          : [],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
