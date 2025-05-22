import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'record_set_page.dart';
import 'main_BPM_set_page.dart';

class MapPage extends StatefulWidget {
  final bool isLocationAgreed;
  final bool showLoginBanner;
  const MapPage({required this.isLocationAgreed,  this.showLoginBanner = true,Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(36.3623, 127.3449); // ✅ 여기!

  @override
  void initState() {
    super.initState();
    if (widget.isLocationAgreed) {
      requestLocationPermission();
    }
    if (widget.showLoginBanner) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showCustomBanner();
      });
    }
  }

  Future<void> requestLocationPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      print("위치 권한 허용됨");
    } else {
      print("위치 권한 거부됨");
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void showCustomBanner() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
          backgroundColor: Colors.white,
          child: SizedBox(
            width: 300,
            height: 180,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 4),
                  child: Text('안내', style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18)),
                ),
                const Divider(height: 1, thickness: 1),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                    child: Center(
                      child: Text('로그인 되었습니다.', textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ),
                const Divider(height: 1, thickness: 1),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12)),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('확인', style: TextStyle(fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF670C),
      endDrawer: _buildDrawer(context),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF670C),
        elevation: 0,
        leading: const SizedBox(),
        title: const Text(
          'RPM',
          style: TextStyle(fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              fontSize: 24),
        ),
        centerTitle: true,
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                  target: _center, zoom: 14.0),
              myLocationEnabled: widget.isLocationAgreed,
              myLocationButtonEnabled: widget.isLocationAgreed,
            ),
          ),
          Container(
            color: const Color(0xFFFF670C),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(
                      Icons.refresh, color: Colors.black, size: 32),
                  onPressed: () {},
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const FuncPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(40),
                    elevation: 6,
                  ),
                  child: const Text("시작", style: TextStyle(color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
                ),
                IconButton(
                  icon: const Icon(
                      Icons.local_fire_department, color: Colors.black,
                      size: 32),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const RecordPage()));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0xFFFF670C),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 16),
                Row(
                  children: const [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage(
                          'assets/images/tongtongtong.png'), // 이미지 사용
                    ),
                    SizedBox(width: 12),
                    Text("퉁퉁퉁 사후르", style: TextStyle(fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.cancel_outlined, color: Colors.black),
                  iconSize: 28,
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
            const SizedBox(height: 20),
            const Divider(thickness: 1, color: Colors.black),
            const SizedBox(height: 10),
            _buildDrawerButton(Icons.campaign, "공지사항"),
            _buildDrawerButton(Icons.question_answer, "FAQ"),
            _buildDrawerButton(Icons.person_add, "친구 초대"),
            _buildDrawerButton(Icons.library_music, "음악"),
            _buildDrawerButton(Icons.settings, "환경 설정"),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerButton(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          minimumSize: const Size(double.infinity, 90),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 32), // ← 아이콘 크기 키움
            const SizedBox(width: 20), // ← 아이콘과 텍스트 사이 간격
            Text(
              label,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

}