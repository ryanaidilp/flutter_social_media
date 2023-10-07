import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_social/core/failures/failures.dart';
import 'package:flutter_social/core/use_case/use_case.dart';
import 'package:flutter_social/shared/data/models/profile_model.dart';
import 'package:flutter_social/shared/domain/entities/profile.dart';
import 'package:flutter_social/shared/domain/repositories/profile_repository.dart';
import 'package:flutter_social/shared/domain/use_case/get_profile.dart';

import '../../../../fixtures/fixtures.dart';
import '../../../../helpers/test_injection.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late ProfileRepository mockRepository;
  late GetProfile usecase;
  late Profile profile;

  setUpAll(
    () {
      mockRepository = MockProfileRepository();
      registerTestLazySingleton<ProfileRepository>(mockRepository);
      usecase = GetProfile();
      final json = jsonFromFixture('profile_fixture.json');
      profile = ProfileModel.fromJson(json);
    },
  );

  group(
    'GetProfile',
    () {
      test(
        'should return Profile if profile exist!',
        () async {
          when(
            () => mockRepository.getProfile(),
          ).thenAnswer((_) async => Right(profile));

          final result = await usecase(NoParams());

          expect(result, Right(profile));
          verify(
            () => mockRepository.getProfile(),
          ).called(1);
        },
      );

      test(
        'should return NotFoundFailure if profile not exist!',
        () async {
          when(
            () => mockRepository.getProfile(),
          ).thenAnswer((_) async => Left(NotFoundFailure()));

          final result = await usecase(NoParams());

          expect(result, Left(NotFoundFailure()));
          verify(
            () => mockRepository.getProfile(),
          ).called(1);
        },
      );
    },
  );
}
