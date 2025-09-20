import '../data_sources/user_remote_data_source.dart';
import '../models/user_model.dart';

class UserRepositoryImpl {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  Future<List<UserModel>> getUsers() async {
    
    return await remoteDataSource.getUsers();
  }
}
