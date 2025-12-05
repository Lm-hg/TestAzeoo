import 'dart:convert';

import '../models/user.dart';
import '../../core/api_client.dart';
import '../../core/cache.dart';

abstract class UserRepository {
  Future<User> getUser(int id);
  Future<User> refreshUser(int id);
}

class UserRepositoryImpl implements UserRepository {
  final ApiClient apiClient;
  final SimpleCache cache;

  UserRepositoryImpl(this.apiClient, this.cache);

  String _cacheKey(int id) => 'user_$id';

  @override
  Future<User> getUser(int id) async {
    final key = _cacheKey(id);
    try {
      final cached = await cache.read(key);
      if (cached != null) {
        final map = jsonDecode(cached) as Map<String, dynamic>;
        return User.fromJson(map);
      }
    } catch (_) {
    
    }

    return refreshUser(id);
  }

  @override
  Future<User> refreshUser(int id) async {
    print('=== Fetching user from API: /v1/users/$id');
    final json = await apiClient.getJson('/v1/users/$id');
    print('=== API Response: ${json.toString().substring(0, 200)}...');
    final user = User.fromJson(json);
    print('=== User parsed: ${user.fullName}, points: ${user.points}, email: ${user.email}');
    try {
      await cache.write(_cacheKey(id), jsonEncode(user.toJson()));
    } catch (_) {
      
    }
    return user;
  }
}
