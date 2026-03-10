class HomeUserContext {
  const HomeUserContext({
    required this.userName,
    required this.roleName,
    required this.employeeCode,
  });

  final String userName;
  final String roleName;
  final String employeeCode;

  factory HomeUserContext.fromRouteArgs(Object? args) {
    if (args is HomeUserContext) {
      return args;
    }

    if (args is String) {
      return HomeUserContext(
        userName: args.trim(),
        roleName: '',
        employeeCode: '',
      );
    }

    if (args is Map) {
      final Map<String, dynamic> map = args.map(
        (Object? key, Object? value) =>
            MapEntry<String, dynamic>(key.toString(), value),
      );
      return HomeUserContext(
        userName: _readString(map['user_name']),
        roleName: _readString(map['role_name']),
        employeeCode: _readString(map['employee_code']),
      );
    }

    return const HomeUserContext(userName: '', roleName: '', employeeCode: '');
  }

  static String _readString(Object? value) {
    if (value is String) {
      return value.trim();
    }
    if (value == null) {
      return '';
    }
    return value.toString().trim();
  }
}
