class ApiConfig {
  static final ApiConfig _instance = ApiConfig._internal();
  factory ApiConfig() => _instance;
  ApiConfig._internal();

  /// Default API URL for ASP.NET Core backend
  String baseUrl = 'http://localhost:5000/api';

  /// Toggle Demo Mode:
  /// Set to false so the application operates in 100% Real API Mode connected to the live ASP.NET Core backend.
  bool isDemoMode = false;

  /// Current JWT token
  String? token;

  /// Android emulator loopback alias
  void useAndroidEmulatorUrl() {
    baseUrl = 'http://10.0.2.2:5000/api';
  }

  /// Localhost for Web / Desktop / iOS Simulator
  void useLocalhostUrl() {
    baseUrl = 'http://localhost:5000/api';
  }

  Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };
}

