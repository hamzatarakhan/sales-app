import 'package:flutter/material.dart';
import 'app_state.dart';

/// Exposes a single [AppState] down the tree; widgets that read it via
/// [AppStateScope.of] rebuild automatically on [AppState.notifyListeners].
class AppStateScope extends InheritedNotifier<AppState> {
  const AppStateScope({super.key, required AppState state, required super.child})
      : super(notifier: state);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppStateScope>();
    assert(scope != null, 'No AppStateScope found in context');
    return scope!.notifier!;
  }
}
