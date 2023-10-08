part of 'users_bloc.dart';

abstract class UsersState extends Equatable {
  const UsersState();  

  @override
  List<Object> get props => [];
}
class UsersInitial extends UsersState {}
