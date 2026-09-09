class UserSession {
  final String userCode;
  final String userEmail;

  const UserSession({
    required this.userCode,
    required this.userEmail,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserSession &&
          runtimeType == other.runtimeType &&
          userCode == other.userCode &&
          userEmail == other.userEmail;

  @override
  int get hashCode => userCode.hashCode ^ userEmail.hashCode;

  @override
  String toString() => 'UserSession(userCode: $userCode, userEmail: $userEmail)';
}
