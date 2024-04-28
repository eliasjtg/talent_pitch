import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:talent_pitch/app/models/base_model.dart';
import 'package:talent_pitch/app/models/challenge.dart';
import 'package:talent_pitch/app/models/company.dart';
import 'package:talent_pitch/app/models/talent.dart';

const storeKey = 'custom_playlist';

BaseModel jsonToBaseModel(Map<String, dynamic> json) {
  switch (json['base_model_type']) {
    case 'talent':
      return Talent.fromJson(json);
    case 'challenge':
      return Challenge.fromJson(json);
    case 'company':
      return Company.fromJson(json);
    default:
      throw Exception('Invalid base_model_type ${json['base_model_type']}');
  }
}

class CustomPlaylistRepository {
  final storage = const FlutterSecureStorage();

  Future<void> save(List<BaseModel> models) async {
    await storage.write(
      key: storeKey,
      value: jsonEncode(
        models
            .map<Map<String, dynamic>>((BaseModel model) => model.toJson())
            .toList(),
      ),
    );
  }

  Future<List<BaseModel>> getModels() async {
    String? value = await storage.read(key: storeKey);

    if (value != null) {
      return (jsonDecode(value) as List<dynamic>)
          .map<BaseModel>(
              (dynamic model) => jsonToBaseModel(model as Map<String, dynamic>))
          .toList();
    }

    return [];
  }

  Future<void> storeModel(BaseModel model) async {
    final models = await getModels();
    models.add(model);
    return save(models);
  }

  Future<void> removeModel(BaseModel model) async {
    final models = await getModels();
    models.remove(model);
    return save(models);
  }
}
