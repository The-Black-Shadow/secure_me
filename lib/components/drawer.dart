import 'package:flutter/material.dart';
import 'package:secure_me/components/list_tile.dart';

class MyDrawer extends StatelessWidget {
  final void Function()? onProfileTap;
  final void Function()? onSubscriptionTap;
  final void Function()? onSettingTap;
  final void Function()? signOut;

  const MyDrawer({
    required this.onProfileTap,
    required this.onSettingTap,
    required this.onSubscriptionTap,
    required this.signOut,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.cyan[800],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const DrawerHeader(
                child: Icon(Icons.person, size: 100, color: Colors.white),
              ),
              //home tile
              MyListTile(
                icon: Icons.home,
                title: 'H O M E',
                onTap: () => Navigator.pop(context),
              ),
              //profile tile
              MyListTile(
                icon: Icons.person,
                title: 'P R O F I L E',
                onTap: onProfileTap,
              ),
              //subscription tile
              MyListTile(
                icon: Icons.add_shopping_cart_rounded,
                title: 'S U B S C R I P T I O N',
                onTap: onSubscriptionTap,
              ),
              //settings tile
              MyListTile(
                icon: Icons.settings,
                title: 'S E T T I N G S',
                onTap: onSettingTap,
              ),
            ],
          ),
          //sign out
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: MyListTile(
              icon: Icons.logout,
              title: 'L O G  O U T',
              onTap: signOut,
            ),
          ),
        ],
      ),
    );
  }
}
