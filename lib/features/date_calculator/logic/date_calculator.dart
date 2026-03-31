class DateDiffResult {
  final int days;
  final int weeks;
  final int remainingDays;

  const DateDiffResult({
    required this.days,
    required this.weeks,
    required this.remainingDays,
  });
}

class DateCalculator {
  const DateCalculator();

  DateDiffResult diff(DateTime a, DateTime b) {
    final start = DateTime(a.year, a.month, a.day);
    final end = DateTime(b.year, b.month, b.day);
    final days = end.difference(start).inDays.abs();
    return DateDiffResult(
      days: days,
      weeks: days ~/ 7,
      remainingDays: days % 7,
    );
  }
}
