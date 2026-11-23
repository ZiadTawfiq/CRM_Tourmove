import '../models/crm_models.dart';
import 'api_client.dart';
import 'api_config.dart';
import 'crm_demo_data.dart';

class AuthService {
  final ApiClient _client = ApiClient();
  final ApiConfig _config = ApiConfig();

  EmployeeModel? _currentUser;
  EmployeeModel? get currentUser => _currentUser;

  AuthService() {
    // Default logged in user for demo
    _currentUser = CrmDemoData.getEmployees().first; // Admin
  }

  Future<AuthResponseModel> login(String email, String password) async {
    if (_config.isDemoMode) {
      // Find matching employee or default
      final employees = CrmDemoData.getEmployees();
      final user = employees.firstWhere(
        (e) => e.email.toLowerCase() == email.trim().toLowerCase(),
        orElse: () => employees.first,
      );
      _currentUser = user;
      _config.token = 'demo_jwt_token_${user.id}';
      return AuthResponseModel(
        token: _config.token!,
        expiration: DateTime.now().add(const Duration(days: 7)),
        user: user,
      );
    }

    final res = await _client.post('/Auth/login', {
      'email': email,
      'password': password,
    });

    final authRes = AuthResponseModel.fromJson(res);
    _config.token = authRes.token;
    _currentUser = authRes.user;
    return authRes;
  }

  void logout() {
    _currentUser = null;
    _config.token = null;
  }

  void switchDemoUser(EmployeeModel employee) {
    _currentUser = employee;
    _config.token = 'demo_jwt_token_${employee.id}';
  }

  bool get isAuthenticated => _currentUser != null;
  bool get isAdmin => _currentUser?.role == 1;
}

