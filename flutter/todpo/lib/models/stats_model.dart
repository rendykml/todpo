class FocusStats {
  final int daily;
  final int weekly;
  final int monthly;
  final double average;

  FocusStats({
    required this.daily,
    required this.weekly,
    required this.monthly,
    required this.average,
  });

  factory FocusStats.fromJson(Map<String, dynamic> json) {
    return FocusStats(
      daily: json['daily'],
      weekly: json['weekly'],
      monthly: json['monthly'],
      average: (json['average'] as num).toDouble(),
    );
  }
}
