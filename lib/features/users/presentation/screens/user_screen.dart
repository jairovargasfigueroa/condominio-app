// user_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../widgets/user_list_widget.dart';

class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Usuarios'), backgroundColor: Colors.blue),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return UserListWidget(
            users: userProvider.users,
            isLoading: userProvider.isLoading,
            onGetUsers: () => userProvider.loadUsers(),
          );
        },
      ),
    );
  }
}
