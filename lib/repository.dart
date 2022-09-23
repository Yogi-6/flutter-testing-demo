// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:testing_demo/check_network_connectivity.dart';
import 'package:testing_demo/user.dart';

const dummyUser = User('101', 28, 'John Doe');

abstract class IUserRepository {
  final INetworkConnectivity connectivity;
  final IRemoteDataSource remoteDataSource;
  final ILocalDataSource localDataSource;

  @mustCallSuper
  const IUserRepository({
    required this.connectivity,
    required this.localDataSource,
    required this.remoteDataSource,
  });

  Future<User> getUserDetails();
}

abstract class IRemoteDataSource {
  /// Throws exceptions if something goes wrong. For e.g., ServerException.
  Future<User> getUserDetails();
}

abstract class ILocalDataSource {
  Future<User> getUserDetails();

  Future<void> cacheUserDetails(User user);
}

class RemoteDataSource implements IRemoteDataSource {
  @override
  Future<User> getUserDetails() async => dummyUser;
}

class LocalDataSource implements ILocalDataSource {
  @override
  Future<void> cacheUserDetails(User user) async {
    // Cache user

    return;
  }

  @override
  Future<User> getUserDetails() async => dummyUser;
}

class UserRepository implements IUserRepository {
  @override
  final INetworkConnectivity connectivity;

  @override
  final IRemoteDataSource remoteDataSource;

  @override
  final ILocalDataSource localDataSource;

  const UserRepository({
    required this.connectivity,
    required this.localDataSource,
    required this.remoteDataSource,
  }) : super();

  @override
  Future<User> getUserDetails() async {
    if (!(await connectivity.hasConnection))
      return localDataSource.getUserDetails();

    final user = await remoteDataSource.getUserDetails();

    await localDataSource.cacheUserDetails(user);

    return user;
  }
}
