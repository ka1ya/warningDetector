import '../models/setting_model.dart';

class SettingDetails {
  static final SettingDetails _instance = SettingDetails._internal();

  factory SettingDetails() {
    return _instance;
  }

  SettingDetails._internal();

  SettingModel settingsData =
      SettingModel(tickrate: 3, percentValue: 5, switchValue: true);

  void updateSettings(double tickrate, int percentValue, bool switchValue) {
    settingsData = SettingModel(
      tickrate: tickrate,
      percentValue: percentValue,
      switchValue: switchValue,
    );
  }
}
