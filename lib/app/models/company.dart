import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:talent_pitch/app/enums/category.dart';
import 'package:talent_pitch/app/models/transformers/nullable_empty_string.dart';
import 'package:talent_pitch/app/models/base_model.dart';

/// Associates our `company.dart` with the code generated by Freezed
part 'company.freezed.dart';

/// Since our Company class is serializable, we must add this line.
part 'company.g.dart';

String companyBaseModel(dynamic value) {
  return 'company';
}

@freezed
class Company extends BaseModel with _$Company {
  const factory Company({
    required int id,
    @Default('company')
    @JsonKey(
        name: 'base_model_type',
        defaultValue: 'company',
        fromJson: companyBaseModel,
        includeToJson: true,
        required: false)
    String baseModelType,
    required String name,
    required String city,
    String? description,
    @JsonKey(fromJson: nullableEmptyString) String? video,
    @JsonKey(fromJson: nullableEmptyString) String? logo,
  }) = _Company;

  factory Company.fromJson(Map<String, Object?> json) =>
      _$CompanyFromJson(json);
}
