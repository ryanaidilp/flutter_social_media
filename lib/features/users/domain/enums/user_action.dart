enum UserAction {
  follow,
  unfollow,
  none;

  String get message => switch (this) {
    follow => 'Following!',
    unfollow => 'Unfollowing!',
    none => '',
  };
}
