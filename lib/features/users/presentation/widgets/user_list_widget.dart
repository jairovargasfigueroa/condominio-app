// users_list_widget.dart
import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';

class UserListWidget extends StatelessWidget {
  final List<UserModel> users;
  final bool isLoading;
  final VoidCallback onGetUsers; // ← Función para obtener usuarios

  const UserListWidget({
    Key? key,
    required this.users,
    required this.isLoading,
    required this.onGetUsers, // ← Requerido
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Botón para obtener usuarios
        Padding(
          padding: EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed:
                isLoading ? null : onGetUsers, // ← Aquí se hace la petición
            child: isLoading ? Text('Cargando...') : Text('Obtener Usuarios'),
          ),
        ),

        // Lista de usuarios
        Expanded(
          child:
              users.isEmpty && !isLoading
                  ? Center(
                    child: Text('Presiona el botón para cargar usuarios'),
                  )
                  : isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return Card(
                        margin: EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(user.id.toString()),
                          ),
                          title: Text(user.username),
                          subtitle: Text('ID: ${user.id}'),
                        ),
                      );
                    },
                  ),
        ),
      ],
    );
  }
}
