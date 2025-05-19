import 'package:flutter/material.dart';
import 'select_genre.dart';
import 'UserInfo.dart';

class UserInfoPage extends StatefulWidget {
  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  String gender = '';
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  double bmi = 23.0;
  void setDefaultValues() {
    setState(() {
      nicknameController.text = "홍길동";
      heightController.text = "170";
      weightController.text = "65";
      gender = "남자";
      bmi = 22.5;
    });
  }
  void _updateBMI(String _) {
    final height = double.tryParse(heightController.text) ?? 0;
    final weight = double.tryParse(weightController.text) ?? 0;

    if (height > 0 && weight > 0) {
      setState(() {
        bmi = weight / ((height / 100) * (height / 100));
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFF670C),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            Text("RPM", style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.black)),
            SizedBox(height: 30),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage('assets/images/tongtongtong.png'), // 캐릭터 이미지 경로
                ),
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.add, size: 16),
                ),
              ],
            ),
            SizedBox(height: 30),
            _buildInputField(nicknameController, '별명'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildChoiceChip('여자'),
                SizedBox(width: 16),
                _buildChoiceChip('남자'),
              ],
            ),
            SizedBox(height: 20),
            _buildInputField(heightController, '키', suffix: 'cm', isNumber: true, onChanged: _updateBMI),
            SizedBox(height: 20),
            _buildInputField(weightController, '체중', suffix: 'kg', isNumber: true, onChanged: _updateBMI),            SizedBox(height: 24),
            _buildBMISlider(),
            SizedBox(height: 35),
            Row(
              children: [

                SizedBox(width: 6),
                Expanded(
                  child: _buildRoundedButton("다음", () {
                    final height = double.tryParse(heightController.text) ?? 0;
                    final weight = double.tryParse(weightController.text) ?? 0;

                    if (height > 0 && weight > 0) {
                      setState(() {
                        bmi = weight / ((height / 100) * (height / 100));
                      });
                    }

                    final user = UserInfo(
                      nickname: nicknameController.text,
                      gender: gender,
                      height: height,
                      weight: weight,
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SelectGenrePage()),
                    );
                  }),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String label, {bool isNumber = false, String? suffix, void Function(String)? onChanged}) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.black26, offset: Offset(2, 2), blurRadius: 4)],
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          suffixText: suffix,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }


  Widget _buildChoiceChip(String label) {
    return Container(
      decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.black26, offset: Offset(2, 2), blurRadius: 4)]),
      child: ChoiceChip(
        label: Text(label),
        selected: gender == label,
        onSelected: (_) => setState(() => gender = label),
        selectedColor: Colors.white,
        backgroundColor: Colors.white,
        labelStyle: TextStyle(color: Colors.black),
      ),
    );
  }

  Widget _buildBMISlider() {
    final bool isInitial = bmi == 23.0;
    double totalWidth = MediaQuery.of(context).size.width - 48;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isInitial ? "BMI" : "BMI : ${bmi.toStringAsFixed(2)}",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        SizedBox(height: 8),
        Stack(
          children: [
            Row(
              children: [
                _bmiSection(Colors.blue, flex: 2),
                _bmiSection(Colors.lightGreenAccent, flex: 3),
                _bmiSection(Colors.orangeAccent.shade100, flex: 2),
                _bmiSection(Colors.redAccent.shade200, flex: 3),
              ],
            ),
            // 📍 핀 위치 (BMI 결과값 기반)
            if (!isInitial)
              Positioned(
                top: 2,
                left: calculateBMIOffset(bmi, totalWidth),
                child: Icon(Icons.location_pin, size: 20, color: Colors.black),
              ),
          ],
        ),
        SizedBox(height: 8),
        // BMI 구간 경계 텍스트
        Stack(
          children: [
            Container(height: 20),
            Positioned(
              left: calculateBMIStaticOffset(0.20, totalWidth), // 18.5 위치
              child: Text("18.5", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Positioned(
              left: calculateBMIStaticOffset(0.50, totalWidth), // 23 위치
              child: Text("23", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Positioned(
              left: calculateBMIStaticOffset(0.70, totalWidth), // 25 위치
              child: Text("25", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _bmiSection(Color color, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Container(
        height: 24,
        color: color,
      ),
    );
  }
  double calculateBMIStaticOffset(double percent, double totalWidth) {
    return totalWidth * percent;
  }

  double calculateBMIOffset(double bmi, double totalWidth) {
    // BMI 구간: 15~35 → 10등분 기준
    double percent;

    if (bmi < 18.5) {
      percent = 0.2 * (bmi - 15) / (18.5 - 15);
    } else if (bmi < 23) {
      percent = 0.2 + 0.3 * (bmi - 18.5) / (23 - 18.5);
    } else if (bmi < 25) {
      percent = 0.5 + 0.2 * (bmi - 23) / (25 - 23);
    } else if (bmi <= 35) {
      percent = 0.7 + 0.3 * (bmi - 25) / (35 - 25);
    } else {
      percent = 1.0;
    }

    // totalWidth 내에서 위치 계산 + 좌우 벗어나지 않도록 보정
    final offset = percent * totalWidth;
    return offset.clamp(0.0, totalWidth - 14);
  }

  Widget _buildRoundedButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          padding: EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: Text(text, style: TextStyle(fontSize: 16)),
      ),
    );
  }
}