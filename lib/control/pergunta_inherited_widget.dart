import 'package:flutter/material.dart';
import 'pergunta_change_notifier.dart';

class PerguntaInheritedWidget extends InheritedNotifier<PerguntaChangeNotifier> {
  const PerguntaInheritedWidget({
    super.key,
    required super.child,
    required PerguntaChangeNotifier perguntaChangeNotifier,
  }) : super(notifier: perguntaChangeNotifier);

  static PerguntaChangeNotifier of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<PerguntaInheritedWidget>()!
        .notifier!;
  }
}
