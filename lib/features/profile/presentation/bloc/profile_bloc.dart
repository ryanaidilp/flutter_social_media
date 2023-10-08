import 'package:bloc/bloc.dart';
import 'package:flutter_social/core/failures/failures.dart';
import 'package:flutter_social/features/home/domain/entities/post.dart';
import 'package:flutter_social/shared/domain/entities/graphql_response.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_event.dart';
part 'profile_state.dart';
part 'profile_bloc.freezed.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(const _Initial()) {
    on<ProfileEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
