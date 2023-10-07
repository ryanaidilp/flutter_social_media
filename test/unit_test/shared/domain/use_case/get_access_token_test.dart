import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_social/core/failures/failures.dart';
import 'package:flutter_social/core/use_case/use_case.dart';
import 'package:flutter_social/shared/domain/repositories/access_token_repository.dart';

import 'package:flutter_social/shared/domain/use_case/get_access_token.dart';

import '../../../../helpers/test_injection.dart';

class MockAccessTokenRepository extends Mock implements AccessTokenRepository {}

void main() {
  late AccessTokenRepository mockRepository;
  late GetAccessToken usecase;

  setUpAll(
    () {
      mockRepository = MockAccessTokenRepository();
      registerTestLazySingleton<AccessTokenRepository>(mockRepository);
      usecase = GetAccessToken();
    },
  );
  const token = '125ksa2l10sV<a9aD';
  group(
    'GetAccessToken',
    () {
      test(
        'should give access token if access token exist!',
        () async {
          when(
            () => mockRepository.getAccessToken(),
          ).thenAnswer((_) async => const Right(token));

          final result = await usecase(NoParams());

          expect(result, const Right(token));
          verify(
            () => mockRepository.getAccessToken(),
          ).called(1);
        },
      );

      test(
        'should return NotFoundFailure if access token does not exist!',
        () async {
          when(
            () => mockRepository.getAccessToken(),
          ).thenAnswer((_) async => Left(NotFoundFailure()));

          final result = await usecase(NoParams());

          expect(result, Left(NotFoundFailure()));
          verify(
            () => mockRepository.getAccessToken(),
          ).called(1);
        },
      );

      test(
        'should throw right exception when exception occured!',
        () async {
          when(
            () => mockRepository.getAccessToken(),
          ).thenThrow(Exception());

          final result = usecase(NoParams());

          await expectLater(result, throwsA(isA<Exception>()));
          verify(
            () => mockRepository.getAccessToken(),
          ).called(1);
        },
      );
    },
  );
}
