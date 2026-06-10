/// Decouples repositories from the sync engine: the engine registers itself
/// at startup; repositories ping it after every local mutation so changes
/// sync promptly (debounced engine-side) without repositories importing it.
class SyncTriggers {
  static void Function()? onLocalMutation;

  static void mutated() => onLocalMutation?.call();
}
