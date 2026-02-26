import 'package:flutter/material.dart';
import 'package:vivocare/features/home/model/home_menu_item.dart';

class HomeViewModel extends ChangeNotifier {
  String _userName = 'Jiwan Prakash Mishra';

  final int todayVisits = 15;
  final int doctorVisits = 15;
  final int chemistVisits = 0;

  // only the four primary items shown in the sketch
  List<HomeMenuItem> get menuItems => const <HomeMenuItem>[
    HomeMenuItem(label: 'Home', icon: Icons.home_outlined, isActive: true),
    HomeMenuItem(label: 'Plan & Meet', icon: Icons.event_note_outlined),
    HomeMenuItem(label: 'Performance', icon: Icons.trending_up_outlined),
    HomeMenuItem(label: 'Logout', icon: Icons.logout_outlined),
  ];

  String get warningMessage =>
      'WARNING: FULL SYNC NOT SUCCESSFUL! Go to Settings > click Sync Now button to avoid data issues.';

  String get userName => _userName;

  String get employeeMeta => '(FLM | Discovery | 1465)';

  String get greeting {
    final int hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning!';
    }
    if (hour < 17) {
      return 'Good Afternoon!';
    }
    return 'Good Evening!';
  }

  String get formattedDate {
    final DateTime now = DateTime.now();
    const List<String> weekdays = <String>[
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    const List<String> months = <String>[
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${weekdays[now.weekday - 1]}, ${now.day} ${months[now.month - 1]} ${now.year}';
  }

  String get todaysTip => 'No Record Found';

  void initializeFromArgs(Object? args) {
    if (args is! String) {
      return;
    }

    final String trimmed = args.trim();
    if (trimmed.isEmpty || trimmed == _userName) {
      return;
    }

    _userName = trimmed;
    notifyListeners();
  }
}
