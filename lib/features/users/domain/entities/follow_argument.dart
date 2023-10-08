import 'package:equatable/equatable.dart';

import 'package:flutter_social/features/users/domain/enums/user_action.dart';

class FollowArgument extends Equatable {
  const FollowArgument({
    required this.action,
    required this.username,
  });
  final UserAction action;
  final String username;
  @override
  List<Object> get props => [action, username];
}
