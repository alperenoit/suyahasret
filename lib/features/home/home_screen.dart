import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:suyahasret/features/onboarding/user_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // TODO: İleride bu değerleri Riverpod üzerinden canlı timer'a bağlayacağız
  final double _progress = 0.65;
  final String _timeLeft = "26:14";
  final String _currentBlock = "1. Ders";

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Merhaba ${userProfile.name} 👋',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              // Ayarlar sayfasına gidecek
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Üst Bilgi Kartı (Günün Özeti)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.lightBlue.withOpacity(0.7),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.lightBlue.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Bugünkü Toplam Çalışma",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "0 Saat 0 Dk",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  Icon(Icons.timeline, color: Colors.white, size: 30),
                ],
              ),
            ),

            const Spacer(),

            // Devasa Odaklanma Sayacı (Özellik 3 ve 5)
            CircularPercentIndicator(
              radius: 140.0,
              lineWidth: 18.0,
              animation: true,
              percent: _progress,
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _currentBlock,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _timeLeft,
                    style: const TextStyle(
                      fontSize: 52,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightBlueAccent,
                    ),
                  ),
                ],
              ),
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: Colors.lightBlue,
              backgroundColor: Colors.lightBlue.withOpacity(0.1),
            ),

            const Spacer(),

            // Alt Kısım: Su Durumu ve Program Butonları
            Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    context,
                    title: "Su Durumu",
                    subtitle: "0 / 2500 ml",
                    icon: Icons.water_drop,
                    color: Colors.lightBlue,
                    onTap: () {
                      // Su ekranına yönlendirme
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildActionCard(
                    context,
                    title: "Program",
                    subtitle: "Hafta Sonu",
                    icon: Icons.calendar_month,
                    color: Colors.lightBlue,
                    onTap: () {
                      // Program ayarlama ekranına yönlendirme
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Alt kısımdaki butonları üreten yardımcı widget
  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
