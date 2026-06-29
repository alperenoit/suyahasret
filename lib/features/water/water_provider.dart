import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suyahasret/models/water_log.dart';

class WaterNotifier extends Notifier<WaterLog> {
  @override
  WaterLog build() {
    // Uygulama ilk açıldığında bugünün tarihiyle sıfırdan bir sayaç başlatıyoruz.
    // İleride Hive veritabanını bağladığımızda, bugünün verisi varsa onu okuyacağız.
    // Şimdilik test için varsayılan hedefi 2500 ml yapıyoruz.
    return WaterLog(
      date: DateTime.now().toIso8601String().split('T')[0],
      consumedAmountMl: 0,
      targetAmountMl: 2500,
    );
  }

  // Dışarıdan çağrılacak su ekleme fonksiyonu
  void addWater(int amountMl) {
    state = WaterLog(
      date: state.date,
      consumedAmountMl: state.consumedAmountMl + amountMl,
      targetAmountMl: state.targetAmountMl,
    );
  }

  // Yanlışlıkla fazla eklenirse geri almak için
  void removeWater(int amountMl) {
    int newAmount = state.consumedAmountMl - amountMl;
    if (newAmount < 0) newAmount = 0; // Eksiye düşmesini engelliyoruz

    state = WaterLog(
      date: state.date,
      consumedAmountMl: newAmount,
      targetAmountMl: state.targetAmountMl,
    );
  }
}

final waterProvider = NotifierProvider<WaterNotifier, WaterLog>(() {
  return WaterNotifier();
});
