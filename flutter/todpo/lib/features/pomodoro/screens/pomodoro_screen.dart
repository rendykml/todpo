import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/task_model.dart';
import '../../../utils/token_storage.dart';
import '../../../services/session_services.dart';
import '../../task/task_controller.dart';

enum PomodoroMode { focus, shortBreak, longBreak }

class PomodoroScreen extends StatefulWidget {
  final Task task;

  const PomodoroScreen({super.key, required this.task});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

const bool isTestMode = true; // testing

class _PomodoroScreenState extends State<PomodoroScreen> {
  static const int focusDuration = isTestMode ? 5 : 25 * 60;
  static const int shortBreakDuration = isTestMode ? 3 : 5 * 60;
  static const int longBreakDuration = isTestMode ? 5 : 15 * 60;

  late int _remainingSeconds;
  late PomodoroMode _mode;
  Timer? _timer;

  bool _isRunning = false;
  int _currentCycle = 0;

  @override
  void initState() {
    super.initState();
    _mode = PomodoroMode.focus;
    _remainingSeconds = focusDuration;
    _currentCycle = widget.task.completedCycle;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (_isRunning) return;

    setState(() => _isRunning = true);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        timer.cancel();
        _onTimerComplete();
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _skipSession() {
    _timer?.cancel();

    if (_mode == PomodoroMode.focus) {
      if (_currentCycle % 4 == 0 && _currentCycle != 0) {
        _setMode(PomodoroMode.longBreak);
      } else {
        _setMode(PomodoroMode.shortBreak);
      }
    } else {
      _setMode(PomodoroMode.focus);
    }
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _setMode(PomodoroMode.focus);
    });
  }

  Future<void> _onTimerComplete() async {
    final token = await TokenStorage.getToken();
    if (token == null) return;

    if (_mode == PomodoroMode.focus) {
      _currentCycle++;

      // kirim session focus
      await SessionService.createSession(
        token: token,
        taskId: widget.task.id,
        cycleNumber: _currentCycle,
        type: "focus",
        duration: 25,
        status: "selesai",
      );

      // REFRESH TASK LIST
      if (mounted) {
        await context.read<TaskController>().loadTasks(token);
      }

      if (_currentCycle % 4 == 0) {
        _setMode(PomodoroMode.longBreak);
      } else {
        _setMode(PomodoroMode.shortBreak);
      }
    } else {
      // kirim break session
      await SessionService.createSession(
        token: token,
        taskId: widget.task.id,
        cycleNumber: _currentCycle,
        type: _mode == PomodoroMode.shortBreak ? "short_break" : "long_break",
        duration: _mode == PomodoroMode.shortBreak ? 5 : 15,
        status: "selesai",
      );
      if (_currentCycle >= widget.task.targetCycle) {
        if (!mounted) return;
        Navigator.pop(context);
      }

      _setMode(PomodoroMode.focus);
    }
  }

  void _setMode(PomodoroMode mode) {
    setState(() {
      _mode = mode;
      _isRunning = false;
      _remainingSeconds = switch (mode) {
        PomodoroMode.focus => focusDuration,
        PomodoroMode.shortBreak => shortBreakDuration,
        PomodoroMode.longBreak => longBreakDuration,
      };
    });
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  String get _modeText {
    switch (_mode) {
      case PomodoroMode.focus:
        return "Fokus";
      case PomodoroMode.shortBreak:
        return "Istirahat Pendek";
      case PomodoroMode.longBreak:
        return "Istirahat Panjang";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pomodoro")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.task.title,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              _modeText,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 40),

            // TIMER
            Text(
              _formatTime(_remainingSeconds),
              style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            // CYCLE
            Text(
              "Cycle: $_currentCycle / ${widget.task.targetCycle}",
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 40),

            // BUTTONS
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 40,
                  icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                  onPressed: _isRunning ? _pauseTimer : _startTimer,
                ),
                const SizedBox(width: 24),
                IconButton(
                  iconSize: 40,
                  icon: const Icon(Icons.stop),
                  onPressed: _resetTimer,
                ),
                const SizedBox(width: 24),
                IconButton(
                  iconSize: 40,
                  icon: const Icon(Icons.skip_next),
                  onPressed: _skipSession,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
