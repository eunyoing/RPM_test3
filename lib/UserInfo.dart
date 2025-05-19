class UserInfo {
  final String nickname;
  final String gender;
  final double height;
  final double weight;

  UserInfo({
    required this.nickname,
    required this.gender,
    required this.height,
    required this.weight,
  });

  double get bmi => weight / ((height / 100) * (height / 100));

  String get bmiCategory {
    if (bmi < 18.5) return '저체중';
    if (bmi < 23) return '정상';
    if (bmi < 25) return '과체중';
    return '비만';
  }
}
