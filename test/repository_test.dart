import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:testing_demo/check_network_connectivity.dart';
import 'package:testing_demo/repository.dart';
import 'package:testing_demo/user.dart';

class MockNetworkConnectivity extends Mock implements INetworkConnectivity {}

class MockLocalDataSource extends Mock implements ILocalDataSource {}

class MockRemoteDataSource extends Mock implements IRemoteDataSource {}

class FakeUser extends Fake implements User {}

// const dummyUser = User('some_id', 20, 'John Doe');

void main() {
  late MockNetworkConnectivity mockNetworkConnectivity;
  late MockLocalDataSource mockLocalDataSource;
  late MockRemoteDataSource mockRemoteDataSource;
  late UserRepository systemUnderTest;

  setUp(() {
    mockNetworkConnectivity = MockNetworkConnectivity();
    mockLocalDataSource = MockLocalDataSource();
    mockRemoteDataSource = MockRemoteDataSource();

    systemUnderTest = UserRepository(
      connectivity: mockNetworkConnectivity,
      localDataSource: mockLocalDataSource,
      remoteDataSource: mockRemoteDataSource,
    );

    registerFallbackValue(FakeUser());
  });

  test("mockLocalDataSource is a type of ILocalDataSource", () {
    expect(mockLocalDataSource, isA<ILocalDataSource>());
  });

  test("mockRemoteDataSource is a type of IRemoteDataSource", () {
    expect(mockRemoteDataSource, isA<IRemoteDataSource>());
  });

  test("mockNetworkConnectivity is a type of NetworkConnectivity", () {
    expect(mockNetworkConnectivity, isA<INetworkConnectivity>());
  });

  group("getUserDetails", () {
    test(
      'Should fetch the user details from remote and cache it when internet is available.',
      () async {
        when(() => mockNetworkConnectivity.hasConnection)
            .thenAnswer((_) async => true);

        when(() => mockRemoteDataSource.getUserDetails())
            .thenAnswer((_) async => dummyUser);

        when(() => mockLocalDataSource.cacheUserDetails(any()))
            .thenAnswer((_) async => Future.value(null));

        await systemUnderTest.getUserDetails();

        // verify(() => mockRemoteDataSource.getUserDetails()).called(1);
        // verify(() => mockLocalDataSource.cacheUserDetails(any())).called(1);

        verifyInOrder([
          () => mockRemoteDataSource.getUserDetails(),
          () => mockLocalDataSource.cacheUserDetails(any()),
        ]);

        verifyNever(() => mockLocalDataSource.getUserDetails());

        // Some assertion down here
      },
    );
  });

  group("getUserDetails", () {
    test(
      'Should fetch the user details from local when internet is not available.',
      () async {
        when(() => mockNetworkConnectivity.hasConnection)
            .thenAnswer((_) async => false);

        when(() => mockLocalDataSource.getUserDetails())
            .thenAnswer((_) async => dummyUser);

        await systemUnderTest.getUserDetails();

        verify(() => mockLocalDataSource.getUserDetails()).called(1);

        verifyNever(() => mockRemoteDataSource.getUserDetails());
        verifyNever(() => mockLocalDataSource.cacheUserDetails(any()));
      },
    );
  });
}
