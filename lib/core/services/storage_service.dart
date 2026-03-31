abstract class StorageService {
  Future<void> init();
  Future<void> write(String key, dynamic value);
  Future<T?> read<T>(String key);
  Future<void> delete(String key);
}

class InMemoryStorage implements StorageService {
  final Map<String, dynamic> _store = {};

  @override
  Future<void> delete(String key) async {
    _store.remove(key);
  }

  @override
  Future<void> init() async {}

  @override
  Future<T?> read<T>(String key) async => _store[key] as T?;

  @override
  Future<void> write(String key, dynamic value) async {
    _store[key] = value;
  }
}
