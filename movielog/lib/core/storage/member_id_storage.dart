import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MemberIdStorage {
  const MemberIdStorage(this._storage);

  final FlutterSecureStorage _storage;

  String _key(String email) => 'movielog.member_id.${email.trim()}';

  Future<void> save(String email, int memberId) {
    return _storage.write(key: _key(email), value: memberId.toString());
  }

  Future<int?> read(String email) async {
    final value = await _storage.read(key: _key(email));
    final id = int.tryParse(value ?? '');
    return id != null && id > 0 ? id : null;
  }
}
