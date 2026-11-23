import '../models/crm_enums.dart';
import '../models/crm_models.dart';
import 'api_client.dart';
import 'api_config.dart';
import 'crm_demo_data.dart';

class EmployeeService {
  final ApiClient _client = ApiClient();
  final ApiConfig _config = ApiConfig();

  List<EmployeeModel> _cachedEmployees = [];

  EmployeeService() {
    _cachedEmployees = CrmDemoData.getEmployees();
  }

  Future<List<EmployeeModel>> getAll() async {
    if (_config.isDemoMode) {
      return List.unmodifiable(_cachedEmployees);
    }

    try {
      final res = await _client.get('/Employee');
      if (res is List) {
        _cachedEmployees = res.map((item) => EmployeeModel.fromJson(item)).toList();
      }
      return List.unmodifiable(_cachedEmployees);
    } catch (_) {
      return List.unmodifiable(_cachedEmployees);
    }
  }

  Future<EmployeeModel?> getById(String id) async {
    final list = await getAll();
    try {
      return list.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<List<EmployeeModel>> getByRole(EmployeeRole role) async {
    final list = await getAll();
    return list.where((e) => e.role == role.id).toList();
  }

  void reset() {
    _cachedEmployees = CrmDemoData.getEmployees();
  }
}

