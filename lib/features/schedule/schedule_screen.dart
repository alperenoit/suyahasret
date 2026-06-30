import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suyahasret/features/schedule/schedule_provider.dart';
import 'package:suyahasret/features/schedule/add_schedule_screen.dart';

class ScheduleScreen extends ConsumerWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Riverpod üzerinden hafızadaki program listesini anlık olarak çekiyoruz
    final schedules = ref.watch(scheduleProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Çalışma Programlarım',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      // Eğer liste boşsa ortada bilgi mesajı göster, doluysa listeyi çiz
      body: schedules.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(24.0),
              itemCount: schedules.length,
              itemBuilder: (context, index) {
                final template = schedules[index];
                return _buildScheduleCard(context, ref, template);
              },
            ),
      // Sağ alttaki yeni program ekleme butonu
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Artı butonuna basınca oluşturduğumuz form sayfasına (AddScheduleScreen) yönlendir
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddScheduleScreen()),
          );
        },
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text(
          "Yeni Ekle",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // Hiç program yokken gösterilecek boş ekran tasarımı
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 80,
            color: Colors.white.withOpacity(0.2),
          ),
          const SizedBox(height: 16),
          const Text(
            "Henüz Bir Program Yok",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Sağ alttaki butona tıklayarak\nilk çalışma şablonunu oluştur.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white60, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // Kayıtlı programları gösteren şık kart tasarımı (Karanlık temaya uygun)
  Widget _buildScheduleCard(BuildContext context, WidgetRef ref, template) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xff1C2541), // Kartın koyu arka planı
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // TODO: İleride bu karta tıklayınca "Bu programı bugün için başlat" eylemini tetikleyeceğiz
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Sol taraftaki mavi ikon alanı
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.menu_book, color: Colors.blueAccent),
                ),
                const SizedBox(width: 16),

                // Orta kısımdaki yazılar (Ad ve Saatler)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        template.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${template.startTime} - ${template.endTime}  •  ${template.lessonDurationMinutes} dk Ders",
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                // Sağ taraftaki silme butonu
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                  ),
                  onPressed: () {
                    ref
                        .read(scheduleProvider.notifier)
                        .deleteTemplate(template.id);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
