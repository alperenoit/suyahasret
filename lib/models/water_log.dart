class WaterLog {
  final String date; // YYYY-MM-DD
  final int consumedAmountMl; // İçilen su
  final int targetAmountMl; // İçilmesi gereken su

  WaterLog({
    required this.date,
    required this.consumedAmountMl,
    required this.targetAmountMl,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'consumedAmountMl': consumedAmountMl,
      'targetAmountMl': targetAmountMl,
    };
  }

  factory WaterLog.fromMap(Map<String, dynamic> map) {
    return WaterLog(
      date: map['date'],
      consumedAmountMl: map['consumedAmountMl'],
      targetAmountMl: map['targetAmountMl'],
    );
  }

  // Kalan su miktarını hesaplayan metot
  int get remainingAmount {
    final remaining = targetAmountMl - consumedAmountMl;
    return remaining < 0 ? 0 : remaining;
  }
}
