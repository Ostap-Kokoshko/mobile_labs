class SettingsState {
  final bool connected;
  final String scannedData;
  final String? receivedSerial;
  final String? deviceId;
  final bool infoLoaded;

  SettingsState({
    required this.connected,
    required this.scannedData,
    required this.receivedSerial,
    required this.deviceId,
    required this.infoLoaded,
  });

  factory SettingsState.initial() => SettingsState(
    connected: false,
    scannedData: '',
    receivedSerial: null,
    deviceId: null,
    infoLoaded: false,
  );

  SettingsState copyWith({
    bool? connected,
    String? scannedData,
    String? receivedSerial,
    String? deviceId,
    bool? infoLoaded,
  }) {
    return SettingsState(
      connected: connected ?? this.connected,
      scannedData: scannedData ?? this.scannedData,
      receivedSerial: receivedSerial ?? this.receivedSerial,
      deviceId: deviceId ?? this.deviceId,
      infoLoaded: infoLoaded ?? this.infoLoaded,
    );
  }
}