import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin D2RemoteMixin {
  static const String currentDatabaseNameKey = 'databaseName';

  static Future<String?> getDatabaseName(
      {Future<SharedPreferences>? sharedPreferenceInstance}) async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs =
        await (sharedPreferenceInstance ?? SharedPreferences.getInstance());
    return prefs.getString(currentDatabaseNameKey);
  }

  /// set the database name for the current user, which the app will
  /// use to store data until the user logs out.
  static Future<bool> setDatabaseName(
      {required String databaseName,
      SharedPreferences? sharedPreferenceInstance}) async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs =
        sharedPreferenceInstance ?? await SharedPreferences.getInstance();
    return prefs.setString(currentDatabaseNameKey, databaseName);
  }
}
