// import 'package:awafi_app/core/errors/api_result.dart';
// import 'package:awafi_app/features/home/data/datasources/home_remote_data_source.dart';
// import 'package:awafi_app/features/home/data/models/product_model.dart';
// import 'package:awafi_app/features/home/data/repositories/home_repository_impl.dart';
// import 'package:awafi_app/features/home/domain/entities/product_entity.dart';
// import 'package:flutter_test/flutter_test.dart';

// class FakeHomeRemoteDataSource implements HomeRemoteDataSource {
//   bool shouldThrow = false;

//   @override
//   Future<List<ProductModel>> getProducts() async {
//     if (shouldThrow) {
//       throw Exception('Server error');
//     }
//     return const [
//       ProductModel(
//         id: 1,
//         title: 'Test Product',
//         price: 99.9,
//         image: 'https://example.com/img.png',
//         description: 'Test description',
//         category: 'electronics',
//         rating: ProductRating(rate: 4.5, count: 10),
//       ),
//     ];
//   }
// }

// void main() {
//   late FakeHomeRemoteDataSource fakeRemoteDataSource;
//   late HomeRepositoryImpl homeRepository;

//   setUp(() {
//     fakeRemoteDataSource = FakeHomeRemoteDataSource();
//     homeRepository = HomeRepositoryImpl(fakeRemoteDataSource);
//   });

//   group('HomeRepositoryImpl', () {
//     test('getProducts returns Success with list of products', () async {
//       final result = await homeRepository.getProducts();

//       expect(result, isA<Success<List<ProductEntity>>>());
//       final success = result as Success<List<ProductEntity>>;
//       expect(success.data.length, 1);
//       expect(success.data.first.title, 'Test Product');
//       expect(success.data.first.rating.rate, 4.5);
//     });

//     test('getProducts returns ApiFailure on server error', () async {
//       fakeRemoteDataSource.shouldThrow = true;

//       final result = await homeRepository.getProducts();

//       expect(result, isA<ApiFailure<List<ProductEntity>>>());
//     });
//   });
// }
