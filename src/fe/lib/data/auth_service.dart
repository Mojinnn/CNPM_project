import 'package:first_flutter/models/user_model.dart';

class AuthService {
  static UserModel? currentUser;

  /// Login trả về UserModel thay vì bool
  static Future<UserModel?> login(String email, String password) async {
    // TODO: Login vào DB hoặc Firebase
    // Ví dụ hardcode:

    if (email == "admin@system.com" && password == "123456") {
      currentUser = UserModel(uid: "000", email: email, role: "admin");
      return currentUser;
    }

    // Nếu là Viewer đăng ký từ DB
    if (email.endsWith("@viewer.com")) {
      currentUser = UserModel(uid: "111", email: email, role: "viewer");
      return currentUser;
    }

    // Police cần mã đặc biệt
    if (email.endsWith("@police.com")) {
      currentUser = UserModel(uid: "222", email: email, role: "police");
      return currentUser;
    }

    return null; // login failed
  }
}
