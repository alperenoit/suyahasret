import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suyahasret/features/onboarding/onboarding_screen.dart';
import 'package:suyahasret/features/onboarding/user_provider.dart';

void main() {
  // Riverpod'un çalışabilmesi için tüm uygulamayı ProviderScope ile sarmallıyoruz.
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Kullanıcı durumunu anlık olarak izliyoruz
    final userProfile = ref.watch(userProvider);

    return MaterialApp(
      title: 'Suya Hasret',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      // Eğer kullanıcı onboard aşamasını geçtiyse ana ekrana, geçmediyse onboarding'e yönlendiriyoruz
      home: userProfile.isOnboarded
          ? const TestHomeScreen()
          : const OnboardingScreen(),
    );
  }
}

/// Test amacıyla oluşturulmuş geçici Ana Ekran.
/// Onboarding başarıyla tamamlandığında bu ekran otomatik olarak açılacaktır.
class TestHomeScreen extends ConsumerWidget {
  const TestHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Ana ekrandan da kullanıcı bilgilerine erişiyoruz
    final userProfile = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Suya Hasret'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_outline,
                size: 80,
                color: Colors.green,
              ),
              const SizedBox(height: 20),
              // Özellik 4: Dinamik karşılama metni
              Text(
                'Merhaba ${userProfile.name} ${userProfile.surname}!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Onboarding akışı başarıyla test edildi. Durum (State) Riverpod ile başarıyla yönetiliyor.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
