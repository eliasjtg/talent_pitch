import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:talent_pitch/app/models/company.dart';

/// Associates our `companies_response.dart` with the code generated by Freezed
part 'companies_response.freezed.dart';

/// Since our CompaniesResponse class is serializable, we must add this line.
part 'companies_response.g.dart';

@freezed
class CompaniesResponse with _$CompaniesResponse {
  const factory CompaniesResponse({
    required List<Company> data,
  }) = _CompaniesResponse;

  factory CompaniesResponse.fromJson(Map<String, Object?> json) =>
      _$CompaniesResponseFromJson(json);
}
