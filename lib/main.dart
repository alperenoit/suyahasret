import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suyahasret/features/onboarding/onboarding_screen.dart';
import 'package:suyahasret/features/onboarding/user_provider.dart';
import 'package:suyahasret/features/main_navigation_screen.dart';

void main() {
  // Riverpod'un çalışabilmesi için tüm uygulamayı ProviderScope ile sarmallıyoruz.
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Kullanıcı durumunu anlık
    final userProfile = ref.watch(userProvider);

    return MaterialApp(
      title: 'Suya Hasret',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xff0B132B),
        colorScheme: const ColorScheme.dark(
          primary: Colors.blueAccent,
          surface: Color(0xff1C2541), // Kartların ve kutuların rengi
          onSurface: Colors.white, // Kartların üzerindeki yazı rengi
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.white, // AppBar yazı rengi
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xff0B132B),
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.white54,
        ),
        useMaterial3: true,
      ),
      // Kullanıcı onboard aşamasını geçtiyse ana ekrana, geçmediyse onboarding'e
      home: userProfile.isOnboarded
          ? const MainNavigationScreen()
          : const OnboardingScreen(),
    );
  }
}
