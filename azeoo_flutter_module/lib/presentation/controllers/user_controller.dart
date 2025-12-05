import '../../domain/models/user.dart';
import '../../domain/repositories/user_repository.dart';

class UserController {
  final UserRepository repository;

  UserController(this.repository);

  Future<User> loadUser(int id) async => repository.getUser(id);
}
