class UserModel {
  final String uid;
  final String email;
  final String? displayName;
  final String? phoneNumber;
  final List<String> roles;
  final String status;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.email,
    this.displayName,
    this.phoneNumber,
    this.roles = const ['user'],
    this.status = 'active',
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> data, String documentId) {
    return UserModel(
      uid: documentId,
      email: data['email'] ?? '',
      displayName: data['displayName'],
      phoneNumber: data['phoneNumber'],
      roles: List<String>.from(data['roles'] ?? ['user']),
      status: data['status'] ?? 'active',
      createdAt: data['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'phoneNumber': phoneNumber,
      'roles': roles,
      'status': status,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  bool get isAdmin => roles.contains('admin');
  bool get isUser => roles.contains('user');
  bool get isActive => status == 'active';
  bool get hasMultipleRoles => roles.length > 1;
}
