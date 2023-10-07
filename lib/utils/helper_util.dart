class HelperUtil {

  factory HelperUtil() {
    return _instance;
  }
  const HelperUtil._();

  static const HelperUtil _instance = HelperUtil._();

  static String getAvatarUrl({
    required String name, String? avatar,
    String bgColor = '054A80',
    String textColor = 'FFFFFF',
  }) {
    if (avatar != null && avatar.isNotEmpty && !avatar.contains('ui-avatars')) {
      return avatar;
    }

    final uri = Uri(
      scheme: 'https',
      host: 'ui-avatars.com',
      path: 'api/',
      queryParameters: {
        'name': name,
        'size': '256',
        'color': textColor,
        'background': bgColor,
      },
    );

    return uri.toString();
  }
}
