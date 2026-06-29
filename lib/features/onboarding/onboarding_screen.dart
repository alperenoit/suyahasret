import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suyahasret/features/onboarding/user_provider.dart';
// Not: İleride home_screen.dart oluşturduğumuzda buraya import edeceğiz.

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
    // Memory leak (bellek sızıntısı) önlemek için controller'ları dispose ediyoruz
    _nameController.dispose();
    _surnameController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Form geçerliyse Riverpod provider'ımıza verileri kaydediyoruz
      ref
          .read(userProvider.notifier)
          .saveUser(
            _nameController.text.trim(),
            _surnameController.text.trim(),
          );

      // TODO: Burada Navigator ile Ana Ekrana (HomeScreen) yönlendirme yapacağız.
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
      backgroundColor: const Color(
        0xfff4f9f9,
      ), // Su temasına uygun çok açık soft bir arka plan
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
                  // Su Damlası veya Uygulama Logosu Alanı
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
                      color: Color(0xff1a3e5c),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Verimli çalışın, dehidre kalmayın.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  const SizedBox(height: 40),

                  // Ad Giriş Alanı
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Adınız',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
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
                    decoration: InputDecoration(
                      labelText: 'Soyadınız',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
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
