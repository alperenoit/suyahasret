enum BlockType { lesson, breakTime, lunchBreak }

class TimeBlock {
  final String title; // Blok adı
  final DateTime start; // Blok başlangıç tarih ve saati
  final DateTime end; // Blok bitiş tarih ve saati
  final BlockType type; // Blok tipi

  TimeBlock({
    required this.title,
    required this.start,
    required this.end,
    required this.type,
  });

  // Dersin bitmesine ne kadar kaldığını ve bitip bitmediğini hesaplayan fonksiyon
  bool get isActive {
    final now = DateTime.now();
    return now.isAfter(start) && now.isBefore(end);
  }
}
