import 'package:demo_flutter_application/users/bloc/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/widgets.dart';

class UsersList extends StatefulWidget {
  const UsersList({super.key});

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  final _scrollController = ScrollController();
  var _isListView = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      _onScroll();
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) context.read<UserBloc>().add(UserFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              switch (state.status) {
                case Status.failure:
                  return const Center(child: Text('failed to fetch users'));
                case Status.success:
                  if (state.users.isEmpty) {
                    return const Center(child: Text('no users'));
                  }
                  return _isListView
                      ? ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            return index >= state.users.length
                                ? const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.0),
                                    child: BottomLoader(),
                                  )
                                : UserListItem(user: state.users[index]);
                          },
                          itemCount: state.hasReachMax
                              ? state.users.length
                              : state.users.length + 1,
                          controller: _scrollController,
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: GridView.builder(
                            itemCount: state.hasReachMax
                                ? state.users.length
                                : state.users.length + 1,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1.2,
                            ),
                            itemBuilder: (context, index) {
                              return index >= state.users.length
                                  ? const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8.0),
                                      child: BottomLoader(),
                                    )
                                  : UserGridItem(user: state.users[index]);
                            },
                            controller: _scrollController,
                          ),
                        );
                case Status.initial:
                  return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          Positioned(
            bottom: 32.0,
            right: 16.0,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                _isListView = !_isListView;
                setState(() {});
              },
              child: Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Icon(
                  _isListView ? Icons.grid_view : Icons.list,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
