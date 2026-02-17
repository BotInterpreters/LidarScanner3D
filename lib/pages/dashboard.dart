import 'package:flutter/material.dart';
import 'package:lidar_application/pages/scan_tab.dart';
import 'package:flutter/services.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  static const MethodChannel _lidarChannel = MethodChannel(
    'crime_scene_scanner',
  );

  Future<void> _startLidarScan(BuildContext context) async {
    try {
      await _lidarChannel.invokeMethod('startScan');
    } on PlatformException catch (e) {
      print("Failed to start LiDAR scan: ${e.message}");
    }
  }

  void _startMeasurement(BuildContext context) {
    print("Starting measurement mode...");
  }

  void _startEvidenceCapture(BuildContext context) {
    print("Starting evidence capture...");
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFF000B26),

        // ---------------- APP BAR ----------------
        appBar: AppBar(
          backgroundColor: const Color(0xFF000B26),
          elevation: 0,
          title: const Text(
            'Liscan 3D',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
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
                    Tab(icon: Icon(Icons.view_in_ar, size: 18), text: "Scan"),
                    Tab(
                      icon: Icon(Icons.straighten, size: 18),
                      text: "Measure",
                    ),
                    Tab(icon: Icon(Icons.tag, size: 18), text: "Evidence"),
                  ],
                ),
              ),
            ),
          ),
        ),

        // ---------------- BODY ----------------
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF000B26), Color(0xFF02010F)],
                ),
              ),
            ),

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

        // ---------------- BOTTOM BUTTONS ----------------
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black54,
          type: BottomNavigationBarType.fixed,

          // Not tied to tabs.
          currentIndex: 0,

          onTap: (index) {
            if (index == 0) {
              _startLidarScan(context);
            }

            if (index == 1) {
              _startMeasurement(context);
            }

            if (index == 2) {
              _startEvidenceCapture(context);
            }
          },

          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.view_in_ar),
              label: 'Scan Button',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.straighten),
              label: 'Measure Button',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.tag),
              label: 'Evidence Button',
            ),
          ],
        ),
      ),
    );
  }
}
