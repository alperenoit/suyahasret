import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:suyahasret/models/study_template.dart';

class ScheduleNotifier extends Notifier<List<StudyTemplate>> {
  final _box = Hive.box('schedules');

  @override
  List<StudyTemplate> build() {
    // Uygulama açıldığında veritabanındaki kayıtlı programları yükler
    return _loadTemplates();
  }

  // Hafızadaki verileri okuyup listeye çeviren yardımcı fonksiyon
  List<StudyTemplate> _loadTemplates() {
    final List<StudyTemplate> loadedTemplates = [];

    // Kutudaki tüm verileri döngüye sok
    for (var key in _box.keys) {
      final item = _box.get(key);
      if (item != null) {
        // Map yapısını bizim modele çeviriyoruz
        loadedTemplates.add(
          StudyTemplate.fromMap(Map<String, dynamic>.from(item)),
        );
      }
    }
    return loadedTemplates;
  }

  // Yeni program ekleme ve kaydetme
  void addTemplate(StudyTemplate template) {
    // Veritabanına yaz
    _box.put(template.id, template.toMap());
    // Ekranda anında görünmesi için mevcut listeyi güncelle
    state = [...state, template];
  }

  // İleride lazım olacak silme fonksiyonu
  void deleteTemplate(String id) {
    _box.delete(id);
    state = state.where((template) => template.id != id).toList();
  }
}

final scheduleProvider =
    NotifierProvider<ScheduleNotifier, List<StudyTemplate>>(() {
      return ScheduleNotifier();
    });
