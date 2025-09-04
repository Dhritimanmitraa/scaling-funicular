import '../../../../core/network/api_client.dart';

abstract class ProfileRemoteDataSource {
  Future<Map<String, dynamic>> getUserProgress();
  Future<void> updateUserProgress(Map<String, dynamic> progress);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiClient apiClient;

  ProfileRemoteDataSourceImpl(this.apiClient);

  @override
  Future<Map<String, dynamic>> getUserProgress() async {
    // Placeholder implementation
    throw UnimplementedError('Profile features to be implemented');
  }

  @override
  Future<void> updateUserProgress(Map<String, dynamic> progress) async {
    // Placeholder implementation
    throw UnimplementedError('Profile features to be implemented');
  }
}
