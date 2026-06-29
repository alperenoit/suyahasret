import 'package:suyahasret/models/study_template.dart';
import 'package:suyahasret/models/time_block.dart';

class ScheduleGenerator {
  /// String olan saati DateTime nesnesine çevirir
  static DateTime _parseTime(String time) {
    final parts = time.split(':');
    final now = DateTime.now();
    return DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  /// Verilen şablona göre günün tüm ders ve mola bloklarını üretir
  static List<TimeBlock> generate(StudyTemplate template) {
    List<TimeBlock> blocks = [];

    DateTime currentTime = _parseTime(template.startTime);
    final DateTime endOfDay = _parseTime(template.endTime);

    DateTime? lunchStart;
    DateTime? lunchEnd;

    // Öğle molası doluysa parse et
    if (template.lunchBreakStart != null && template.lunchBreakEnd != null) {
      lunchStart = _parseTime(template.lunchBreakStart!);
      lunchEnd = _parseTime(template.lunchBreakEnd!);
    }

    int lessonCount = 1;

    // Şu anki hesaplanan zaman, bitişten önce olduğu sürece blok üretmeye devam et
    while (currentTime.isBefore(endOfDay)) {
      // 1. ÖĞLE MOLASI KONTROLÜ
      if (lunchStart != null && lunchEnd != null) {
        // Eğer sıradaki dersin süresi öğle molasına taşıyorsa veya tam öğle molası saatindeysek
        DateTime potentialLessonEnd = currentTime.add(
          Duration(minutes: template.lessonDurationMinutes),
        );

        if (currentTime.isAtSameMomentAs(lunchStart) ||
            (currentTime.isBefore(lunchStart) &&
                potentialLessonEnd.isAfter(lunchStart))) {
          blocks.add(
            TimeBlock(
              title: "Öğle Molası",
              start: lunchStart,
              end: lunchEnd,
              type: BlockType.lunchBreak,
            ),
          );

          currentTime = lunchEnd; // Saati öğle molasının bitişine sar

          if (!currentTime.isBefore(endOfDay))
            break; // Mola bitişi mesai sonunu geçtiyse döngüyü bitir
        }
      }

      // 2. DERS BLOĞU OLUŞTURMA
      DateTime lessonEnd = currentTime.add(
        Duration(minutes: template.lessonDurationMinutes),
      );

      // Eğer ders mesai bitişini taşıyorsa, dersi bitiş saatinde kes
      if (lessonEnd.isAfter(endOfDay)) {
        lessonEnd = endOfDay;
      }

      blocks.add(
        TimeBlock(
          title: "$lessonCount. Ders",
          start: currentTime,
          end: lessonEnd,
          type: BlockType.lesson,
        ),
      );

      currentTime = lessonEnd; // Saati dersin bittiği ana güncelle
      lessonCount++;

      // 3. TENEFFÜS BLOĞU OLUŞTURMA
      // Gün sonu değilse ve öğle molası başlamıyorsa teneffüs ekle
      if (currentTime.isBefore(endOfDay)) {
        // Eğer ders biter bitmez öğle molası başlıyorsa teneffüs ekleme
        if (lunchStart != null && currentTime.isAtSameMomentAs(lunchStart)) {
          continue;
        }

        DateTime breakEnd = currentTime.add(
          Duration(minutes: template.breakDurationMinutes),
        );

        if (breakEnd.isAfter(endOfDay)) {
          breakEnd = endOfDay;
        }

        blocks.add(
          TimeBlock(
            title: "Teneffüs",
            start: currentTime,
            end: breakEnd,
            type: BlockType.breakTime,
          ),
        );

        currentTime = breakEnd; // Saati teneffüsün bittiği ana güncelle
      }
    }

    return blocks;
  }
}
