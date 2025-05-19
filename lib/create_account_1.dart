import 'package:flutter/material.dart';
import 'create_account_2.dart';
import 'package:flutter/services.dart';  // 숫자 입력 제한용
import 'package:firebase_auth/firebase_auth.dart';  // 파이어베이스 인증 패키지 import// 새로 만든 CreateAccount2Page 파일을 import

// void main() {
//   runApp(SignUpApp());
// }
//
// class SignUpApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: SignUpPage(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

class SignUpPage extends StatelessWidget {
  final Color orange = Color(0xFFFF670C);
  final Color gray = Color(0xFFF1EAE7);

  // 컨트롤러
  final TextEditingController idController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  final TextEditingController pwCheckController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController authCodeController = TextEditingController();


  Widget buildTextField(String label,
      {bool isSmall = false,
        bool obscureText = false,
        TextEditingController? controller,
        TextInputType keyboardType = TextInputType.text,
        List<TextInputFormatter>? inputFormatters,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 5),
        Container(
          width: isSmall ? 80 : double.infinity,
          height: 50,
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: TextInputType.text,
            inputFormatters: inputFormatters,
            enableIMEPersonalizedLearning: true,
            decoration: InputDecoration(
              hintText: label,
              filled: true,
              fillColor: gray,
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget buildDateField(String hint, String suffix) {
    return Expanded( // Expanded로 감싸서 균등 분배
      child: Container(
        height: 50,
        margin: EdgeInsets.symmetric(horizontal: 4), // 간격 조절
        padding: EdgeInsets.only(left: 16),
        decoration: BoxDecoration(
          color: gray,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  hintText: hint,
                  border: InputBorder.none,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 8),
              child: Text(
                suffix,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void signUp(BuildContext context) async {
    final id = idController.text.trim();
    final password = pwController.text.trim();
    final passwordCheck = pwCheckController.text.trim();

    if (id.isEmpty || password.isEmpty || passwordCheck.isEmpty) {
      showSnackbar(context, '아이디와 비밀번호를 모두 입력하세요.');
      return;
    }

    if (password != passwordCheck) {
      showSnackbar(context, '비밀번호가 일치하지 않습니다.');
      return;
    }

    final email = '$id@rpm.com'; // 이메일 형식으로 변환

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      showSnackbar(context, '회원가입 성공!');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AgreementPage()),
      );
    } on FirebaseAuthException catch (e) {
      print('에러코드: ${e.code}');
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = '이미 가입된 아이디입니다.';
          break;
        case 'invalid-email':
          errorMessage = '유효하지 않은 이메일 형식입니다.';
          break;
        case 'operation-not-allowed':
          errorMessage = '이메일/비밀번호 가입이 비활성화되어 있습니다.';
          break;
        case 'weak-password':
          errorMessage = '비밀번호는 최소 6자리 이상이어야 합니다.';
          break;
        default:
          errorMessage = '회원가입에 실패했습니다. 다시 시도해주세요.';
      }

      showSnackbar(context, errorMessage);
    } catch (e) {
      showSnackbar(context, '회원가입 중 오류가 발생했습니다.');
    }
  }


  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: orange,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Text(
                "RPM",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 36,
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 20),
              buildTextField("아이디", controller: idController),
              buildTextField("비밀번호", obscureText: true, controller: pwController),
              buildTextField("비밀번호 재확인", obscureText: true, controller: pwCheckController),
              buildTextField("이름", controller: nameController),

              SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "생년월일",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildDateField("", "년"),
                  buildDateField("", "월"),
                  buildDateField("", "일"),
                ],
              ),
              SizedBox(height: 16),
              buildTextField("이메일"),
              buildTextField("전화번호",
                  keyboardType: TextInputType.number,
                  controller: phoneController,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
              buildTextField("인증번호",
                  keyboardType: TextInputType.number,
                  controller: authCodeController,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () => signUp(context),

                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: gray,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      "다음",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
