import 'package:flutter_riverpod/flutter_riverpod.dart';

// Kullanıcı profil verileri
class UserProfile {
  final String name;
  final String surname;
  final bool isOnboarded;

  UserProfile({
    required this.name,
    required this.surname,
    required this.isOnboarded,
  });

  // İlk açılışta boş değerlerle başlaması için boş bir şablon
  factory UserProfile.empty() {
    return UserProfile(name: '', surname: '', isOnboarded: false);
  }
}

// Kullanıcı durumunu yöneten Notifier sınıfı
class UserNotifier extends Notifier<UserProfile> {
  @override
  UserProfile build() {
    // İleride buraya Hive/SharedPreferences entegrasyonu gelince,
    // uygulama açılırken kayıtlı ismi buradan okuyacağız.
    return UserProfile.empty();
  }

  // Kullanıcı giriş yaptığında durumu güncelleyen fonksiyon
  void saveUser(String name, String surname) {
    state = UserProfile(name: name, surname: surname, isOnboarded: true);
  }
}

// Uygulama genelinden bu duruma erişmek için global provider
final userProvider = NotifierProvider<UserNotifier, UserProfile>(() {
  return UserNotifier();
});
