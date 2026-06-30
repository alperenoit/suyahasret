import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:suyahasret/features/onboarding/user_provider.dart';
import 'package:suyahasret/features/timer/timer_provider.dart'; // Yeni yazdığımız provider

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // Saniyeyi "MM:SS" formatına çeviren yardımcı fonksiyon
  String _formatDuration(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProvider);

    // Timer verilerini Riverpod'dan anlık olarak dinliyoruz
    final timerState = ref.watch(timerProvider);
    final timerNotifier = ref.read(timerProvider.notifier);

    // Çemberin doluluk oranını hesaplıyoruz
    double progress = timerState.totalSeconds > 0
        ? (timerState.remainingSeconds / timerState.totalSeconds).clamp(
            0.0,
            1.0,
          )
        : 0.0;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
            icon: const Icon(Icons.settings, color: Colors.blueAccent),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Üst Bilgi Kartı (Günün Özeti)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xff1C2541),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
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
                        style: TextStyle(color: Colors.white60, fontSize: 14),
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
                  Icon(Icons.timeline, color: Colors.blueAccent, size: 30),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Devasa Odaklanma Sayacı (Artık Canlı!)
            CircularPercentIndicator(
              radius: 140.0,
              lineWidth: 18.0,
              animation: true,
              animateFromLastPercent: true, // Geçişlerde yumuşaklık sağlar
              percent: progress,
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    timerState
                        .currentPhase, // "1. Ders" veya "Teneffüs" yazısı provider'dan geliyor
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white60,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatDuration(
                      timerState.remainingSeconds,
                    ), // Canlı azalan saat
                    style: const TextStyle(
                      fontSize: 52,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: timerState.currentPhase.contains("Teneffüs")
                  ? Colors.greenAccent
                  : Colors.blueAccent, // Teneffüste renk yeşil olacak
              backgroundColor: Colors.blueAccent.withOpacity(0.1),
            ),

            const SizedBox(height: 30),

            // Başlat / Duraklat Butonu
            FloatingActionButton.extended(
              onPressed: () {
                if (timerState.isRunning) {
                  timerNotifier.pause();
                } else {
                  timerNotifier.start();
                }
              },
              backgroundColor: timerState.isRunning
                  ? Colors.orangeAccent
                  : Colors.blueAccent,
              foregroundColor: Colors.white,
              elevation: 4,
              icon: Icon(timerState.isRunning ? Icons.pause : Icons.play_arrow),
              label: Text(
                timerState.isRunning ? "Duraklat" : "Dersi Başlat",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Alt Kısım: Su Durumu ve Program Butonları
            Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    context,
                    title: "Su Durumu",
                    subtitle: "Hızlı Ekle",
                    icon: Icons.water_drop,
                    color: Colors.lightBlue,
                    onTap: () {
                      // BottomNavigationBar ile sekmeler arası geçiş yapılabiliyor zaten,
                      // İstenirse buraya ekstra bir tıklama animasyonu konabilir.
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildActionCard(
                    context,
                    title: "Bugünün Akışı",
                    subtitle: "Programa Göz At",
                    icon: Icons.calendar_month,
                    color: Colors.indigo,
                    onTap: () {},
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

  // Alt kısımdaki butonları üreten yardımcı widget (Değişmedi)
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
          color: const Color(0xff1C2541),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
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
              style: const TextStyle(color: Colors.white60, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
