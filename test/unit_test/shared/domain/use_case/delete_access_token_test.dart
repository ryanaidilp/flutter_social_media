import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_social/core/failures/failures.dart';
import 'package:flutter_social/core/use_case/use_case.dart';
import 'package:flutter_social/shared/domain/repositories/access_token_repository.dart';
import 'package:flutter_social/shared/domain/use_case/delete_access_token.dart';

import '../../../../helpers/test_injection.dart';

class MockAccessTokenRepository extends Mock implements AccessTokenRepository {}

void main() {
  late AccessTokenRepository mockRepository;
  late DeleteAccessToken usecase;

  setUpAll(
    () {
      mockRepository = MockAccessTokenRepository();
      registerTestLazySingleton<AccessTokenRepository>(mockRepository);
      usecase = DeleteAccessToken();
    },
  );

  group(
    'DeleteAccessToken',
    () {
      test(
        'should return true if access token deleted successfuly',
        () async {
          when(
            () => mockRepository.deleteAccessToken(),
          ).thenAnswer((_) async => const Right(true));

          final result = await usecase(NoParams());

          expect(result, const Right(true));
          verify(
            () => mockRepository.deleteAccessToken(),
          ).called(1);
        },
      );

      test(
        'should return false if access token failed to delete',
        () async {
          when(
            () => mockRepository.deleteAccessToken(),
          ).thenAnswer((_) async => const Right(false));

          final result = await usecase(NoParams());

          expect(result, const Right(false));
          verify(
            () => mockRepository.deleteAccessToken(),
          ).called(1);
        },
      );

      test(
        'should return ClientFailure when exception occured!',
        () async {
          when(
            () => mockRepository.deleteAccessToken(),
          ).thenAnswer((_) async => Left(ClientFailure()));

          final result = await usecase(NoParams());

          expect(result, Left(ClientFailure()));
          verify(
            () => mockRepository.deleteAccessToken(),
          ).called(1);
        },
      );

      test(
        'should throw right exception when exception occured!',
        () async {
          when(
            () => mockRepository.deleteAccessToken(),
          ).thenThrow(Exception());

          final result = usecase(NoParams());

          await expectLater(result, throwsA(isA<Exception>()));
          verify(
            () => mockRepository.deleteAccessToken(),
          ).called(1);
        },
      );
    },
  );
}
