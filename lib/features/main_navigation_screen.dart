import 'package:flutter/material.dart';
import 'package:suyahasret/features/home/home_screen.dart';
import 'package:suyahasret/features/water/water_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  // Sırasıyla sekmelerimizi listeliyoruz
  final List<Widget> _screens = [
    const HomeScreen(),
    const WaterScreen(), // Geçici Su Ekranı
    // const PlaceholderScheduleScreen(), // Geçici Program Ekranı
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack sayesinde tüm sayfalar bellekte canlı kalır, sadece seçili olan gösterilir
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.timer_outlined),
              activeIcon: Icon(Icons.timer),
              label: 'Ana Ekran',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.water_drop_outlined),
              activeIcon: Icon(Icons.water_drop),
              label: 'Su Takibi',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined),
              activeIcon: Icon(Icons.calendar_month),
              label: 'Program',
            ),
          ],
        ),
      ),
    );
  }
}

// Geliştirme aşamasında hata almamak için geçici Su Ekranı taslağı
class PlaceholderWaterScreen extends StatelessWidget {
  const PlaceholderWaterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f9f9),
      appBar: AppBar(
        title: const Text('Su Takibi'),
        backgroundColor: Colors.transparent,
      ),
      body: const Center(
        child: Text(
          'Su Takibi Ekranı Yakında Burada Olacak',
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
