import 'package:flutter/material.dart';
import 'package:lidar_application/pages/scan_tab.dart';
//import 'services/lidar.service.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  Widget _blob({
    required double width,
    required double height,
    required Alignment alignment,
    required List<Color> colors,
  }) {
    return Align(
      alignment: alignment,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(width),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors,
          ),
        ),
      ),
    );
  }

  Widget _tabContent(String title) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        extendBodyBehindAppBar: true,

        // 🔹 APP BAR
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'Liscan 3D',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.person_outline, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),

        body: Stack(
          children: [
            // BACKGROUND
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

            // BLOBS
            _blob(
              width: 260,
              height: 260,
              alignment: const Alignment(-2.5, 0.45),
              colors: [
                Colors.white.withOpacity(0.12),
                Colors.transparent,
              ],
            ),
            _blob(
              width: 220,
              height: 220,
              alignment: const Alignment(2.5, 1.0),
              colors: const [
                Color(0xFF2E357A),
                Colors.transparent,
              ],
            ),

            // CONTENT
            SafeArea(
              top: false,
              child: Column(
                children: [
                  const SizedBox(height: kToolbarHeight + 56),

                  // 🔹 TAB BAR (FIXED)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TabBar(
                        dividerColor: Colors.transparent, // ❌ remove underline
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.black54,
                        labelPadding: EdgeInsets.zero,
                        tabs: const [
                          Tab(
                            child: _TabItem(
                              icon: Icons.view_in_ar,
                              label: 'Scan',
                            ),
                          ),
                          Tab(
                            child: _TabItem(
                              icon: Icons.straighten,
                              label: 'Measure',
                            ),
                          ),
                          Tab(
                            child: _TabItem(
                              icon: Icons.tag,
                              label: 'Evidence',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 🔹 TAB CONTENT
                  Expanded(
                    child: TabBarView(
                      children: [
                        const ScanTab(),
                        _tabContent('No available evidence for measurement'),
                        _tabContent('No available evidence for marking'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        // 🔹 BOTTOM NAV BAR
        bottomNavigationBar: SizedBox(
          height: 70,
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() => _currentIndex = index);
            },
            backgroundColor: Colors.white,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.black54,
            type: BottomNavigationBarType.fixed,
            iconSize: 26,
            selectedFontSize: 12,
            unselectedFontSize: 11,
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
      ),
    );
  }
}

/// 🔹 CUSTOM TAB ITEM (prevents icon/text overlap)
class _TabItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _TabItem({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 18),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
