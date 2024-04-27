abstract class BaseModel {
  /// [id]
  final int id;

  /// [baseModelType]
  final String baseModelType;

  /// [video] url
  final String? video;

  BaseModel({required this.id, required this.baseModelType, this.video});
}
