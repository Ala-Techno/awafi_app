// import 'package:awafi_app/core/errors/api_result.dart';
// import 'package:awafi_app/core/errors/exceptions.dart';
// import 'package:awafi_app/core/services/shared_pref_service.dart';
// import 'package:awafi_app/features/auth/data/datasources/auth_remote_data_source.dart';
// import 'package:awafi_app/features/auth/data/models/user_model.dart';
// import 'package:awafi_app/features/auth/data/repositories/auth_repository_impl.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class FakeAuthRemoteDataSource implements AuthRemoteDataSource {
//   bool shouldFail = false;
//   String tokenToReturn = 'dummy_token_123';

//   @override
//   Future<UserModel> login({
//     required String username,
//     required String password,
//   }) async {
//     if (shouldFail) {
//       throw const ServerException(message: 'Invalid credentials');
//     }
//     return UserModel(
//       id: '1',
//       username: username,
//       email: '$username@example.com',
//       token: tokenToReturn,
//     );
//   }
// }

// void main() {
//   TestWidgetsFlutterBinding.ensureInitialized();

//   late FakeAuthRemoteDataSource fakeRemoteDataSource;
//   late SharedPrefService localDataSource;
//   late AuthRepositoryImpl authRepository;

//   setUp(() async {
//     SharedPreferences.setMockInitialValues({});
//     final pref = await SharedPreferences.getInstance();
//     localDataSource = SharedPrefService(pref);
//     fakeRemoteDataSource = FakeAuthRemoteDataSource();
//     authRepository = AuthRepositoryImpl(
//       remoteDataSource: fakeRemoteDataSource,
//       localDataSource: localDataSource,
//     );
//   });

//   group('AuthRepositoryImpl', () {
//     test('login returns Success and stores token on successful authentication', () async {
//       final result = await authRepository.login(
//         username: 'mor_2314',
//         password: 'password123',
//       );

//       expect(result, isA<Success<dynamic>>());
//       final success = result as Success;
//       expect(success.data.username, 'mor_2314');
//       expect(localDataSource.getString('user_token'), 'dummy_token_123');
//     });

//     test('login returns ApiFailure when server throws exception', () async {
//       fakeRemoteDataSource.shouldFail = true;

//       final result = await authRepository.login(
//         username: 'wrong_user',
//         password: 'wrong_password',
//       );

//       expect(result, isA<ApiFailure<dynamic>>());
//       expect(localDataSource.getString('user_token'), isEmpty);
//     });

//     test('logout clears user token and session data', () async {
//       await localDataSource.setData('user_token', 'valid_token');
//       await localDataSource.setData('username', 'mor_2314');

//       await authRepository.logout();

//       expect(localDataSource.getString('user_token'), isEmpty);
//       expect(localDataSource.getString('username'), isEmpty);
//     });
//   });
// }
