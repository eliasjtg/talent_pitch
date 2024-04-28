abstract class BaseModel {
  /// [id]
  final int id;

  /// [baseModelType]
  final String baseModelType;

  /// [video] url
  final String? video;

  /// BaseModel contructor
  BaseModel({required this.id, required this.baseModelType, this.video});

  /// Define toJson conversion
  Map<String, dynamic> toJson();
}
