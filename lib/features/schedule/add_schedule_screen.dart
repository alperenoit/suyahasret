import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suyahasret/models/study_template.dart';
import 'package:suyahasret/features/schedule/schedule_provider.dart';

class AddScheduleScreen extends ConsumerStatefulWidget {
  const AddScheduleScreen({super.key});

  @override
  ConsumerState<AddScheduleScreen> createState() => _AddScheduleScreenState();
}

class _AddScheduleScreenState extends ConsumerState<AddScheduleScreen> {
  final _formKey = GlobalKey<FormState>();

  // Kontrolcüler
  final _titleController = TextEditingController();
  final _lessonDurationController = TextEditingController(
    text: "75",
  ); // Varsayılan 75 dk
  final _breakDurationController = TextEditingController(
    text: "15",
  ); // Varsayılan 15 dk

  // Saat değişkenleri
  TimeOfDay _startTime = const TimeOfDay(hour: 10, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 19, minute: 0);

  bool _hasLunchBreak = false;
  TimeOfDay _lunchStart = const TimeOfDay(hour: 12, minute: 0);
  TimeOfDay _lunchEnd = const TimeOfDay(hour: 13, minute: 0);

  @override
  void dispose() {
    _titleController.dispose();
    _lessonDurationController.dispose();
    _breakDurationController.dispose();
    super.dispose();
  }

  // Flutter'ın yerleşik saat seçici (TimePicker) penceresini açan yardımcı fonksiyon
  Future<void> _selectTime(
    BuildContext context,
    TimeOfDay initialTime,
    Function(TimeOfDay) onTimeSelected,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return Theme(
          // Saat seçicinin temasını karanlık temaya uyduruyoruz
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.blueAccent,
              surface: Color(0xff1C2541),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != initialTime) {
      onTimeSelected(picked);
    }
  }

  // Saat formatını String'e çeviren yardımcı fonksiyon (Örn: "10:30")
  String _formatTime(TimeOfDay time) {
    final String hour = time.hour.toString().padLeft(2, '0');
    final String minute = time.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }

  void _saveTemplate() {
    if (_formKey.currentState!.validate()) {
      final newTemplate = StudyTemplate(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        startTime: _formatTime(_startTime),
        endTime: _formatTime(_endTime),
        lessonDurationMinutes: int.parse(_lessonDurationController.text),
        breakDurationMinutes: int.parse(_breakDurationController.text),
        lunchBreakStart: _hasLunchBreak ? _formatTime(_lunchStart) : null,
        lunchBreakEnd: _hasLunchBreak ? _formatTime(_lunchEnd) : null,
      );

      // ÇÖZÜM: Yeni şablonu provider üzerinden veritabanına gönderiyoruz
      ref.read(scheduleProvider.notifier).addTemplate(newTemplate);

      // Kayıt başarılı mesajı
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${newTemplate.title} programı başarıyla kaydedildi!'),
          backgroundColor: Colors.greenAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Yeni Program Ekle',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Program Adı
              TextFormField(
                controller: _titleController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Program Adı (Örn: Hafta Sonu Kampı)',
                  labelStyle: const TextStyle(
                    color: Color.fromARGB(207, 255, 255, 255),
                  ),
                  prefixIcon: const Icon(
                    Icons.edit_note,
                    color: Colors.blueAccent,
                  ),
                  filled: true,
                  fillColor: const Color(0xff1C2541),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Lütfen program adı girin' : null,
              ),
              const SizedBox(height: 24),

              // 2. Mesai (Başlangıç ve Bitiş) Saatleri
              Row(
                children: [
                  Expanded(
                    child: _buildTimePickerCard(
                      title: "Başlama Saati",
                      time: _startTime,
                      icon: Icons.play_circle_outline,
                      onTap: () => _selectTime(
                        context,
                        _startTime,
                        (picked) => setState(() => _startTime = picked),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTimePickerCard(
                      title: "Bitiş Saati",
                      time: _endTime,
                      icon: Icons.stop_circle_outlined,
                      onTap: () => _selectTime(
                        context,
                        _endTime,
                        (picked) => setState(() => _endTime = picked),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 3. Süre Ayarları (Ders ve Teneffüs)
              Row(
                children: [
                  Expanded(
                    child: _buildDurationInput(
                      controller: _lessonDurationController,
                      label: "Ders Süresi (dk)",
                      icon: Icons.timer,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDurationInput(
                      controller: _breakDurationController,
                      label: "Teneffüs (dk)",
                      icon: Icons.coffee,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 4. Öğle Molası Anahtarı (Switch)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xff1C2541),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text(
                        "Öğle Molası Ekle",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: const Text(
                        "Günün ortasında uzun bir ara verin",
                        style: TextStyle(color: Colors.white60, fontSize: 14),
                      ),
                      activeColor: Colors.blueAccent,
                      value: _hasLunchBreak,
                      onChanged: (value) =>
                          setState(() => _hasLunchBreak = value),
                    ),

                    // Switch açıksa öğle molası saatlerini göster
                    if (_hasLunchBreak) ...[
                      const Divider(color: Colors.white24),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTimePickerCard(
                              title: "Mola Başlangıcı",
                              time: _lunchStart,
                              icon: Icons.restaurant_menu,
                              onTap: () => _selectTime(
                                context,
                                _lunchStart,
                                (picked) =>
                                    setState(() => _lunchStart = picked),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTimePickerCard(
                              title: "Mola Bitişi",
                              time: _lunchEnd,
                              icon: Icons.check_circle_outline,
                              onTap: () => _selectTime(
                                context,
                                _lunchEnd,
                                (picked) => setState(() => _lunchEnd = picked),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // 5. Kaydet Butonu
              ElevatedButton(
                onPressed: _saveTemplate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 5,
                  shadowColor: Colors.blueAccent.withOpacity(0.5),
                ),
                child: const Text(
                  "Programı Kaydet",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // Saat seçme kartları için yardımcı widget
  Widget _buildTimePickerCard({
    required String title,
    required TimeOfDay time,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xff1C2541),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.blueAccent),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(color: Colors.white60, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(time),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Dakika girişi (Ders/Teneffüs) için yardımcı widget
  Widget _buildDurationInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Color.fromARGB(209, 255, 255, 255),
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        prefixIcon: Icon(icon, color: Colors.blueAccent, size: 20),
        filled: true,
        fillColor: const Color(0xff1C2541),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty || int.tryParse(value) == null) {
          return 'Hata';
        }
        return null;
      },
    );
  }
}
