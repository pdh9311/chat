class Member {
  final String uid;
  final String email;

  Member({
    required this.uid,
    required this.email,
  });

  factory Member.fromJson(Map<String, dynamic> map) {
    return Member(
      uid: map["uid"],
      email: map["email"],
    );
  }

  @override
  String toString() {
    return 'members{uid: $uid, email: $email}';
  }
}
