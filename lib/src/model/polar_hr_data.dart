/// Polar Heart Rate (HR) data.
class PolarHrData {
  /// HR in BPM.
  final int hr;

  /// RR interval in 1/1024.
  /// R is a the top highest peak in the QRS complex of the ECG wave and RR
  /// is the interval between successive Rs.
  final List<int> rrs;

  /// RR interval in ms.
  final List<int> rrsMs;

  /// Contact status between the device and the user's skin.
  final bool contactStatus;

  /// Is contact dection supported?
  final bool contactStatusSupported;

  /// Create a [PolarHrData] from json
  PolarHrData.fromJson(Map<String, dynamic> json)
      : hr = json['hr'],
        rrs = (json['rrs'] as List).map((e) => e as int).toList(),
        rrsMs = (json['rrsMs'] as List).map((e) => e as int).toList(),
        contactStatus = json['contactStatus'] ?? json['contact'],
        contactStatusSupported =
            json['contactStatusSupported'] ?? json['contactSupported'];
}
