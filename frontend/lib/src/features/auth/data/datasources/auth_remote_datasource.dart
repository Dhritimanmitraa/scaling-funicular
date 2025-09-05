import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/auth_response_model.dart';
import '../models/auth_user_model.dart';
import '../../domain/entities/login_request.dart';
import '../../domain/entities/register_request.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login(LoginRequest request);
  Future<AuthResponseModel> register(RegisterRequest request);
  Future<void> logout();
  Future<AuthUserModel> getCurrentUser();
  Future<AuthUserModel> updateUserCurriculum({
    required String boardId,
    required String classId,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl(this.apiClient);

  @override
  Future<AuthResponseModel> login(LoginRequest request) async {
    final response = await apiClient.post(
      AppConstants.loginEndpoint,
      data: {
        'email': request.email,
        'password': request.password,
      },
    );

    // Backend returns: { success, message, data: { user: {...}, token: '...' } }
    final body = response.data as Map?;
    final data = body?['data'] as Map?;
    if (data == null) {
      throw Exception(body?['message'] ?? AppConstants.serverErrorMessage);
    }

    final userJson = (data['user'] as Map?)?.cast<String, dynamic>();
    final token = data['token'] as String?;
    if (userJson == null || token == null) {
      throw Exception('Invalid login response');
    }

    return AuthResponseModel(
      user: AuthUserModel.fromJson(userJson),
      accessTokenField: token,
      refreshTokenField: '',
    );
  }

  @override
  Future<AuthResponseModel> register(RegisterRequest request) async {
    final response = await apiClient.post(
      AppConstants.registerEndpoint,
      data: {
        'email': request.email,
        'password': request.password,
        if (request.boardId != null) 'selectedBoardId': request.boardId,
        if (request.classId != null) 'selectedClassId': request.classId,
      },
    );

    // Handle duplicate email
    if (response.statusCode == 409) {
      throw Exception('Email already in use');
    }

    // Backend returns: { success, message, data: { user: {...}, token: '...' } }
    final body = response.data as Map?;
    final data = body?['data'] as Map?;
    if (data == null) {
      throw Exception(body?['message'] ?? AppConstants.serverErrorMessage);
    }

    final userJson = (data['user'] as Map?)?.cast<String, dynamic>();
    final token = data['token'] as String?;
    if (userJson == null || token == null) {
      throw Exception('Invalid registration response');
    }

    return AuthResponseModel(
      user: AuthUserModel.fromJson(userJson),
      accessTokenField: token,
      refreshTokenField: '',
    );
  }

  @override
  Future<void> logout() async {
    await apiClient.post(AppConstants.logoutEndpoint);
  }

  @override
  Future<AuthUserModel> getCurrentUser() async {
    final response = await apiClient.get(AppConstants.profileEndpoint);
    return AuthUserModel.fromJson(response.data);
  }

  @override
  Future<AuthUserModel> updateUserCurriculum({
    required String boardId,
    required String classId,
  }) async {
    final response = await apiClient.put(
      AppConstants.updateProfileEndpoint,
      data: {
        'board_id': boardId,
        'class_id': classId,
      },
    );

    return AuthUserModel.fromJson(response.data);
  }
}
