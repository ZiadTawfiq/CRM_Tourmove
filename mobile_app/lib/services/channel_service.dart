import '../models/crm_models.dart';
import 'api_client.dart';
import 'api_config.dart';
import 'crm_demo_data.dart';

class ChannelService {
  final ApiClient _client = ApiClient();
  final ApiConfig _config = ApiConfig();

  List<ChannelModel> _cachedChannels = [];

  ChannelService() {
    _cachedChannels = CrmDemoData.getChannels();
  }

  Future<List<ChannelModel>> getAll() async {
    if (_config.isDemoMode) {
      return List.unmodifiable(_cachedChannels);
    }

    try {
      final res = await _client.get('/Channel');
      if (res is List) {
        _cachedChannels = res.map((item) => ChannelModel.fromJson(item)).toList();
      }
      return List.unmodifiable(_cachedChannels);
    } catch (_) {
      return List.unmodifiable(_cachedChannels);
    }
  }

  Future<ChannelModel> create(String name) async {
    final newChannel = ChannelModel(
      id: DateTime.now().millisecondsSinceEpoch,
      name: name,
    );

    if (_config.isDemoMode) {
      _cachedChannels.add(newChannel);
      return newChannel;
    }

    try {
      final res = await _client.post('/Channel', newChannel.toJson());
      final created = ChannelModel.fromJson(res);
      _cachedChannels.add(created);
      return created;
    } catch (_) {
      _cachedChannels.add(newChannel);
      return newChannel;
    }
  }

  void reset() {
    _cachedChannels = CrmDemoData.getChannels();
  }
}

