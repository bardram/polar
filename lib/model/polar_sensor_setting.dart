part of '../polar.dart';

class PolarSensorSetting {
  final Map<PolarSettingType, int> settings;

  PolarSensorSetting(this.settings);

  Map<String, dynamic> toJson() {
    if (Platform.isIOS) {
      return Map.fromIterable(settings.entries,
          key: (e) => PolarSettingType.values.indexOf(e.key).toString(), value: (e) => e.value);
    } else {
      // This is Android
      return Map.fromIterable(settings.entries,
          key: (e) => e.key.toString().toScreamingSnakeCase(), value: (e) => e.value);
    }
  }
}

enum PolarSettingType {
  /// sample rate in hz
  sampleRate,

  /// resolution in bits
  resolution,

  /// range
  range,

  /// range with min and max allowed values
  rangeMilliunit,

  /// amount of channels available
  channels,

  /// type is unknown
  unknown,
}