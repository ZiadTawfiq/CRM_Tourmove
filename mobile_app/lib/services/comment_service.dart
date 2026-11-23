import '../models/crm_models.dart';
import 'api_client.dart';
import 'api_config.dart';

class CommentService {
  final ApiClient _client = ApiClient();
  final ApiConfig _config = ApiConfig();

  Future<List<CommentModel>> getCommentsByLeadId(int leadId) async {
    if (_config.isDemoMode) {
      return [];
    }

    try {
      final res = await _client.get('/Comment/lead/$leadId');
      if (res is List) {
        return res.map((c) => CommentModel.fromJson(c)).toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  Future<CommentModel> createComment({
    required int leadId,
    required String text,
    String? employeeId,
    String? author,
  }) async {
    final newComment = CommentModel(
      id: DateTime.now().millisecondsSinceEpoch,
      comment: text,
      createdAt: DateTime.now(),
      author: author ?? 'المستخدم',
      employeeId: employeeId,
    );

    if (_config.isDemoMode) {
      return newComment;
    }

    try {
      final res = await _client.post('/Comment', {
        'leadId': leadId,
        'text': text,
        'employeeId': employeeId,
        'createdAt': DateTime.now().toIso8601String(),
      });
      return CommentModel.fromJson(res);
    } catch (_) {
      return newComment;
    }
  }
}

