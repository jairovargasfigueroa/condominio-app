import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:my_flutter_app/features/users/data/models/user_model.dart';

class UserRemoteDataSource {
  final String baseUrl = 'http://192.168.0.5:8000';

  Future<List<UserModel>> getUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/api/usuarios'));

      print(
      '📡 Status Code: ${response.statusCode}',
    ); // ← Ver código de respuesta
    print('📦 Response Body: ${response.body}'); // ← Ver JSON completo

    if (response.statusCode == 200){

      print('✅ Petición exitosa');
      final Map<String,dynamic> jsonResponse = json.decode(response.body);
      print('🔍 Estructura del JSON: ${jsonResponse.keys}');

      final List<dynamic> jsonList =
          jsonResponse['data']; // ← O la clave que uses
      return jsonList.map((json) => UserModel.fromJson(json)).toList();
      
    }else {
      print('❌ Error en petición: ${response.statusCode}');
      throw Exception('Error al cargar usuarios');
    }
  }
}
