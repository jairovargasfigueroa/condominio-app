import 'package:flutter/material.dart';

import '../../data/models/user_model.dart';
import '../../data/repositories/user_repository_implement.dart';

class UserProvider  extends ChangeNotifier{
  final UserRepositoryImpl userRepository;

  UserProvider({required this.userRepository});

  List<UserModel> _users = [];
  bool _isLoading = false;

  List<UserModel> get users => _users;
  bool get isLoading => _isLoading;

  Future<void> loadUsers() async {
    _isLoading = true;
    notifyListeners();

    try {
      _users = await userRepository.getUsers();
      print('✅ UserProvider: ${_users.length} usuarios cargados');
    } catch (e) {
      print('❌ UserProvider Error: $e');
      // Manejo de errores
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
