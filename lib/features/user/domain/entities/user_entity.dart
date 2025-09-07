class ENTUser {
  final String id;
  final String name;
  final int age;

  final String? email;
  final String? avatar;
  final String? bio;

  final String grade;
  final String hobbies;

  const ENTUser({
    required this.id,
    required this.name,
    required this.age,
    this.email,
    this.avatar,
    this.bio,
    required this.grade,
    required this.hobbies,
  });

  static ENTUser test = ENTUser(
    id: '1',
    name: 'Anh Triệu đẹp trai vl',
    age: 20,
    email: '',
    bio: 'ngu vkl địt mẹ mày vkl luôn địt con mẹ mày ádads adada vkl',
    grade: 'Lớp 12',
    hobbies: 'Ngu'
  );
}