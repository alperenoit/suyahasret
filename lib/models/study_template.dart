class StudyTemplate {
  final String id; // Şablon ID
  final String title; // Şablonun adı
  final String startTime; // Başlangıç saati
  final String endTime; // Bitiş saati
  final int lessonDurationMinutes; // Ders süresi
  final int breakDurationMinutes; // Teneffüs süresi
  final String? lunchBreakStart; // Öğle molası başlangıcı
  final String? lunchBreakEnd; // Öğle molası

  StudyTemplate({
    required this.id,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.lessonDurationMinutes,
    required this.breakDurationMinutes,
    this.lunchBreakStart,
    this.lunchBreakEnd,
  });

  // İleride Hive veritabanına kaydetmek veya JSON'a çevirmek için
  // Map yapısına dönüştürme fonksiyonu
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'startTime': startTime,
      'endTime': endTime,
      'lessonDurationMinutes': lessonDurationMinutes,
      'breakDurationMinutes': breakDurationMinutes,
      'lunchBreakStart': lunchBreakStart,
      'lunchBreakEnd': lunchBreakEnd,
    };
  }

  // Veritabanından okurken Map yapısını tekrar nesneye dönüştürme fonksiyonu
  factory StudyTemplate.fromMap(Map<String, dynamic> map) {
    return StudyTemplate(
      id: map['id'],
      title: map['title'],
      startTime: map['startTime'],
      endTime: map['endTime'],
      lessonDurationMinutes: map['lessonDurationMinutes'],
      breakDurationMinutes: map['breakDurationMinutes'],
      lunchBreakStart: map['lunchBreakStart'],
      lunchBreakEnd: map['lunchBreakEnd'],
    );
  }
}
