import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suyahasret/features/onboarding/user_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ref
          .read(userProvider.notifier)
          .saveUser(
            _nameController.text.trim(),
            _surnameController.text.trim(),
          );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hoş geldin, ${_nameController.text}!'),
          backgroundColor: Colors.blueAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ÇÖZÜM 1: Sabit açık renk arka planı sildik.
      // Artık otomatik olarak main.dart'taki koyu temayı çekecek.
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.water_drop,
                    size: 100,
                    color: Colors.blueAccent,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Suya Hasret",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // ÇÖZÜM 2: Yazıyı beyaz yaptık
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Verimli çalışın, dehidre kalmayın.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors
                          .white60, // ÇÖZÜM 3: Alt başlığı hafif şeffaf beyaz yaptık
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Ad Giriş Alanı
                  TextFormField(
                    controller: _nameController,
                    style: const TextStyle(
                      color: Colors.white,
                    ), // Giriş yapılan yazı rengi
                    decoration: InputDecoration(
                      labelText: 'Adınız',
                      labelStyle: const TextStyle(color: Colors.white60),
                      prefixIcon: const Icon(
                        Icons.person_outline,
                        color: Colors.white60,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white24),
                      ),
                      filled: true,
                      fillColor: const Color(
                        0xff1C2541,
                      ), // ÇÖZÜM 4: Giriş kutusunu koyu mavi/gri yaptık
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Lütfen adınızı girin';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Soyad Giriş Alanı
                  TextFormField(
                    controller: _surnameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Soyadınız',
                      labelStyle: const TextStyle(color: Colors.white60),
                      prefixIcon: const Icon(
                        Icons.person_outline,
                        color: Colors.white60,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white24),
                      ),
                      filled: true,
                      fillColor: const Color(0xff1C2541),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Lütfen soyadınızı girin';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),

                  // Başla Butonu
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      "Hemen Başla",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
