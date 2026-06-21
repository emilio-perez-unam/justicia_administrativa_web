enum UserRole {
  admin('admin'),
  team('team'),
  client('client');

  final String value;
  const UserRole(this.value);

  static UserRole fromString(String? value) => UserRole.values.firstWhere(
    (e) => e.value == value,
    orElse: () => UserRole.client,
  );

  bool get isAdmin => this == UserRole.admin;
  bool get isTeamOrAbove => this == UserRole.admin || this == UserRole.team;
}
