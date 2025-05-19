import 'package:flutter/material.dart';
import 'UserInfoPage.dart';
import 'main_map.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rpm_test3/create_account_1.dart';



void main() {
  runApp(SignUpAgreementPage());
}

class SignUpAgreementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AgreementPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AgreementPage extends StatefulWidget {
  @override
  _AgreementPageState createState() => _AgreementPageState();
}

class _AgreementPageState extends State<AgreementPage> {
  bool agreeAll = false;
  bool agreeTerms = false;
  bool agreePrivacy = false;
  bool agreeLocation = false;

  Future<void> requestLocationPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      print("위치 권한 허용됨");
    } else {
      print("위치 권한 거부됨");
    }
  }


  void toggleAll(bool? value) {
    setState(() {
      agreeAll = value ?? false;
      agreeTerms = agreeAll;
      agreePrivacy = agreeAll;
      agreeLocation = agreeAll;
    });
  }

  bool get isAllChecked => agreeTerms && agreePrivacy && agreeLocation;  // 모두 체크되었는지 확인

  @override
  Widget build(BuildContext context) {
    final orange = Color(0xFFFF670C);
    final beige = Color(0xFFEAB89D);
    final lightGray = Color(0xFFEFEFEF);

    return Scaffold(
      backgroundColor: orange,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 40),
            Text(
              'RPM',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: beige,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CheckboxListTile(
                          value: agreeAll,
                          onChanged: toggleAll,
                          title: Text(
                            '전체 동의하기',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                        ),
                        Divider(thickness: 1, color: Colors.black54),
                        CheckboxListTile(
                          value: agreeLocation,
                          onChanged: (value) async {
                            setState(() {
                              agreeLocation = value ?? false;
                            });

                            // ✅ 위치 권한 요청 함수 호출
                            if (value == true) {
                              await requestLocationPermission();
                            }
                          },
                          title: Text(
                            '사용자의 위치를 사용하도록 허용하시겠습니까? *',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                        ),

                        CheckboxListTile(
                          value: agreePrivacy,
                          onChanged: (value) {
                            setState(() {
                              agreePrivacy = value ?? false;
                            });
                          },
                          title: Text(
                            '개인 정보 수집 및 이용에 동의합니다. *',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            if (isAllChecked) // 체크박스가 모두 체크되었을 때 '계속' 버튼을 표시
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => UserInfoPage()),
                  );

                },
                child: Container(
                  width: 100, // 크기를 100으로 설정
                  height: 50, // 크기를 50으로 설정
                  decoration: BoxDecoration(
                    color: lightGray,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      '계속',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            SizedBox(height: 10),
            // 취소 버튼은 항상 보이게
            GestureDetector(
              onTap: () {
                // 취소 버튼 클릭 시 동작할 코드
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) =>SignUpPage()));

                // 예를 들어, 이전 페이지로 돌아가거나 다른 작업을 수행할 수 있습니다.
              },
              child: Container(
                width: 100,
                height: 50,
                decoration: BoxDecoration(
                  color: lightGray,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '취소',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
