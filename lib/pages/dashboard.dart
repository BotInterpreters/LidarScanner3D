import 'package:flutter/material.dart';
import 'package:lidar_application/pages/scan_tab.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFF000B26),

        appBar: AppBar(
          backgroundColor: const Color(0xFF000B26),
          elevation: 0,
          title: const Text(
            'Liscan 3D',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.person_outline, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Container(
                height: 50,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const TabBar(
                  dividerColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black54,
                  tabs: [
                    Tab(
                      icon: Icon(Icons.view_in_ar, size: 18),
                      text: "Scan",
                    ),
                    Tab(
                      icon: Icon(Icons.straighten, size: 18),
                      text: "Measure",
                    ),
                    Tab(
                      icon: Icon(Icons.tag, size: 18),
                      text: "Evidence",
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        body: Stack(
          children: [
            // Background gradient
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF000B26),
                    Color(0xFF02010F),
                  ],
                ),
              ),
            ),

            // Tab content
            const TabBarView(
              children: [
                ScanTab(),
                Center(
                  child: Text(
                    "Measurement Page",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "Evidence Page",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          onTap: (_) {},
          backgroundColor: Colors.white,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black54,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.view_in_ar),
              label: 'Scan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.straighten),
              label: 'Measure',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.tag),
              label: 'Evidence',
            ),
          ],
        ),
      ),
    );
  }
}
