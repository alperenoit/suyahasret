import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:suyahasret/features/water/water_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WaterScreen extends ConsumerStatefulWidget {
  const WaterScreen({super.key});

  @override
  ConsumerState<WaterScreen> createState() => _WaterScreenState();
}

class _WaterScreenState extends ConsumerState<WaterScreen> {
  // Özellik 7: Su içmenin faydaları listesi
  final List<String> _waterFacts = [
    "Su içmek odaklanma süreni ve beyin fonksiyonlarını %14'e kadar artırır.",
    "Hafif dehidrasyon bile baş ağrısı ve yorgunluk hissine yol açabilir.",
    "Ders çalışırken yudum yudum su içmek stres seviyeni düşürmeye yardımcı olur.",
    "Beynimizin yaklaşık %75'i sudur. Susuz kalmak algı kapasitesini düşürür.",
    "Su, hücrelerine oksijen ve besin taşıyarak enerjik kalmanı sağlar.",
  ];

  late String _currentFact;

  @override
  void initState() {
    super.initState();
    // Ekran her açıldığında rastgele bir bilgi seçiyoruz
    _currentFact = _waterFacts[Random().nextInt(_waterFacts.length)];
  }

  @override
  Widget build(BuildContext context) {
    // Riverpod üzerinden su verisini dinliyoruz
    final waterLog = ref.watch(waterProvider);

    // Yüzdelik dilimi hesaplıyoruz (1.0'ı geçmemesi için clamp kullanıyoruz)
    double progress = (waterLog.consumedAmountMl / waterLog.targetAmountMl)
        .clamp(0.0, 1.0);

    return Scaffold(
      // backgroundColor silindi, main.dart'tan ana karanlık rengi miras alıyor
      appBar: AppBar(
        title: const Text(
          'Su Takibi',
          style: TextStyle(
            color: Colors.white, // Koyu lacivert yerine beyaz
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Dairesel Su İlerleme Göstergesi
            CircularPercentIndicator(
              radius: 120.0,
              lineWidth: 20.0,
              animation: true,
              animateFromLastPercent: true,
              percent: progress,
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.water_drop,
                    color: Colors.lightBlueAccent,
                    size: 40,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${waterLog.consumedAmountMl} ml",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Koyu lacivert yerine beyaz
                    ),
                  ),
                  Text(
                    "/ ${waterLog.targetAmountMl} ml",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white60,
                    ), // Gri yerine açık beyaz
                  ),
                ],
              ),
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: Colors.lightBlueAccent,
              backgroundColor: Colors.lightBlueAccent.withOpacity(0.1),
            ),

            const SizedBox(height: 10),

            // Kalan Miktar Metni
            Text(
              waterLog.remainingAmount > 0
                  ? "Hedefine ${waterLog.remainingAmount} ml kaldı!"
                  : "Tebrikler! Günlük hedefine ulaştın 🎉",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                // Karanlık temada metin rengini daha okunaklı yaptık
                color: waterLog.remainingAmount > 0
                    ? Colors.white70
                    : Colors.greenAccent,
              ),
            ),

            const SizedBox(height: 40),

            // Bardak / Şişe Seçenekleri
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Hızlı Ekle",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Koyu lacivert yerine beyaz
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Seçenekleri yan yana dizdiğimiz grid benzeri yapı
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: [
                _buildWaterOption(
                  context,
                  ml: 25,
                  title: "Bir Yudum",
                  icon: Icons.water_drop_outlined,
                ),
                _buildWaterOption(
                  context,
                  ml: 250,
                  title: "Bardak",
                  icon: Icons.local_drink_outlined,
                ),
                _buildWaterOption(
                  context,
                  ml: 350,
                  title: "Kupa",
                  icon: Icons.coffee_outlined,
                ),
                _buildWaterOption(
                  context,
                  ml: 500,
                  title: "Şişe",
                  svgPath: 'assets/icons/bottle_outlined.svg',
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Bilgi Kartı (Özellik 7)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.lightBlueAccent.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.lightbulb_outline,
                    color: Colors.lightBlueAccent,
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Bunu biliyor muydun?",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.lightBlueAccent,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _currentFact,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white, // Koyu lacivert yerine beyaz
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Bardak seçeneklerini üreten yardımcı widget
  Widget _buildWaterOption(
    BuildContext context, {
    required int ml,
    required String title,
    IconData? icon,
    String? svgPath,
  }) {
    return InkWell(
      onTap: () {
        ref.read(waterProvider.notifier).addWater(ml);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xff1C2541),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Eğer svgPath doluysa SVG çiz, yoksa normal Icon çiz
            svgPath != null
                ? SvgPicture.asset(
                    svgPath,
                    width: 36,
                    height: 36,
                    colorFilter: const ColorFilter.mode(
                      Colors.blueAccent,
                      BlendMode.srcIn,
                    ),
                  )
                : Icon(icon, size: 36, color: Colors.blueAccent),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "+$ml ml",
              style: const TextStyle(color: Colors.white60, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
