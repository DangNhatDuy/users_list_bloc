import 'package:demo_flutter_application/users/bloc/user_bloc.dart';
import 'package:demo_flutter_application/users/view/usser_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
      ),
      body: BlocProvider(
        create: (_) => UserBloc(httpClient: http.Client())..add(UserFetched()),
        child: const UsersList(),
      ),
    );
  }
}
