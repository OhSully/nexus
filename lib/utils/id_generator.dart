/// Hands out unique, sequential IDs such as `event-1`. Deterministic, so tests
/// can rely on it; replace with backend-assigned IDs later.
class IdGenerator {
  int _next = 1;

  String next(String prefix) => '$prefix-${_next++}';
}
