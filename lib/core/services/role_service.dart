import 'package:get_storage/get_storage.dart';

class RoleService {
  static final _box = GetStorage();

  static String get role => _box.read('role') ?? 'user';

  static bool get isAdmin => role == 'admin';
  static bool get isUser => role == 'user';
}