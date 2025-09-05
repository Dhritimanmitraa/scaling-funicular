import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/login_request.dart';
import '../../domain/entities/register_request.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authService;

  AuthBloc({required this.authService}) : super(const AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthCurriculumUpdateRequested>(_onAuthCurriculumUpdateRequested);
    on<AuthUserRefreshRequested>(_onAuthUserRefreshRequested);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final isLoggedIn = await authService.isLoggedIn();
    if (!isLoggedIn) {
      emit(const AuthUnauthenticated());
      return;
    }

    final result = await authService.getCurrentUser();
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) {
        if (user.hasCompletedCurriculumSelection) {
          emit(AuthAuthenticated(user: user));
        } else {
          emit(AuthCurriculumSelectionRequired(user: user));
        }
      },
    );
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final request = LoginRequest(
      email: event.email,
      password: event.password,
    );

    final result = await authService.login(request);
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (response) {
        if (response.user.hasCompletedCurriculumSelection) {
          emit(AuthAuthenticated(user: response.user));
        } else {
          emit(AuthCurriculumSelectionRequired(user: response.user));
        }
      },
    );
  }

  Future<void> _onAuthRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final request = RegisterRequest(
      email: event.email,
      password: event.password,
      boardId: event.selectedBoardId,
      classId: event.selectedClassId,
    );

    final result = await authService.register(request);
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (response) {
        // If curriculum was provided during registration, user is fully authenticated
        if (event.selectedBoardId != null && event.selectedClassId != null) {
          emit(AuthAuthenticated(user: response.user));
        } else {
          // Otherwise, show curriculum selection
          emit(AuthCurriculumSelectionRequired(user: response.user));
        }
      },
    );
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await authService.logout();
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(const AuthUnauthenticated()),
    );
  }

  Future<void> _onAuthCurriculumUpdateRequested(
    AuthCurriculumUpdateRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await authService.updateUserCurriculum(
      boardId: event.boardId,
      classId: event.classId,
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  Future<void> _onAuthUserRefreshRequested(
    AuthUserRefreshRequested event,
    Emitter<AuthState> emit,
  ) async {
    final result = await authService.getCurrentUser();
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) {
        if (user.hasCompletedCurriculumSelection) {
          emit(AuthAuthenticated(user: user));
        } else {
          emit(AuthCurriculumSelectionRequired(user: user));
        }
      },
    );
  }
}
