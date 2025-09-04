import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/repositories/profile_repository.dart';

// Events
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileProgressRequested extends ProfileEvent {
  const ProfileProgressRequested();
}

// States
abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError({required this.message});

  @override
  List<Object> get props => [message];
}

// Bloc
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileService;

  ProfileBloc({required this.profileService}) : super(const ProfileInitial()) {
    on<ProfileProgressRequested>(_onProgressRequested);
  }

  Future<void> _onProgressRequested(
    ProfileProgressRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());
    
    final result = await profileService.getUserProgress();
    result.fold(
      (failure) => emit(ProfileError(message: failure.message)),
      (progress) => emit(const ProfileInitial()), // Placeholder
    );
  }
}
