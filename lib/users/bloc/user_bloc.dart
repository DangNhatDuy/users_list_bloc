import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:demo_flutter_application/users/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:stream_transform/stream_transform.dart';

part 'user_event.dart';
part 'user_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc({required this.httpClient}) : super(const UserState()) {
    on<UserFetched>(
      _onUserFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }
  final http.Client httpClient;

  Future<void> _onUserFetched(
      UserFetched event, Emitter<UserState> emit) async {
    if (state.hasReachMax) return;
    try {
      if (state.status == Status.initial) {
        final users = await _fetchUsers(state.page);
        emit(state.copyWith(
          status: Status.success,
          users: users,
          page: state.page + 1,
          hasReachMax: false,
        ));
      }

      final users = await _fetchUsers(state.page);
      users.isEmpty
          ? emit(state.copyWith(hasReachMax: true))
          : emit(
              state.copyWith(
                status: Status.success,
                users: List.of(state.users)..addAll(users),
                page: state.page + 1,
                hasReachMax: false,
              ),
            );
    } catch (_) {
      emit(state.copyWith(status: Status.failure));
    }
  }

  Future<List<User>> _fetchUsers(int page) async {
    final response = await httpClient.get(
      Uri.https(
        'reqres.in',
        '/api/users',
        <String, String>{'page': '$page'},
      ),
    );

    if (response.statusCode == 200) {
      final userResponse = UserResponse.fromJson(json.decode(response.body));
      return userResponse.data ?? [];
    }
    throw Exception('error fetching users');
  }
}
