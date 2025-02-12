import '../../domain/entities/user.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  // Dummy data for demonstration
  final _dummyUsers = <String, User>{};

  Future<String> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Dummy validation
    if (email == "test@test.com" && password == "password123") {
      return "dummy_token_${DateTime.now().millisecondsSinceEpoch}";
    }
    throw Exception('Invalid credentials');
  }

  Future<void> signup(User user, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    _dummyUsers[user.email] = user;
  }
  Future<void> sendPasswordResetEmail(String email) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // In a real implementation, this would send an actual email
    if (!email.contains('@')) {
      throw Exception('Invalid email address');
    }
  }
}
