import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:talent_pitch/app/models/challenge.dart';

/// Associates our `challenges_response.dart` with the code generated by Freezed
part 'challenges_response.freezed.dart';

/// Since our ChallengesResponse class is serializable, we must add this line.
part 'challenges_response.g.dart';

@freezed
class ChallengesResponse with _$ChallengesResponse {
  const factory ChallengesResponse({
    required List<Challenge> data,
  }) = _ChallengesResponse;

  factory ChallengesResponse.fromJson(Map<String, Object?> json) =>
      _$ChallengesResponseFromJson(json);
}
