import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimerState {
  final int remainingSeconds;
  final int totalSeconds;
  final bool isRunning;
  final String currentPhase;
  final int currentSession; // Kaçıncı ders

  TimerState({
    required this.remainingSeconds,
    required this.totalSeconds,
    required this.isRunning,
    required this.currentPhase,
    this.currentSession = 1,
  });

  TimerState copyWith({
    int? remainingSeconds,
    int? totalSeconds,
    bool? isRunning,
    String? currentPhase,
    int? currentSession,
  }) {
    return TimerState(
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      isRunning: isRunning ?? this.isRunning,
      currentPhase: currentPhase ?? this.currentPhase,
      currentSession: currentSession ?? this.currentSession,
    );
  }
}

class TimerNotifier extends Notifier<TimerState> {
  Timer? _timer;

  @override
  TimerState build() {
    // Şimdilik varsayılan 75 dakika Ders, 15 dakika Mola döngüsü
    const int initialMinutes = 75;
    const int totalSec = initialMinutes * 60;

    return TimerState(
      remainingSeconds: totalSec,
      totalSeconds: totalSec,
      isRunning: false,
      currentPhase: "1. Ders",
      currentSession: 1,
    );
  }

  void start() {
    if (state.isRunning || state.remainingSeconds <= 0) return;

    state = state.copyWith(isRunning: true);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingSeconds > 0) {
        state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
      } else {
        // SÜRE BİTTİĞİNDE TETİKLENEN KISIM
        pause();
        _handlePhaseTransition();
      }
    });
  }

  void pause() {
    _timer?.cancel();
    state = state.copyWith(isRunning: false);
  }

  void reset(int minutes, String phase, {int? newSession}) {
    pause();
    final int sec = minutes * 60;
    state = TimerState(
      remainingSeconds: sec,
      totalSeconds: sec,
      isRunning: false,
      currentPhase: phase,
      currentSession: newSession ?? state.currentSession,
    );
  }

  // Faz Geçişlerini Yöneten Akıllı Fonksiyon
  void _handlePhaseTransition() {
    if (state.currentPhase.contains("Ders")) {
      // Ders bittiyse Teneffüse geç (15 dakika)
      // İleride bu 15 değerini kullanıcının oluşturduğu programdan çekeceğiz
      reset(15, "Teneffüs");

      // TODO: Bildirim çal (Ders bitti, mola zamanı!)
    } else {
      // Teneffüs bittiyse Sıradaki Derse geç (75 dakika)
      int nextSession = state.currentSession + 1;
      reset(75, "$nextSession. Ders", newSession: nextSession);

      // TODO: Bildirim çal (Mola bitti, derse dön!)
    }
  }
}

final timerProvider = NotifierProvider<TimerNotifier, TimerState>(() {
  return TimerNotifier();
});
