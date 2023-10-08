import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_social/shared/data/models/profile_model.dart';
import 'package:flutter_social/shared/domain/entities/profile.dart';

import '../../../../fixtures/fixtures.dart';

void main() {
  group(
    'ProfileModel',
    () {
      test(
        'fromJson will built a ProfileModel from given json',
        () {
          final profile =
              ProfileModel.fromJson(jsonFromFixture('profile_fixture.json'));
          expect(profile, isA<ProfileModel>());
        },
      );

      test(
        'toJson will be parsed to json',
        () {
          final json = jsonFromFixture('profile_fixture.json');

          final profile = ProfileModel.fromJson(json);

          expect(
            profile.toJson(),
            json,
          );
        },
      );

      test(
        'toEntity will convert ProfileModel to Profile',
        () {
          final json = jsonFromFixture('profile_fixture.json');

          final profile = ProfileModel.fromJson(json);

          expect(
            profile.toEntity(),
            isA<Profile>(),
          );
        },
      );
    },
  );
}
