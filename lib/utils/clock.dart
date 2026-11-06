/// Source of the current time. Inject a fixed one in tests so results don't
/// depend on when they run.
typedef Clock = DateTime Function();

DateTime systemClock() => DateTime.now();
