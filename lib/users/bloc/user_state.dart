part of 'user_bloc.dart';

enum Status { initial, success, failure }

class UserState extends Equatable {
  final Status status;
  final List<User> users;
  final int page;
  final bool hasReachMax;

  const UserState({
    this.status = Status.initial,
    this.users = const [],
    this.page = 1,
    this.hasReachMax = false,
  });

  UserState copyWith({
    Status? status,
    List<User>? users,
    int? page,
    bool? hasReachMax,
  }) {
    return UserState(
      status: status ?? this.status,
      users: users ?? this.users,
      page: page ?? this.page,
      hasReachMax: hasReachMax ?? this.hasReachMax,
    );
  }

  @override
  List<Object?> get props => [status, users, page, hasReachMax];
}
