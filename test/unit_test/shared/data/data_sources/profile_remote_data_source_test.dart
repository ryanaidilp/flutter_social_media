import 'package:flutter_social/core/network/api_endpoint.dart';
import 'package:flutter_social/core/network/http/modules/flutter_social_http_module.dart';
import 'package:flutter_social/shared/data/data_sources/profile_remote_data_source.dart';

import 'package:flutter_social/shared/data/models/profile_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixtures.dart';
import '../../../../helpers/test_injection.dart';

class MockFlutterSocialHttpModule extends Mock
    implements FlutterSocialHttpModule {}

void main() {
  late FlutterSocialHttpModule mockHttpModule;
  late ProfileRemoteDataSource remoteDataSource;

  setUp(
    () {
      mockHttpModule = MockFlutterSocialHttpModule();
      registerTestFactory<FlutterSocialHttpModule>(mockHttpModule);
      remoteDataSource = ProfileRemoteDataSourceImpl();
    },
  );

  group(
    'ProfileRemoteDataSource',
    () {
      final profile = ProfileModel.fromJson(
        jsonFromFixture('profile_fixture.json'),
      );
      group(
        'getProfile',
        () {
          test(
            'should return ProfileModel when request success',
            () async {
              // arrange
              when(
                () => mockHttpModule.get(ApiEndpoint.baseUrl),
              ).thenAnswer(
                (_) async => jsonFromFixture('profile_fixture.json'),
              );

              // act
              final result = await remoteDataSource.getProfile();

              // assert
              expect(result, profile);
              verify(
                () => mockHttpModule.get(ApiEndpoint.baseUrl),
              ).called(1);
            },
          );
        },
      );
    },
  );
}
