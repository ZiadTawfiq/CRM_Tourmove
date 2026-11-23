import '../models/crm_models.dart';
import 'api_client.dart';
import 'api_config.dart';
import 'crm_demo_data.dart';

class ProjectService {
  final ApiClient _client = ApiClient();
  final ApiConfig _config = ApiConfig();

  List<ProjectModel> _cachedProjects = [];

  ProjectService() {
    _cachedProjects = CrmDemoData.getProjects();
  }

  Future<List<ProjectModel>> getAll() async {
    if (_config.isDemoMode) {
      return List.unmodifiable(_cachedProjects);
    }

    try {
      final res = await _client.get('/Project');
      if (res is List) {
        _cachedProjects = res.map((item) => ProjectModel.fromJson(item)).toList();
      }
      return List.unmodifiable(_cachedProjects);
    } catch (_) {
      return List.unmodifiable(_cachedProjects);
    }
  }

  Future<ProjectModel> create(String name, String location, double startingPrice) async {
    final newProject = ProjectModel(
      id: DateTime.now().millisecondsSinceEpoch,
      name: name,
      location: location,
      startingPrice: startingPrice,
    );

    if (_config.isDemoMode) {
      _cachedProjects.add(newProject);
      return newProject;
    }

    try {
      final res = await _client.post('/Project', newProject.toJson());
      final created = ProjectModel.fromJson(res);
      _cachedProjects.add(created);
      return created;
    } catch (_) {
      _cachedProjects.add(newProject);
      return newProject;
    }
  }

  void reset() {
    _cachedProjects = CrmDemoData.getProjects();
  }
}

